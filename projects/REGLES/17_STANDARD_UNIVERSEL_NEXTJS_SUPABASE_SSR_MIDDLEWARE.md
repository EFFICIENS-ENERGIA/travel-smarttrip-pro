# 📜 RÈGLE 17 : STANDARD UNIVERSEL NEXT.JS (APP ROUTER) & SUPABASE SSR + MIDDLEWARE D'AUTHENTIFICATION + GITHUB

> **Type** : Règle Métier & Standard d'Ingénierie Full-Stack Universel  
> **Commanditaire & Vision** : Seb (Manager / Product Owner)  
> **Coordination & Rédaction** : CE (Chef d'Équipe / Lead Orchestrator & Architect)  
> **Application** : Obligatoire, permanente et universelle pour tous les agents (CE, AUD, DEV, UIX, OPS, DOC, @coach) sur l'ensemble des projets actuels et futurs utilisant Next.js et/ou Supabase  
> **Date de promulgation** : 22 Septembre 2026  

---

## 🎯 1. Contexte & Directive Suprême de Seb

L'évolution des architectures Web modernes impose une rigueur absolue dans l'interconnexion entre le framework frontend (**Next.js App Router**), le backend de données et d'authentification (**Supabase Cloud via `@supabase/ssr`**), le rafraîchissement dynamique des sessions utilisateur (**Middleware Edge**) et la chaîne de déploiement continu (**GitHub**).

Afin d'éradiquer définitivement les dysfonctionnements d'authentification (sessions expirées non rafraîchies, routes privées exposées, fuites de clés sensibles, cookies non synchronisés côté serveur), **Seb a promulgué la présente Règle 17 comme standard universel obligatoire pour tous les projets**.

---

## 🛠️ 2. Directives d'Initialisation et de Configuration

### 1. Variables d'Environnement & Sécurité Next.js (`.env.local`)
- **Fichier `.env.local`** :
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
- **Sécurisation Git (`.gitignore`)** : Incluez impérativement :
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

Le middleware est indispensable en App Router pour rafraîchir automatiquement les jetons de session d'authentification expirés et sécuriser les routes privées.

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

    // Protection des routes privées (ex: /dashboard, /settings) : conservation de l'URL cible d'origine via ?next=
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

  export const config = {
    matcher: [
      /*
       * Exclure les fichiers statiques et images optimisées :
       */
      '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
    ],
  }
  ```

---

### 4. Schéma SQL & Sécurité PostgreSQL (RLS)
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

### 5. Versionnage & Publication Cloud (GitHub)
Initialisez Git, effectuez le commit initial et publiez le projet via la CLI GitHub :
```bash
git init
git branch -M main
git add .
git commit -m "feat: initialisation Next.js avec Auth Flow PKCE, OAuth, Magic Links et Supabase SSR"
gh repo create nom-du-projet --public --source=. --remote=origin --push
```

---

## 🎯 3. Règles d'Architecture Next.js Intangibles
1. **Validation de Formulaire Stricte** : Toujours valider les entrées utilisateur avec **Zod** avant l'envoi à Supabase.
2. **Gestion du paramètre `next`** : Transmettre systématiquement le paramètre `next` dans les flux OAuth et Magic Links pour réorienter l'utilisateur sur la page exacte qu'il tentait de visiter.
3. **Server Actions & Server Components** : Privilégier les Server Actions pour les mutations et Server Components pour la lecture de données.