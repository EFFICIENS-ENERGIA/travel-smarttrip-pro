# 📜 RÈGLE 08 : SANCTUARISATION DES ACQUIS & NON-RÉGRESSION CONTINUE

> **Type** : Règle Qualité / Architecture / QA  
> **Auteur** : Seb (Manager / Product Owner) & CE (Chef d'Équipe)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets

---

## 🎯 1. Contexte & Objectif

Au cours des itérations passées, plusieurs anomalies corrigées ont réapparu ultérieurement à l'occasion de refactorings ou d'ajouts de nouvelles fonctionnalités (ex: régression sur la remise à zéro, régression sur le filtrage des budgets, divergence de prix).

**L'objectif de cette règle est d'interdire définitivement tout retour en arrière : tout acquis validé par Seb devient une barrière inviolable.**

---

## 🛡️ 2. Directives Intangibles

1. **Zéro Régression Tolérée** : Toute fonctionnalité, correction de bug ou optimisation validée lors d'un échange précédent est réputée acquise et sanctuarisée.
2. **Assertion Automatisée Obligatoire** : Dès qu'un bug est corrigé, **AUD** et **DEV** doivent immédiatement créer un test d'assertion automatisé dans le banc d'essai pour empêcher sa réapparition.
3. **Barrière Pré-Livraison (Gate)** : Il est formellement interdit de livrer du code ou de clore une tâche si un seul test d'acquis antérieur échoue. Le taux d'exécution des tests de non-régression doit être de **100% PASS**.

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour DEV (Fullstack)** :
  - Ne jamais supprimer ni affaiblir une condition de filtrage ou un garde-fou préexistant lors d'un refactoring.
  - Préserver systématiquement les structures de données validées (`localStorage`, schémas de données, signatures de fonctions publiques).
- **Pour AUD (Lead QA & Security)** :
  - Maintenir un fichier de banc d'essai exhaustif (ex: `test_matrix_suite.html`, `test_deep_suite.html`).
  - Exécuter la suite complète de non-régression sous Edge Chromium Headless avant chaque remise de livrable.
- **Pour OPS (DevOps & Résilience)** :
  - Verrouiller les artefacts validés et s'assurer que les sauvegardes locales (`localStorage`, caches) survivent aux rechargements sans perte d'état.

---

## 🧪 4. Protocole de Validation Obligatoire (AUD)

Avant toute restitution à Seb :
1. **AUD** exécute la batterie complète de non-régression.
2. Tout échec bloque immédiatement la livraison et renvoie le code à **DEV** pour correction prioritaire.
3. Le rapport d'audit certifie que le nombre de tests passants est supérieur ou égal à l'itération précédente.
