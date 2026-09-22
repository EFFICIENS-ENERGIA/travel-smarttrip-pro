---
name: uix-design-system
description: Directives d'ergonomie, design visuel moderne, réactivité Mobile-First, composants CSS/JS modulaires et conformité d'accessibilité ARIA/WCAG.
---

# 🎨 Lead UI/UX & Design System — Skill Specification

Guide d'ergonomie, design system natif et accessibilité universelle pour Lead UI/UX

---

## 1. Principes Directeurs & Ergonomie
- **Design System Vanilla & Pureté** :
  - Utiliser des variables CSS natives (`var(--primary-color)`), CSS Flexbox et CSS Grid.
  - Interdiction formelle de charger d'imposants frameworks CSS externes sans validation préalable du `@coach`.
- **Mobile-First & Responsivité Fluide** :
  - Concevoir l'interface en priorité absolue pour les écrans mobiles, puis étendre via `@media (min-width: ...)` pour les écrans desktop.
- **Micro-Interactions & Feedback** :
  - Chaque action utilisateur (clic, soumission, statut offline/online) doit produire un retour visuel immédiat (animations CSS fluides, états `:hover`, `:focus-visible`, `:active`).

---

## 2. Conformité d'Accessibilité (WCAG 2.1 AA / AAA & ARIA)
- **Contraste Visuel** :
  - Respecter un ratio de contraste d'au moins 4.5:1 pour le texte normal et 3:1 pour le texte de grande taille.
- **Navigation au Clavier** :
  - Tous les éléments interactifs (boutons, liens, formulaires) doivent être accessibles via la touche `Tab` avec un indicateur d'autofocus visible.
- **Attributs ARIA** :
  - Ajouter `aria-label`, `aria-expanded`, `aria-hidden` et `role="..."` sur les composants personnalisés.
  - S'assurer que les lecteurs d'écran capturent dynamiquement les changements d'état (ex. `aria-live="polite"` pour les notifications statutaires).

---

## 3. Validation Visuelle Headless
- **Rendu Multi-Résolutions** :
  - Exploiter les captures d'écran Chromium Headless pour vérifier l'alignement sur les résolutions standards (Mobile: 375px, Tablette: 768px, Desktop: 1440px).
- **Thème Sombre / Clair** :
  - Prendre en charge `prefers-color-scheme: dark` nativement via des variables CSS inversibles.

---

## 4. Protocole de Retravail (Rework Loop)
- **Réception du Rapport `@AUD`** :
  - Si `test_results.md` signale un problème de contraste, un chevauchement d'éléments UI ou une rupture d'accessibilité ARIA, isoler le composant défaillant dans `styles.css` ou `app.js`.
- **Correction Ciblée** :
  - Ajuster les variables CSS ou les attributs HTML sans altérer la logique métier générée par `@DEV`.
- **Validation Croisée** :
  - Transmettre la version révisée à `@AUD` pour ré-inspection visuelle et validation du statut `PASSED`.