# 📜 RÈGLE 21 : DIRECTIVES D'INITIALISATION & CONFIGURATION AUTOMATIQUE COMPLÈTE

> **Type** : Standard Universel d'Ingénierie & Guide de Configuration Opérationnel  
> **Commanditaire & Vision** : Seb (Manager / Product Owner)  
> **Coordination** : @CE (Lead Orchestrator) & l'Équipe Multi-Agents Antigravity  
> **Application** : Obligatoire pour tout nouveau projet et toute application Web/Cloud  
> **Date de promulgation** : 22 Septembre 2026  

---

## 🎯 1. Préambule & Directive Fondamentale

Pour garantir une vitesse d'exécution maximale, une sécurité sans faille et une étanchéité complète entre le frontend, le cloud et la persistance, **Seb a promulgué les 10 Directives Universelles d'Initialisation et de Configuration Automatique**.  
Ces 10 directives sont exécutées de manière déterministe par l'équipe multi-agents dès le démarrage de tout nouveau projet ou à la première instruction.

---

## 📋 2. Les 10 Directives d'Initialisation & Configuration

### 1. Installation Automatique de `.cursorrules` (ou `.windsurfrules`)
- Dès le démarrage de tout nouveau projet ou à la première instruction :
  - Création immédiate du fichier `.cursorrules` à la racine du projet.
  - Ce fichier contient l'ensemble des règles de codage du projet (Next.js App Router, `@supabase/ssr`, Server Components, Server Actions, Supabase Storage, validation Zod, Mode Sombre Tailwind CSS, modèles d'e-mails, politiques RLS, règles Git) afin que l'agent et l'IDE appliquent ces règles de manière transparente et permanente.

---

