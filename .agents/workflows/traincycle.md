---
description: Commande de workflow Antigravity /traincycle v4 avec budget calibré pour cycles complexes (35 000 tokens).
activation: Manual (via /traincycle)
---

# 🚀 Workflow Antigravity : /traincycle (v4 - Budget 35k Tokens)

Ce workflow définit la simulation d'entraînement en direct sous la direction du Lead Tech Trainer & Engineering Coach (`@coach`) pour l'équipe composée de **CE**, **AUD**, **DEV**, **UIX**, **OPS**, et **DOC**.

---

## 1. Initialisation & Allocation Budgétaire
- **Trigger** : L'utilisateur (Seb) lance la commande :
  ```bash
  /traincycle scenario="[scénario_technique]" budget_tokens=35000 max_rework=2
  ```
- **Actions du Coach (`@coach`)** :
  1. Enregistre le scénario de test cible et le quota de 35 000 tokens (prévention de la surconsommation multi-agents de 4 à 15×).
  2. Fixe le seuil d'alerte critique à 28 000 tokens (80% du budget).
  3. Ouvre et initialise le registre d'exécution : `Training_Session_Log.md`.

---

## 2. Phase 1 : Spécification & Approval Gate (@CE)
- **Étape 1.1 — Briefing de Cadrage** : `@coach` transmet la consigne à `@CE` (Lead Orchestrator & Architect).
- **Étape 1.2 — Rédaction de la Spécification Technique** : `@CE` produit le document `Technical_Specification.md` en isolant rigoureusement les tâches et contrats de données (schémas JSON/YAML).
- **Étape 1.3 — Audit de Cadrage & Filtrage d'Invocation (`@coach`)** :
  - Le `@coach` vérifie que `@CE` applique le principe de **Lazy Invocation** : interdiction d'invoquer des sous-agents non indispensables pour le scénario donné.
  - **Contrat d'Échange Strict (*Hand-off*)** : Validation du formatage de `Technical_Specification.md` (aucun brief informel ou verbal).
  - **Porte d'Approbation (*Approval Gate*)** : Suspension du workflow jusqu'à validation explicite : `[STATUS: APPROVED BY COACH]`.

---

## 3. Phase 2 : Exécution Isolée & Lazy Invocation (invoke_subagent)
- **Étape 2.1 — Délégation Ciblée (`invoke_subagent`)** :
  - `@CE` invoque uniquement les sous-agents strictement nécessaires (`@DEV`, `@UIX`, `@OPS`) en mode *clean slate* (transmission exclusive de `Technical_Specification.md`).
  - Utilisation des modèles économiques (`model: flash`) pour la génération de code.
- **Étape 2.2 — Implémentation Métier** :
  - `@DEV` implémente la logique métier (sobriété *Zero-Dependency*, `sanitizeHTML()`).
  - `@UIX` conçoit les interfaces réactives Mobile-First et accessibles (WCAG AA/AAA, ARIA).
  - `@OPS` configure la résilience *Offline-First* (Service Worker, IndexedDB, fallback `localStorage`).
- **Étape 2.3 — Contrôle des Flux par le `@coach`** :
  - Vérification de l'absence de transfert d'historiques bruts (*Zero Context Drift*).
  - Contrôle strict du respect du plafond de 15 tours par sous-agent.

---

## 4. Phase 3 : Banc d'Essai & Disjoncteur (@AUD)
- **Étape 3.1 — Transmission à l'Auditeur** : `@CE` soumet les artéfacts produits à `@AUD` (Lead QA & Security).
- **Étape 3.2 — Tests Automatisés & Bilan** : `@AUD` exécute l'audit OWASP Top 10 et les bancs d'essai automatisés sous Chromium Headless, puis publie `test_results.md`.
- **Étape 3.3 — Évaluation du Coach & Gestion des Boucles de Retravail (*Rework Loops*)** :
  - **Si `test_results.md == PASSED`** : Avancement immédiat vers la phase de documentation.
  - **Si `test_results.md == FAILED`** :
    - `@coach` intercepte les traces et génère une fiche pédagogique `Coaching_Feedback.md` (diagnostic de la cause racine).
    - Autorise jusqu'à 2 itérations de retravail (*rework loops*) maximum vers l'agent concerné.
    - **Disjoncteur Automatique (*Circuit Breaker*)** : Au-delà du 2ᵉ échec ou dès que le quota atteint 28 000 tokens, le disjoncteur gèle instantanément les exécutions et déclenche une alerte **Human-in-the-Loop (HITL)** demandant l'arbitrage direct de Seb pour éviter tout emballement budgétaire.

---

## 5. Phase 4 : Documentation & Rapport Final (@DOC & @coach)
- **Étape 5.1 — Documentation Produit (`@DOC`)** :
  - Rédige le manuel utilisateur et les guides techniques basés exclusivement sur les fonctionnalités testées et validées par `@AUD`.
- **Étape 5.2 — Rapport de Performance & Bilan Financier (`@coach`)** :
  - `@coach` publie `Training_Report.md` détaillant :
    - Rendement du Budget de Tokens (Consommation réelle vs quota de 35k tokens, efficacité par agent).
    - Audit des *Hand-offs* (conformité des schémas, zéro dérive de contexte).
    - Sévérité du Rework (nombre d'itérations consommées, statut du disjoncteur).
    - Plan d'optimisation et mise à jour automatique des fiches de compétences (`.agents/skills/`).