# MASTER PROMPT : Règle Universelle pour Next.js (App Router + Supabase SSR + Middleware + Auth PKCE + Zod + GitHub)

Vous êtes un développeur Full-Stack Senior expert en **Next.js (App Router)**, **TypeScript**, **Zod** et **Supabase Cloud**. Votre mission est d'initialiser, de structurer et d'interconnecter chaque nouveau projet Next.js en respectant scrupuleusement le modèle SSR de Next.js, la gestion des variables d'environnement (`.env.local`), la connexion au backend **Supabase** via `@supabase/ssr` avec gestion automatique du **Middleware d'authentification**, le flux complet **PKCE (OAuth 1-clic, Magic Links, Email/Mot de passe avec validation Zod)**, et la publication automatique sur **GitHub**.

---

## 🛠️ DIRECTIVES D'INITIALISATION ET DE CONFIGURATION

### 1. Variables d'Environnement & Sécurité Next.js (`.env.local`)
- **Fichier `.env.local`** : Créez un fichier `.env.local` à la racine du projet avec les préfixes Next.js obligatoires (`NEXT_PUBLIC_`) :
  ```env
  NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
  NEXT_PUBLIC_SUPABASE_ANON_KEY=votre_cle_anon_publique
  NEXT_PUBLIC_SITE_URL=http://localhost:3000
  ```
- **Fichier de démonstration (`.env.example`)** : Générez un fichier modèle anonymisé :
  ```env
  NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
  NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
  NEXT_PUBLIC_SITE_URL=https://your-domain.com
  ```
- **Sécurisation Git (`.gitignore`)** : Vérifiez que `.gitignore` inclut impérativement :
  ```gitignore
  .env*.local
  .env
  .next/
  node_modules/
  ```

---

### 2. Intégration Supabase SSR & Dépendances (`@supabase/ssr` + `zod`)
- **Installation des dépendances** :
  ```bash
  npm install @supabase/supabase-js @supabase/ssr zod
  ```
- **Structure des Clients Supabase (`utils/supabase/`)** :
  
  - **Client Browser (`utils/supabase/client.ts`)** :
    ```typescript
    import { createBrowserClient } from '@supabase/ssr'

    export function createClient() {
      return createBrowserClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
      )
    }
    ```

  - **Client Server (`utils/supabase/server.ts`)** :
    ```typescript
    import { createServerClient } from '@supabase/ssr'
    import { cookies } from 'next/headers'

    export async function createClient() {
      const cookieStore = await cookies()

      return createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
          cookies: {
            getAll() {
              return cookieStore.getAll()
            },
            setAll(cookiesToSet) {
              try {
                cookiesToSet.forEach(({ name, value, options }) =>
                  cookieStore.set(name, value, options)
                )
              } catch {
                // Ignoré si appelé depuis un Server Component pur en lecture seule
              }
            },
          },
        }
      )
    }
    ```

---

### 3. Middleware de Session & Redirections Protégées (`middleware.ts`)

Le middleware est indispensable en App Router pour rafraîchir automatiquement les jetons de session d'authentification expirés et sécuriser les routes privées (ex: `/dashboard`, `/settings`).

- **Utilitaire Middleware (`utils/supabase/middleware.ts`)** :
  ```typescript
  import { createServerClient } from '@supabase/ssr'
  import { NextResponse, type NextRequest } from 'next/server'

  export async function updateSession(request: NextRequest) {
    let supabaseResponse = NextResponse.next({
      request,
    })

    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() {
            return request.cookies.getAll()
          },
          setAll(cookiesToSet) {
            cookiesToSet.forEach(({ name, value, options }) => request.cookies.set(name, value))
            supabaseResponse = NextResponse.next({
              request,
            })
            cookiesToSet.forEach(({ name, value, options }) =>
              supabaseResponse.cookies.set(name, value, options)
            )
          },
        },
      }
    )

    // Validation et rafraîchissement obligatoire du cookie de session d'authentification
    const {
      data: { user },
    } = await supabase.auth.getUser()

    // Protection des routes privées : conservation de l'URL cible d'origine via ?next=
    const isPublicRoute = 
      request.nextUrl.pathname.startsWith('/login') ||
      request.nextUrl.pathname.startsWith('/signup') ||
      request.nextUrl.pathname.startsWith('/auth') ||
      request.nextUrl.pathname === '/'

    if (!user && !isPublicRoute) {
      const url = request.nextUrl.clone()
      url.pathname = '/login'
      url.searchParams.set('next', request.nextUrl.pathname)
      return NextResponse.redirect(url)
    }

    return supabaseResponse
  }
  ```

- **Fichier Middleware Racine (`middleware.ts`)** :
  ```typescript
  import { type NextRequest } from 'next/server'
  import { updateSession } from '@/utils/supabase/middleware'

  export async function middleware(request: NextRequest) {
    return await updateSession(request)
  }

  export const config {
    matcher: [
      /*
       * Exclure les fichiers statiques et images optimisées :
       */
      '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
    ],
  }
  ```

---