### 2. Guide et Configuration de Google Cloud Console (OAuth 2.0)
L'agent doit guider l'utilisateur ou générer la checklist exacte pour la configuration de l'authentification Google :
1. **Création du projet Google Cloud** : Rendez-vous sur la [Google Cloud Console](https://console.cloud.google.com/) et créez un nouveau projet (ex: `mon-projet-saas`).
2. **Écran de Consentement OAuth (OAuth Consent Screen)** :
   - Type d'utilisateur : **Externe**.
   - Nom de l'application, adresse e-mail d'assistance et coordonnées développeur.
   - Domaines autorisés : Ajoutez `votre-domaine.com` et `supabase.co`.
   - Scopes obligatoires : `.../auth/userinfo.email`, `.../auth/userinfo.profile`, `openid`.
3. **Identifiants OAuth 2.0 (OAuth Client ID)** :
   - Type d'application : **Application Web**.
   - Origines JavaScript autorisées :
     - `http://localhost:3000`
     - `https://votre-domaine.com`
   - URI de redirection autorisés :
     - `https://<ref-projet>.supabase.co/auth/v1/callback`
4. **Liaison Supabase** :
   - Copiez le **Client ID** et le **Client Secret** générés par Google Cloud.
   - Rendez-vous sur Supabase Dashboard -> **Authentication** -> **Providers** -> **Google**.
   - Activez le provider, collez le Client ID et Client Secret, puis enregistrez.

---

### 3. Configuration des Modèles d'E-mails (Supabase Auth Email Templates)
Configuration exacte dans le tableau de bord Supabase (**Authentication -> Email Templates**) :

#### A. Réinitialisation de Mot de Passe (Reset Password / Recovery)
- **Sujet** : `Réinitialisation de votre mot de passe`
- **Corps du message (HTML)** :
  ```html
  <h2>Réinitialisation de votre mot de passe</h2>
  <p>Vous avez demandé à réinitialiser votre mot de passe. Cliquez sur le lien ci-dessous pour procéder :</p>
  <p><a href="{{ .ConfirmationURL }}">Réinitialiser mon mot de passe</a></p>
  <p>Si vous n'êtes pas à l'origine de cette demande, vous pouvez ignorer cet e-mail.</p>
  ```
- **URL de Redirection** : pointe vers `https://<votre-domaine>/auth/callback?next=/reset-password` (ou `http://localhost:3000/auth/callback?next=/reset-password` en local).

#### B. Connexion par Lien Magique (Magic Link)
- **Sujet** : `Votre lien de connexion sécurisé`
- **Corps du message (HTML)** :
  ```html
  <h2>Connexion rapide</h2>
  <p>Cliquez sur le bouton ci-dessous pour vous connecter instantanément à votre compte :</p>
  <p><a href="{{ .ConfirmationURL }}">Se connecter à l'application</a></p>
  ```

#### C. Confirmation d'Inscription (Confirm Signup)
- **Sujet** : `Confirmez votre adresse email`
- **Corps du message (HTML)** :
  ```html
  <h2>Bienvenue !</h2>
  <p>Merci de confirmer votre adresse e-mail en cliquant sur le lien suivant :</p>
  <p><a href="{{ .ConfirmationURL }}">Confirmer mon adresse email</a></p>
  ```

---

### 4. Variables d'Environnement & Sécurité Git (`.env.local` & `.gitignore`)
- `.env.local` :
  ```env
  NEXT_PUBLIC_SUPABASE_URL=https://<votre-projet>.supabase.co
  NEXT_PUBLIC_SUPABASE_ANON_KEY=votre_cle_anon_publique
  NEXT_PUBLIC_SITE_URL=http://localhost:3000
  ```
- `.env.example` : Modèle strictement anonymisé avec des placeholders explicites.
- `.gitignore` : Exclut obligatoirement `.env*.local`, `.env`, `.next/`, `node_modules/`, `*.log`.
- Contrôle pré-push : `pre-push-check.ps1` obligatoire.

---

### 5. Architecture Supabase SSR Native (`@supabase/ssr` + `zod`)
- Dépendances : `@supabase/supabase-js`, `@supabase/ssr`, `zod`.
- Clients dans `utils/supabase/` :
  - `client.ts` (`createBrowserClient`)
  - `server.ts` (`createServerClient` avec `await cookies()`)

---

### 6. Middleware de Session & Route Callback PKCE
- `app/auth/callback/route.ts` : Échange du code temporaire PKCE contre une session persistante avec gestion dynamique de la cible de redirection `next`.
- `middleware.ts` + `utils/supabase/middleware.ts` : Rafraîchissement automatique des cookies de session et protection des routes privées.

---

### 7. Script SQL Unifié Final (`sql/init_supabase_unified.sql`)
Exécution du script d'initialisation comprenant :
- La table `public.profiles` (`id uuid references auth.users on delete cascade`, `full_name`, `avatar_url`, `updated_at`).
- La sécurité RLS activée sur `public.profiles`.
- Le déclencheur (trigger) automatique `on_auth_user_created` créant le profil dès l'inscription.
- Le bucket `avatars` dans Supabase Storage (public avec politique RLS d'upload sécurisé pour le propriétaire).

---

### 8. Flux d'Authentification Complet & Formulaires UI (Mode Sombre Natif)
- `<LoginForm />` : Connexion OAuth (Google, GitHub), Magic Links, et Email/Mot de passe avec lien mot de passe oublié.
- `<ForgotPasswordForm />` : Demande d'envoi du lien de réinitialisation par e-mail.
- `<ResetPasswordForm />` : Mise à jour sécurisée du mot de passe avec validation Zod.
- Support du Mode Sombre Tailwind CSS (`dark:`) et conformité ARIA sur tous les formulaires.

---

### 9. Page Profil & Server Actions avec Supabase Storage (`app/profile/`)
- Page `app/profile/page.tsx` protégée par le middleware.
- Composant `<ProfileForm />` pour téléverser et prévisualiser l'avatar, mettre à jour le nom complet et afficher les informations de compte.
- Server Action `updateProfileAction` gérant l'upload vers Supabase Storage, les requêtes SQL et la révalidation de cache Next.js (`revalidatePath`).

---

### 10. Publication Automatique GitHub
- Initialisation Git automatique sur la branche `main`.
- Commits atomiques conventionnels (`feat: initialisation...`).
- Création du dépôt public/privé sous l'organisation GitHub **`EFFICIENS-ENERGIA`** via `gh repo create ... --push`.
