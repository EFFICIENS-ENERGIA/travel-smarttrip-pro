# 🎯 Coaching Feedback — Cycle 1 / Rework Loop 1

**Destinataires** : `@DEV` (Core Engine) & `@OPS` (DevOps/PWA)  
**Émetteur** : `@coach` (Lead Tech Trainer & Engineering Coach)  
**Référence Audit** : `test_results.md` (Statut : FAILED)  
**Principe Rappelé** : *"Ne pas fournir le code clé en main, mais guider le diagnostic vers la cause racine pour ancrer l'apprentissage."*

---

## 🔍 1. Diagnostic de Cause Racine : Vulnérabilité XSS dans `app.js`

### Constat d'Échec (@AUD)
Lors de l'injection d'un titre de tâche contenant une balise script (`<img src=x onerror=alert(1)>`), le payload a été exécuté dans le contexte du DOM.

### Analyse Pédagogique du Coach
- **Cause Racine** : L'utilisation de l'assignation directe `innerHTML` avec des chaînes provenant des saisies utilisateur sans étape d'assainissement préalable.
- **Rappel Architectural** : Dans un environnement Vanilla JS sans framework avec compilation sécurisée (React/Angular), tout flux d'entrée utilisateur doit obligatoirement être neutralisé.
- **Orientation Pédagogique pour `@DEV`** :
  1. Crée un utilitaire d'échappement sémantique basé sur le DOM natif (`textContent` dans un élément détaché) avant toute concaténation.
  2. Alternativement, utilise la création d'éléments nodaux purs (`document.createElement`) pour les nœuds sensibles.
  3. Mets à jour ta fiche de compétences `.agents/skills/dev-core-engine/SKILL.md` pour systématiser ce réflexe.

---

## 🔍 2. Diagnostic de Cause Racine : Rupture de Mise à Jour Service Worker dans `sw.js`

### Constat d'Échec (@AUD)
Lors de modifications apportées aux actifs de l'application, l'ancien cache restait servi indéfiniment aux utilisateurs, empêchant le déploiement des correctifs.

### Analyse Pédagogique du Coach
- **Cause Racine** : Absence de mécanisme d'invalidation dans l'événement `activate` du Service Worker et nom de cache immuable.
- **Rappel Architectural** : Le cycle de vie d'un Service Worker requiert la gestion explicite de la purge des caches obsolètes via `caches.keys()` et `caches.delete()`.
- **Orientation Pédagogique pour `@OPS`** :
  1. Incrémente le nom de ton cache (`pwa-taskmanager-v2`).
  2. Implémente l'écouteur `activate` avec une boucle de purge conditionnelle garantissant que seul le cache actif est conservé.
  3. Appelle `clients.claim()` pour prendre immédiatement le contrôle des pages ouvertes.

---

## ⏱️ Consignes pour la Boucle de Retravail (Rework Loop 1/2)
- Budget restant avant alerte critique : **9 300 tokens**.
- Appliquez uniquement les correctifs ciblés sans réécrire l'ensemble des modules.
- Soumettez immédiatement vos artefacts à `@AUD` dès finalisation.