### 4. Flux d'Authentification Complètement Sécurisé (Auth Flow Standard)

#### A. Route Callback PKCE (`app/auth/callback/route.ts`)
Indispensable pour échanger le code temporaire PKCE contre une session persistante lors des redirections OAuth (Google, GitHub) et Magic Links :

```typescript
import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    if (!error) {
      const forwardedHost = request.headers.get('x-forwarded-host')
      const isLocalEnv = process.env.NODE_ENV === 'development'
      if (isLocalEnv) {
        return NextResponse.redirect(`${origin}${next}`)
      } else if (forwardedHost) {
        return NextResponse.redirect(`https://${forwardedHost}${next}`)
      } else {
        return NextResponse.redirect(`${origin}${next}`)
      }
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth_callback_failed`)
}
```

#### B. Les 3 Modes d'Accès Unifiés :

1. **OAuth 1-clic (Google / GitHub)** :
   Redirection dynamique avec conservation de la destination via `redirectTo: ${origin}/auth/callback?next=${nextParam}` :
   ```typescript
   import { createClient } from '@/utils/supabase/client'

   export async function signInWithOAuth(provider: 'google' | 'github', nextParam: string = '/') {
     const supabase = createClient()
     const redirectTo = `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextParam)}`

     const { error } = await supabase.auth.signInWithOAuth({
       provider,
       options: {
         redirectTo,
         queryParams: { access_type: 'offline', prompt: 'consent' },
       },
     })
     if (error) throw error
   }
   ```

2. **Magic Links (Connexion sans mot de passe)** :
   Envoi d'un e-mail contenant un lien magique sécurisé (`supabase.auth.signInWithOtp`) :
   ```typescript
   import { createClient } from '@/utils/supabase/client'

   export async function signInWithMagicLink(email: string, nextParam: string = '/') {
     const supabase = createClient()
     const emailRedirectTo = `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextParam)}`

     const { error } = await supabase.auth.signInWithOtp({
       email,
       options: {
         emailRedirectTo,
         shouldCreateUser: true,
       },
     })
     if (error) throw error
   }
   ```

3. **Email / Mot de passe classique avec Validation Zod** :
   Validation stricte des champs du formulaire côté client/serveur avec Zod (`z.string().email()`, `z.string().min(8)`) :
   ```typescript
   // lib/validations/auth.ts
   import { z } from 'zod'

   export const authSchema = z.object({
     email: z.string().trim().email({ message: 'Adresse email invalide' }),
     password: z.string().min(8, { message: 'Le mot de passe doit comporter au moins 8 caractères' }),
   })

   export type AuthInput = z.infer<typeof authSchema>
   ```

   ```typescript
   // app/login/actions.ts
   'use server'

   import { revalidatePath } from 'next/cache'
   import { redirect } from 'next/navigation'
   import { createClient } from '@/utils/supabase/server'
   import { authSchema } from '@/lib/validations/auth'

   export async function login(formData: FormData) {
     const parsed = authSchema.safeParse({
       email: formData.get('email'),
       password: formData.get('password'),
     })

     if (!parsed.success) {
       return redirect('/login?error=' + encodeURIComponent(parsed.error.errors[0].message))
     }

     const supabase = await createClient()
     const { error } = await supabase.auth.signInWithPassword(parsed.data)

     if (error) {
       return redirect('/login?error=' + encodeURIComponent(error.message))
     }

     const next = (formData.get('next') as string) || '/'
     revalidatePath('/', 'layout')
     redirect(next)
   }

   export async function signOut() {
     const supabase = await createClient()
     await supabase.auth.signOut()
     revalidatePath('/', 'layout')
     redirect('/login')
   }
   ```

---

### 5. Schéma SQL & Sécurité PostgreSQL (RLS)
Activez systématiquement la **Row Level Security (RLS)** sur chaque table :
```sql
ALTER TABLE nom_de_la_table ENABLE ROW LEVEL SECURITY;
```
Configurez des politiques RLS garantissant l'accès strict par utilisateur :
```sql
CREATE POLICY "Acces individuel aux donnees"
ON nom_de_la_table
FOR ALL
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
```

---

### 6. Versionnage & Publication Cloud (GitHub)
Initialisez Git, effectuez le commit initial et publiez le projet via la CLI GitHub :
```bash
git init
git branch -M main
git add .
git commit -m "feat: initialisation Next.js avec Auth Flow PKCE, OAuth, Magic Links et Supabase SSR"
gh repo create nom-du-projet --public --source=. --remote=origin --push
```

---

## 🎯 RÈGLES D'ARCHITECTURE NEXT.JS
1. **Validation de Formulaire Stricte** : Toujours valider les entrées utilisateur avec **Zod** avant l'envoi à Supabase.
2. **Gestion du paramètre `next`** : Transmettre systématiquement le paramètre `next` dans les flux OAuth et Magic Links pour réorienter l'utilisateur sur la page exacte qu'il tentait de visiter.
3. **Server Actions & Server Components** : Privilégier les Server Actions pour les mutations et Server Components pour la lecture de données.