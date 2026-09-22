---
name: stitch-ui
description: >-
  Expert en design d'interfaces utilisateur (UI), design systems (DESIGN.md) et création
  de composants et dashboards web interactifs selon le standard Google Stitch pour Antigravity.
---

# Google Stitch UI Skill pour Antigravity

Ce skill permet à l'agent de concevoir, structurer et générer des interfaces utilisateur (UI) modernes, ergonomiques et interactives basées sur les principes de **Google Stitch** et le standard **Agent Skills**.

## Capacités clés

1. **Design System & Architecture (`DESIGN.md`)** :
   - Élaboration de chartes graphiques cohérentes (palette sémantique, typographie, espacements).
   - Adaptation automatique aux thèmes clair et sombre (Dark/Light mode) via variables CSS (`--background`, `--card`, `--primary`, `--foreground`).

2. **Génération d'Interfaces Web Riches (Generative UI)** :
   - Création d'applications web interactives monopages (SPA) autonomes en HTML5, Tailwind CSS et JavaScript moderne sans dépendance lourde.
   - Composants réutilisables : cartes interactives, formulaires dynamiques, modales, graphiques et calculateurs en temps réel.

3. **Intégration Antigravity** :
   - Affichage inline direct dans la conversation via la balise `<agent-embed src="file:///.../widget.html"></agent-embed>`.
   - Export en artéfacts prêts à l'emploi et utilisables dans n'importe quel navigateur.

4. **Styles & Chartes Graphiques intégrées** :
   - **Style Duolingo ("Feather" / 3D Chunky)** :
     - Typographie : `Nunito` (graisses 700 à 900), coins arrondis (`rounded-2xl`).
     - Boutons physiques 3D : `box-shadow: 0 4px 0 var(--shadow);` et pressés au clic avec `transform: translateY(4px); box-shadow: 0 0 0 transparent;`.
     - Palette vive : Vert Duo (`#58CC02` / ombre `#46A302`), Bleu Macaw (`#1CB0F6` / ombre `#1899D6`), Or (`#FFC800`), Orange (`#FF9600`), Rouge (`#FF4B4B`).
     - Cartes épaisses : `border: 2px solid #E5E5E5; border-bottom: 4px solid #DCDCDC;`.
     - Gamification : Jauge de progression pilule avec reflet glossy, compteurs d'XP et mascotte interactive.

