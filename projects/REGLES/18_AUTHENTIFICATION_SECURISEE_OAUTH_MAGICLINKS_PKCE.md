# 📜 RÈGLE 18 : STANDARD D'AUTHENTIFICATION SÉCURISÉE NEXT.JS & SUPABASE (FLUX PKCE, OAUTH, MAGIC LINKS & EMAIL/MDP)

> **Type** : Règle Métier & Standard d'Ingénierie Sécurité / Auth Universel  
> **Complément direct** : Règle 17 (Standard Universel Next.js App Router + Supabase SSR)  
> **Commanditaire & Vision** : Seb (Manager / Product Owner)  
> **Coordination & Rédaction** : CE (Chef d'Équipe / Lead Orchestrator & Architect)  
> **Application** : Obligatoire, permanente et universelle pour tous les agents (CE, AUD, DEV, UIX, OPS, DOC, @coach) sur l'ensemble des projets requérant de l'authentification  
> **Date de promulgation** : 22 Septembre 2026  

---

## 🎯 1. Contexte & Directive Fondatrice de Seb

La mise en place de l'authentification dans une application moderne **Next.js (App Router)** couplée à **Supabase** est une zone critique où la moindre faille peut exposer les comptes utilisateurs, rompre les sessions ou corrompre l'expérience utilisateur (redirections infinies, perte du contexte de navigation).

Afin d'assurer une expérience d'authentification fluide, universelle et infaillible, **Seb a promulgué la présente Règle 18** qui définit les standards obligatoires pour le flux PKCE (Proof Key for Code Exchange), les fournisseurs OAuth (Google, GitHub), les Magic Links sans mot de passe et l'authentification par email/mot de passe avec Server Actions.

---

## 🛡️ 2. Les 4 Piliers Inviolables de l'Authentification Sécurisée

### 🔄 Pilier 1 : Le Route Handler de Callback PKCE Obligatoire (`app/auth/callback/route.ts`)

En architecture App Router avec SSR, les connexions OAuth (Google, GitHub) et les Magic Links renvoient un paramètre d'échange temporaire `code` dans l'URL. Ce code **doit impérativement** être échangé côté serveur contre des cookies de session chiffrés.

Tout projet doit obligatoirement implémenter le fichier `app/auth/callback/route.ts` :

```typescript
import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  // Préservation de l'URL cible d'origine (fallback sur /dashboard si absent)
  const next = searchParams.get('next') ?? '/dashboard'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    
    if (!error) {
      const forwardedHost = request.headers.get('x-forwarded-host') // Présent sur les load balancers/Vercel
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

  // Redirection en cas d'erreur de validation du code
  return NextResponse.redirect(`${origin}/login?error=auth_callback_failed`)
}
```

---

### 🌐 Pilier 2 : Connexions OAuth (Google & GitHub) avec Redirection Ciblée

1. **Configuration du Redirection URI** :
   Dans la console Supabase (Auth > URL Configuration), ajouter systématiquement :
   - En local : `http://localhost:3000/auth/callback`
   - En production : `https://votre-domaine.com/auth/callback`

2. **Action de Connexion OAuth Côté Client (`utils/supabase/auth-actions.ts` ou composant)** :
   ```typescript
   import { createClient } from '@/utils/supabase/client'

   export async function signInWithProvider(provider: 'google' | 'github', nextUrl: string = '/dashboard') {
     const supabase = createClient()
     const redirectTo = `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextUrl)}`

     const { error } = await supabase.auth.signInWithOAuth({
       provider,
       options: {
         redirectTo,
         queryParams: {
           access_type: 'offline',
           prompt: 'consent',
         },
       },
     })

     if (error) {
       console.error('Erreur OAuth:', error.message)
       throw error
     }
   }
   ```

---

### ✉️ Pilier 3 : Connexion Sans Mot de Passe via Magic Links (Passwordless OTP)

1. **Génération du Lien Magique** :
   ```typescript
   import { createClient } from '@/utils/supabase/client'

   export async function signInWithMagicLink(email: string, nextUrl: string = '/dashboard') {
     const supabase = createClient()
     const emailRedirectTo = `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextUrl)}`

     const { error } = await supabase.auth.signInWithOtp({
       email,
       options: {
         emailRedirectTo,
         shouldCreateUser: true,
       },
     })

     if (error) {
       throw error
     }
   }
   ```
2. **Expérience Utilisateur & Feedback Visuel** :
   Afficher immédiatement un état de confirmation clair : *"Un lien sécurisé de connexion vous a été envoyé par email. Cliquez dessus pour accéder directement à votre espace."*

---

### 🔑 Pilier 4 : Email & Mot de Passe avec Server Actions Sécurisées

Les opérations d'authentification par email/mot de passe doivent être traitées prioritairement via des **Server Actions** Next.js pour garantir la conformité SSR et éviter l'exposition des logiques sensibles :

```typescript
// app/login/actions.ts
'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'

export async function login(formData: FormData) {
  const supabase = await createClient()

  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    return redirect('/login?error=' + encodeURIComponent(error.message))
  }

  revalidatePath('/', 'layout')
  redirect('/dashboard')
}

export async function signup(formData: FormData) {
  const supabase = await createClient()

  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const { error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL || ''}/auth/callback`,
    },
  })

  if (error) {
    return redirect('/signup?error=' + encodeURIComponent(error.message))
  }

  revalidatePath('/', 'layout')
  redirect('/login?message=verification_sent')
}

export async function signOut() {
  const supabase = await createClient()
  await supabase.auth.signOut()
  revalidatePath('/', 'layout')
  redirect('/login')
}
```

---

## 📋 3. Checklist d'Audit & Validation par l'Équipe QA (@AUD)

Avant toute mise en production d'un module d'authentification :

- [ ] Route Handler `app/auth/callback/route.ts` présent et gérant `exchangeCodeForSession(code)`.
- [ ] Paramètre `next` préservé et assaini (interdiction des redirections vers des domaines externes non autorisés - Open Redirect protection).
- [ ] URLs de callback configurées et déclarées dans la console Supabase (local + production).
- [ ] Server Actions `login`, `signup`, `signOut` utilisent `revalidatePath('/', 'layout')` pour purger le cache de navigation.
- [ ] Messages d'erreur explicites côté UI sans divulgation d'informations sensibles (protection contre l'énumération des comptes).
- [ ] Boutons OAuth affichant un état de chargement (`disabled` + spinner) dès le clic pour éviter les doubles soumissions.