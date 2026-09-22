---
name: dev-core-engine
description: Directives d'implémentation logicielle, codage modulaire, assainissement XSS et persistance données pour le Développeur Senior (@DEV).
---

# 💻 Skill : dev-core-engine (@DEV)

Guide d'implémentation et de sobriété logicielle pour Développeur Senior Fullstack

---

## 1. Principes d'Architecture & Sobriété
- **Zero-Dependency Bloat** :
  - Privilégier systématiquement les APIs natives du navigateur (Vanilla JS ES6+, CSS Grid/Flexbox, `fetch`, Web Workers, IndexedDB).
  - Aucune dépendance externe (NPM) sans autorisation préalable et audit explicite par `@AUD`.
- **Modularité & Séparation des Responsabilités** :
  - Isoler la logique métier (`core/`), l'accès aux données (`storage/`), et le rendu UI (`components/`).
  - Ne jamais mélanger requêtes IndexedDB et manipulation directe du DOM dans le même fichier.

---

## 2. Sécurité & Assainissement du DOM (Anti-XSS)
- **Interdiction d'injection brute** :
  - Interdiction absolue d'utiliser `innerHTML`, `outerHTML`, ou `document.write()` avec des données issues d'entrées utilisateur sans désinfection préalable.
- **Désinfection obligatoire** :
  - Utiliser systématiquement la fonction utilitaire `sanitizeHTML()` ou `textContent` / `createElement()` :
  ```javascript
  function sanitizeHTML(str) {
    const temp = document.createElement('div');
    temp.textContent = str;
    return temp.innerHTML;
  }
  ```
- **Gestion des Secrets** :
  - Ne jamais stocker de clés API, jetons d'accès privés ou secrets en clair dans le code source ou dans `localStorage`.

---

## 3. Persistance & Traitement Asynchrone (IndexedDB)
- **Transactions Robustes** :
  - Encapsuler toute opération IndexedDB dans des Promesses avec gestion systématique des événements `onerror` et `onabort`.
- **Structure des Magasins d'Objets (*Object Stores*)** :
  - Définir des schémas d'indexation clairs et des clés primaires auto-incrémentées ou UUIDs v4.
- **Stratégie Fallback** :
  - En cas d'incompatibilité ou d'erreur IndexedDB, basculer de manière transparente sur un adaptateur `localStorage` avec sérialisation JSON sécurisée.

---

## 4. Protocole d'Exécution & Boucles de Correction
- **Lecture du Brief** :
  - Lire exclusivement `Technical_Specification.md` fourni par `@CE`. Ne pas improviser de fonctionnalités non spécifiées.
- **Traitement du Rework (`test_results.md`)** :
  - En cas de rejet par `@AUD` (`test_results.md == FAILED`), isoler la trace d'erreur identifiée et appliquer le correctif minimal sans réécrire l'ensemble de l'application.
- **Interdiction d'Auto-Approbation** :
  - Signaler la fin du travail à `@CE` et soumettre immédiatement le code produit à la validation de `@AUD`.