# 📐 Technical Specification — PWA Task Manager Offline-First

**Projet** : Application PWA Task Manager Offline-First avec IndexedDB  
**Statut** : `[STATUS: APPROVED BY COACH]`  
**Date d'Approbation** : 2026-09-11  
**Architecte** : `@CE` (Lead Orchestrator & Architect)  
**Superviseur** : `@coach` (Lead Tech Trainer & Engineering Coach)  

---

## 1. Objectifs & Cadre Architectural

L'application est une Progressive Web App (PWA) de gestion de tâches hautement résiliente, conçue selon le paradigme **Offline-First / Local-First**. Elle fonctionne de manière totalement autonome sans dépendance serveur ou réseau, tout en offrant une expérience utilisateur fluide et accessible.

### Principes Clés
1. **Zero-Dependency Bloat** : Vanilla JavaScript (ES6+), CSS natif (Variables, Flexbox, Grid), sans aucun framework ni bundler tiers.
2. **Offline-First & Local Persistence** : IndexedDB natif pour le stockage de données structurées avec fallback transparent en `localStorage`.
3. **PWA Installable** : Service Worker conforme Cache-First avec gestion de cycle de vie et manifeste W3C valide.
4. **Sécurité Anti-XSS by Design** : Désinfection systématique des entrées via `sanitizeHTML()` et interdiction d'injection non assainie dans le DOM.
5. **Ergonomie & Accessibilité** : Design Mobile-First, thème sombre/clair dynamique et conformité WCAG 2.1 AA / AAA.

---

## 2. Contrat de Données & Schéma IndexedDB

### Base de données : `TaskManagerDB` (Version 1)
- **Object Store** : `tasks`
- **Clé primaire (`keyPath`)** : `id` (string UUID ou timestamp préfixé, ex: `task-1726045200000`)
- **Index configurés** :
  - `status` (`'pending'` | `'completed'`)
  - `priority` (`'low'` | `'medium'` | `'high'`)
  - `createdAt` (ISO 8601 string)
  - `dueDate` (YYYY-MM-DD string)

### Schéma TypeScript / JSON Schema du modèle Tâche :
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Task",
  "type": "object",
  "properties": {
    "id": { "type": "string" },
    "title": { "type": "string", "minLength": 1, "maxLength": 120 },
    "description": { "type": "string", "maxLength": 500 },
    "priority": { "type": "string", "enum": ["low", "medium", "high"] },
    "status": { "type": "string", "enum": ["pending", "completed"] },
    "createdAt": { "type": "string", "format": "date-time" },
    "dueDate": { "type": "string" }
  },
  "required": ["id", "title", "priority", "status", "createdAt"]
}
```

---

## 3. Découpage Modulaire & Responsabilités

| Rôle | Fichier Cible | Responsabilités Précises |
|:---:|---|---|
| **`@DEV`** | `app_build/db.js` | Wrapper IndexedDB natif avec Promesses, gestion des transactions `readwrite`, fallbacks localStorage sécurisés. |
| **`@DEV`** | `app_build/app.js` | Logique métier (CRUD des tâches, filtrage, validation, assainissement strict via `sanitizeHTML()`). |
| **`@UIX`** | `app_build/styles.css` | Design System Vanilla CSS (Variables, Dark/Light, Grids, WCAG 4.5:1, micro-animations). |
| **`@UIX`** | `app_build/index.html` | Squelette sémantique, balises ARIA (`aria-live`, `aria-label`), ergonomie Mobile-First. |
| **`@OPS`** | `app_build/sw.js` | Service Worker avec stratégie Cache-First, versionnement dynamique `CACHE_VERSION = 'v2'`, nettoyage `activate`. |
| **`@OPS`** | `app_build/manifest.json` | Manifeste PWA W3C (`display: standalone`, icônes SVG/PNG, theme_color). |
| **`@AUD`** | `test_results.md` | Banc d'essai automatisé sous Chromium Headless, audit OWASP Top 10 et résilience offline. |
| **`@DOC`** | `User_Guide.md`, `Architecture_Walkthrough.md` | Manuels d'utilisation et spécifications architecturales post-validation. |

---

## 4. Critères d'Acceptation & Portes Qualité (Approval Gate)
- **100% Fonctionnel Offline** : Déconnexion simulée sans aucune interruption ni message d'erreur bloquant.
- **Sécurité** : 0 faille XSS détectée à l'injection de charges utiles test (`<script>`, `onload=`, etc.).
- **Performance** : Temps de chargement initial < 300ms, Lighthouse PWA & Accessibilité > 90/100.
- **Circuit Breaker** : Rework limité à 2 boucles maximum.