# 📜 RÈGLE 19 : BASCULE SYSTÉMIQUE & AUTOMATISATION GITHUB + SUPABASE POUR TOUS LES PROJETS ACTUELS ET FUTURS

> **Type** : Règle Fondamentale d'Infrastructure, de Continuité Opérationnelle & de Publication Cloud  
> **Complément direct** : Règles 16, 17 & 18 (Habilitation Générale, Supabase SSR & Auth PKCE)  
> **Commanditaire & Vision** : Seb (Manager / Product Owner)  
> **Coordination & Rédaction** : CE (Chef d'Équipe / Lead Orchestrator & Architect)  
> **Application** : Obligatoire, permanente, immédiate et universelle pour tous les agents (CE, AUD, DEV, UIX, OPS, DOC, @coach) sur l'ensemble des projets actuels et futurs  
> **Date de promulgation** : 22 Septembre 2026  

---

## 🎯 1. Contexte & Directive Fondatrice de Seb

Dans le cadre de l'industrialisation des développements et de la centralisation des actifs numériques sous l'égide d'**EFFICIENS ENERGIA**, la gestion isolée de projets locaux sans synchronisation distante ni backend unifié présente des risques de dispersion et de rupture de service.

Afin de sanctuariser le patrimoine applicatif, de permettre la collaboration continue, et de doter chaque produit d'un backend PostgreSQL/Auth robuste, **Seb a promulgué l'ordre officiel suivant** :

> **Consigne Directe de Seb :**  
> *« @CE basculer automatiquement tous les projets et les futurs projets sur GitHub et Supabase immédiatement. »*

Cette directive sanctuarise le principe de **l'Interconnexion Cloud Automatique par Défaut** : aucun projet ne doit demeurer à l'état de simple dossier local sans son dépôt GitHub synchronisé et son architecture Supabase SSR opérationnelle.

---

## 🛡️ 2. Les 5 Piliers Inviolables de la Règle 19

### 🌐 Pilier 1 : Zéro Projet Hors GitHub (Systemic GitHub Repository Linking)
1. **Initialisation Git Immédiate** : Tout projet existant ou nouvellement créé doit être instantanément initialisé sous Git (`git init`, `git branch -M main`).
2. **Dépôt Distant GitHub Officiel** : Un dépôt distant rattaché au compte de l'organisation **`EFFICIENS-ENERGIA`** doit être créé et connecté via la CLI GitHub (`gh repo create EFFICIENS-ENERGIA/<nom-du-projet> --public --source=. --remote=origin --push`).
3. **Synchronisation Continue** : Chaque jalon significatif validé par l'équipe fait l'objet d'un commit Git documenté et d'un push sur la branche principale `main`.

---

### ☁️ Pilier 2 : Socle Supabase Cloud SSR Standardisé
Chaque projet doit intégrer la pile standard Supabase SSR conforme aux Règles 17 et 18 :
1. **Fichiers d'environnement étanches** :
   - `.env.local` configuré avec l'instance Supabase de référence du projet :
     ```env
     NEXT_PUBLIC_SUPABASE_URL=https://kssoegpiqppqhfuaohzk.supabase.co
     NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_Q1gEVW3UP1ezr-eIvDE2Lg_j9gOEfUg
     NEXT_PUBLIC_SITE_URL=http://localhost:3000
     ```
   - `.env.example` anonymisé pour la reproductibilité.
2. **Architecture des Clients (`utils/supabase/`)** :
   - `client.ts` (`createBrowserClient`)
   - `server.ts` (`createServerClient` avec `cookies()`)
   - `middleware.ts` (`updateSession` avec rafraîchissement dynamique et gestion `?next=`)
3. **Flux PKCE & Callback Route** :
   - `app/auth/callback/route.ts` systématiquement déployé pour gérer l'échange de jetons OAuth (Google, GitHub) et Magic Links.
4. **Validation Zod & RLS PostgreSQL** :
   - Schémas de validation stricts (`zod`).
   - RLS activée sur 100% des tables PostgreSQL (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`).

---

### 🔒 Pilier 3 : Étanchéité Absolue des Secrets (.gitignore Inviolable)
Avant tout commit ou push vers GitHub, la présence d'un fichier `.gitignore` étanche est **strictement obligatoire**. Il doit bloquer sans exception :
```gitignore
.env*.local
.env
.next/
node_modules/
*.log
dist/
.DS_Store
```
Tout push contenant une clé privée ou un fichier `.env` réel entraîne le blocage immédiat du cycle par `@AUD`.

---

### ⚙️ Pilier 4 : Automatisation 1-Clic pour les Futurs Projets
L'équipe maintient à la racine de l'environnement un script universel d'orchestration :
`scripts/basculer_projet_github_supabase.ps1`
- Ce script applique automatiquement la chaîne complète (Git + GitHub CLI + injection des clients Supabase SSR + `.gitignore` + premier commit + push).
- Tout nouveau projet créé par l'équipe Antigravity doit obligatoirement être initialisé via ce script avant le démarrage de tout code métier.

---

### 🤝 Pilier 5 : Supervision par l'Équipe Multi-Agents
- **`@OPS`** : Responsable de la création du repo GitHub, de la configuration remote et de la conformité du Service Worker / PWA.
- **`@DEV`** : Responsable de l'injection des wrappers Supabase SSR (`utils/supabase/`) et des Server Actions.
- **`@AUD`** : Responsable du contrôle anti-fuite de secrets avant chaque push GitHub.
- **`@CE`** : Arbitre de nommage des dépôts et de la validation finale.

---

## 📋 3. Checklist de Bascule d'un Projet

Pour qualifier un projet comme "Basculé avec succès" :
- [ ] Dépôt Git local actif avec branche par défaut `main`.
- [ ] `.gitignore` étanche interdisant `.env*.local`.
- [ ] `.env.local` et `.env.example` en place avec clés Supabase.
- [ ] Répertoire `utils/supabase/` en place (`client.ts`, `server.ts`, `middleware.ts`).
- [ ] Fichier `middleware.ts` actif à la racine avec matcher d'exclusion statique.
- [ ] Route Handler `app/auth/callback/route.ts` présent.
- [ ] Dépôt distant GitHub actif sous `github.com/EFFICIENS-ENERGIA/<nom-projet>`.
- [ ] Commit initial ou de migration poussé sur `origin/main`.