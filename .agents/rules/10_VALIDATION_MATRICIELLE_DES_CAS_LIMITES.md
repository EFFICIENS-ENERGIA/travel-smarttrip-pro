# 📜 RÈGLE 10 : VALIDATION MATRICIELLE DES CAS LIMITES & MULTI-CONFIGURATIONS

> **Type** : Règle Qualité / Banc d'Essai / Stress Testing  
> **Auteur** : Seb (Manager / Product Owner) & CE (Chef d'Équipe)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets

---

## 🎯 1. Contexte & Objectif

L'expérience a démontré qu'un test isolé sur un cas standard (ex: 2 voyageurs à Paris en Euros) masquait des dysfonctionnements critiques dès que l'utilisateur modifiait les paramètres (ex: 3 voyageurs, Japon, devises étrangères, petits budgets).

**L'objectif de cette règle est d'imposer une validation matricielle croisée systématique avant toute déclaration de conformité.**

---

## 🛡️ 2. Directives Intangibles

1. **Interdiction de la Validation Mono-Cas** : Aucun projet, module ou fonctionnalité ne peut être déclaré fonctionnel sur la base d'un seul test unitaire réussi.
2. **Matrice Multi-Axes Obligatoire** : Tout outil traitant des données variables doit être testé sur une matrice croisant :
   - **L'axe des jauges** : cas minimal, cas intermédiaire, cas maximal (ex: 2, 3, 4, 5, 6 personnes).
   - **L'axe géographique / international** : local, européen, mondial, Asie, Amériques.
   - **L'axe monétaire** : EUR, USD, JPY, GBP, CAD, CHF avec conversions cohérentes.
   - **L'axe des valeurs limites** : budgets très bas, budgets élevés, rayons courts, rayons larges.
   - **L'axe des états limites** : état initial au chargement, état après recherche, état après remise à zéro (Reset).
3. **Seuil d'Excellence 100% PASS** : 100% des cases de la matrice doivent afficher le statut **PASS**. Zéro cas d'échec toléré.

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour DEV (Fullstack)** :
  - Développer le code métier de façon purement paramétrique sans valeur "en dur" (hardcodée) pour un cas particulier.
- **Pour AUD (Lead QA)** :
  - Concevoir un script de banc d'essai matriciel (ex: 10 destinations $\times$ 5 jauges = 50 scénarios) exécutable en mode headless.
  - Générer une capture d'écran horodatée prouvant le passage au vert de chaque scénario.
- **Pour UIX (Design & Accessibilité)** :
  - Tester l'affichage de la matrice sous différentes résolutions (desktop 1920x1080, tablette, smartphone).

---

## 🧪 4. Protocole de Validation Obligatoire (AUD)

Avant toute remise de version à Seb :
1. Exécution du banc d'essai matriciel.
2. Capture d'écran certifiée sauvegardée en artéfact.
3. Affichage du score synthétique (ex: **50/50 PASS**) dans le rapport d'audit remis à Seb.
