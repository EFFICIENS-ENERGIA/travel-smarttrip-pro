# 📜 RÈGLE 02 : RESPECT INVIOLABLE DU BUDGET ET DU RAYON KILOMÉTRIQUE

## 🎯 Objectif
Garantir une étanchéité budgétaire et géographique absolue. L'utilisateur ne doit JAMAIS voir une offre recommandée qui enfreint ses critères déclarés.

---

## 🚫 Interdictions Absolues
1. **ZÉRO DÉPASSEMENT BUDGÉTAIRE** : Aucune offre recommandée en tête de liste ne doit avoir un prix par nuit inférieur au minimum ou supérieur au maximum fixé par l'utilisateur (`price < minPrice` ou `price > maxPrice`).
2. **ZÉRO DÉPASSEMENT DU RAYON** : Aucune offre recommandée en tête de liste ne doit être située au-delà de la distance kilométrique maximale (`realDistKm > maxDistKm`).
3. **ZÉRO COMPLAISANCE STATIQUE** : Les filtres `inBudget` et `isWithinDist` sont des booléens stricts. Aucune marge de tolérance invisible ne doit être accordée au détriment de l'exigence de l'utilisateur.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Filtrage et Bornage Strict
```javascript
const inBudget = (minPrice === 0 || pNight >= minPrice) && (maxPrice >= 1000 || pNight <= maxPrice);
const isWithinDist = (dist === 0 || curDistKm <= dist);
```
Dans toute fonction de génération d'offres :
- `pNight = Math.max(minPrice, Math.min(maxPrice, pNight));`
- `curDistKm = Math.min(dist * dRatio, Math.max(0.1, dist - 0.1));`

### 2. Pénalités Graduées en Cas de Dépassement
Si un établissement physique dépasse les critères (Paliers 2, 3 et 4) :
- Pénalité budgétaire : `- (budgetDiff * 50)` points.
- Pénalité distance : calculée par tranche de 100 mètres excédentaires.
- Il est strictement impossible qu'une offre non conforme devance une offre conforme dans le tri par score décroissant.
