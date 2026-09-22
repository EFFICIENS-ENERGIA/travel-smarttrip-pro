---
name: aud-qa-security
description: Procédures d'audit de code, bancs d'essai automatisés Headless, détection OWASP et émission de test_results.md pour l'Auditeur Senior (@AUD).
---

# 🛡️ Skill : aud-qa-security (@AUD)

Guide d'audit sans concession, bancs de tests automatisés et résilience pour Auditeur Senior QA & Security

---

## 1. Protocole d'Audit Statique & Analyse Sécurité
- **Revue de Sécurité OWASP Top 10** :
  - **XSS (*Cross-Site Scripting*)** : Rechercher toutes les occurrences d'injection directe dans le DOM (`innerHTML`, `insertAdjacentHTML`). Vérifier l'existence et l'utilisation explicite de `sanitizeHTML()`.
  - **Fuites de Données & Stockage** : Vérifier qu'aucune donnée sensible non chiffrée n'est inscrite dans `localStorage` ou dans les logs de la console (`console.log`).
  - **Politique de Sécurité du Contenu (CSP)** : S'assurer de l'absence de scripts inline exécutables non autorisés.
- **Revue d'Architecture & Sobriété** :
  - Vérifier l'absence d'importations de dépendances externes non autorisées.
  - Contrôler le respect strict du découpage modulaire défini dans `Technical_Specification.md`.

---

## 2. Bancs d'Essai Automatisés & Tests Headless
- **Exécution des Tests Intégrés** :
  - Lancer la suite de tests unitaires et d'intégration via le terminal d'Antigravity (`npm test`, `pytest`, ou scripts Playwright / Chromium Headless).
- **Validation des Scénarios Limites (*Edge Cases*)** :
  - **Mode Hors-Ligne (*Offline*)** : Simuler une coupure réseau et vérifier que l'application reste fonctionnelle grâce au Service Worker et à IndexedDB.
  - **Formulaires & Injections** : Injecter des charges utiles de test (`<script>alert(1)</script>`, chaînes vides, caractères Unicode spéciaux) dans tous les champs de saisie.

---

## 3. Émission du Rapport test_results.md
À la fin de chaque banc d'essai, générer obligatoirement le fichier `test_results.md` selon le format strict ci-dessous :

```markdown
# 📋 Rapport d'Audit Qualité & Sécurité
**Statut Global** : [PASSED / FAILED]
**Date & Heure** : [YYYY-MM-DD HH:MM]
**Sévérité Maximale** : [NONE / CRITICAL / HIGH / MEDIUM / LOW]

---

## 1. Matrice de Conformité
| Module | Tests Fonctionnels | Audit Sécurité | Statut |
|---|---|---|---|
| Engine (`db.js`) | PASSED | PASSED | OK |
| Interface (`app.js`) | FAILED | CRITICAL (XSS) | TO_REFIX |
| PWA (`sw.js`) | PASSED | PASSED | OK |

---

## 2. Anomalies Détectées (Requis si FAILED)
### [BUG-01] Injection XSS potentielle dans le champ de saisie
- **Fichier** : `app.js` (Ligne 42)
- **Description** : L'élément `taskTitle` est directement injecté via `innerHTML` sans assainissement.
- **Trace d'erreur** : `Uncaught SecurityError: Failed to execute 'innerHTML' on 'Element'...`
- **Action requise pour @DEV** : Remplacer `innerHTML` par `textContent` ou appliquer `sanitizeHTML()`.

---

## 3. Décision d'Orchestration
- **PASSED** -> Autorisation de passer à la phase de documentation (@DOC).
- **FAILED** -> Retour de tâche à @DEV (Boucle de retravail N°X/3).
```