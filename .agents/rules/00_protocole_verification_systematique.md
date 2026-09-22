# ⚡ PROTOCOLE 00 : VÉRIFICATION SYSTÉMATIQUE & AUTONOME POUR TOUS PROJETS

> **Directive Suprême de Seb (Manager / Product Owner)**  
> **Exécution** : Obligatoire, automatique et systématique par toute l'équipe (**CE**, **AUD**, **DEV**, **UIX**, **OPS**, **DOC**, **@coach**).  
> **Condition de déclenchement** : **SANS ATTENDRE DE DEMANDE DE SEB**, pour tout projet actuel et futur, avant chaque livraison, restitution ou clôture de tâche.  
> **Architecture** : Audit Matriciel Universel à 2 Strates (Socle Universel + Pack Métier Dédié).  
> **Dernière mise à niveau** : 22 Septembre 2026  

---

## 🎯 1. Principe Fondamental & Mandat

À la suite de la consigne formelle et permanente de **Seb** :  
> *« CE vérifier avec toute l'équipe que l'outil respecte toutes les règles et réaliser dorénavant cette action systématiquement sans que je demande pour tout projet »*

Il est strictement interdit à tout agent (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`, `@coach`) de considérer une tâche comme achevée ou de soumettre un livrable à Seb sans avoir **autonomement et systématiquement** exécuté l'audit matriciel complet.

---

## 🏛️ 2. Architecture de l'Audit Matriciel à 2 Strates

Pour s'adapter à la diversité des projets (SaaS, Next.js, applications mobiles, vitrines, comparateurs), l'audit est structuré en deux strates complémentaires :

### STRATE A : LE SOCLE UNIVERSEL (100% DES PROJETS ACTUELS & FUTURS)
Tout projet, sans exception, est validé sur ces 14 piliers fondamentaux :

| # | Règle Universelle | Point de Contrôle Impératif | Rôle Leader |
|:---:|---|---|:---:|
| **00** | **Protocole d'Audit Autonome** | Exécution autonome avant restitution, zéro complaisance, rapport 100% certifié. | **@CE** |
| **04/11** | **Source Unique & DRY** | Parité binaire pour les fichiers miroirs ou factorisation DRY par composants partagés. | **@DEV / @OPS** |
| **07** | **Sécurité, Vie Privée & Secrets** | Zéro clé privée/secret dans Git (`pre-push-check`), 100% liens sortants `noopener noreferrer`, anti-XSS. | **@AUD** |
| **08** | **Sanctuarisation & Non-Régression** | Tout correctif antérieur sanctuarisé sous forme de test d'assertion automatisé. | **@AUD / @DEV** |
| **09** | **Intégrité Absolue des Contraintes** | Zéro élargissement silencieux des critères pour meubler l'interface. | **@DEV** |
| **10** | **Validation Matricielle Cas Limites** | Tests sur cas limites, valeurs extrêmes, formats atypiques, stress testing. | **@AUD** |
| **12** | **Véracité des Intégrations** | Zéro lien conjecturé ou brisé, URLs réelles déterministes sans texte parasite. | **@DEV / @UIX** |
| **14** | **Fiabilité & Ground Truth** | Interdiction absolue d'entités fictives ou générées par template. Ancrage au réel. | **@AUD** |
| **15** | **Généralisation Systémique** | Tout correctif unitaire doit être propagé à tous les modules homologues. | **@CE / @DEV** |
| **16** | **Habilitation & Autonomie** | Exécution proactive et fluide de toutes les commandes requises dans le respect des règles. | **@CE** |
| **17** | **Standard Next.js & Supabase SSR** | Architecture App Router, `@supabase/ssr`, Middleware de session, validation Zod. | **@DEV / @OPS** |
| **18** | **Authentification PKCE & OAuth** | Route `app/auth/callback`, échange de code sécurisé, gestion `x-forwarded-host`. | **@DEV / @AUD** |
| **19** | **Bascule Automatique GitHub** | Repo GitHub sous organisation `EFFICIENS-ENERGIA`, `.gitignore` étanche, CI/CD. | **@OPS** |
| **20** | **Standard UI/UX Fail-Honest & ARIA** | États vides explicites avec méta-recherche externe, modales accessibles WCAG AA. | **@UIX** |

---

### STRATE B : LES PACKS MÉTIERS SPÉCIFIQUES (ACTIVÉS SELON LE PROJET)

#### 📦 B.1 — Pack Voyage & Comparateurs (SmartTrip Pro)
Activé pour tout projet de recherche ou comparateur de biens/services :
- **Règle 01 — Diversité Tarifaire Organique** : Modèle `PLAT_PROFILES`, zéro prix identique, scoring avantageant les entités réelles (+20 000 pts).
- **Règle 02 — Respect Inviolable Budget & Rayon** : 0 offre hors budget (`min <= p <= max`) et 0 offre hors rayon (`dist <= maxDist`).
- **Règle 03 — Intégrité Multi-Devises** : `USER_CURRENCY` jamais écrasée. Double affichage informatif systématique.
- **Règle 05 — Fiches & Deep-Links OTA** : Modale native in-app `#hotelDetailModal` active, liens propres vers les 10 OTA avec `adults=X`.
- **Règle 06 — Banc d'Essai Réel Edge Headless** : Matrice des 50 scénarios (10 destinations × 5 jauges) validée à 50/50 PASS.
- **Règle 13 — Garde-Fou Budget Déterministe** : Statut explicite `NO_MATCH_UNDER_BUDGET` sans hallucination.

#### 📦 B.2 — Pack SaaS & CRM (Efficiens Energia Hub RDV)
Activé pour les logiciels métiers, portails clients et CRM :
- **Sécurité des Données & RLS** : Isolation PostgreSQL stricte (`auth.uid() = user_id`) sur toutes les tables.
- **Résilience Offline-First** : File d'attente d'écritures locales (`IndexedDB`) et synchronisation différée dès retour du réseau.
- **Sauvegarde Préventive** : Export de sécurité obligatoire dans `backups/` avant toute migration SQL.

---

## ⚙️ 3. Automatisation Technique de l'Audit

Chaque projet dispose d'une commande de validation rapide intégrée :
```powershell
# 1. Vérification préventive de sécurité et anti-fuite de secrets
powershell -ExecutionPolicy Bypass -File "c:\Users\EFFICIENS ENERGIA\Desktop\ANTIGRAVITY\scripts\pre-push-check.ps1"

# 2. Exécution du banc d'essai complet
powershell -ExecutionPolicy Bypass -File "c:\Users\EFFICIENS ENERGIA\Desktop\ANTIGRAVITY\scripts\audit_ameliorations_regles.ps1"
```

---

## 📢 4. Formalisme de Restitution à Seb

Toute restitution finale de **CE** à **Seb** doit obligatoirement présenter :
1. **L'état d'avancement** de la demande métier de Seb.
2. **Le Certificat d'Audit Matriciel** attestant du statut **PASS** sur le Socle Universel et le Pack Métier actif.
3. **L'assurance formelle** de non-régression et de synchronisation des règles.
