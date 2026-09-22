# 📜 RÈGLE 03 : INTÉGRITÉ MULTI-DEVISES & COHÉRENCE MONÉTAIRE

## 🎯 Objectif
Empêcher toute incohérence monétaire (comme l'incident historique du Japon où les yens écrasaient les euros et produisaient des prix aberrants).

---

## 🚫 Interdictions Absolues
1. **ZÉRO ÉCRASEMENT DE LA DEVISE UTILISATEUR** : La devise de navigation choisie par l'utilisateur (`window.USER_CURRENCY`, par défaut `EUR`) ne doit JAMAIS être réécrite automatiquement lors de la saisie d'une destination étrangère.
2. **ZÉRO MÉLANGE D'UNITÉS** : Les curseurs de budget, les montants par nuit, les totaux de séjour et les badges doivent TOUJOURS être exprimés dans la devise active `USER_CURRENCY`.
3. **ZÉRO MULTIPLICATEUR FANTÔME** : Ne jamais multiplier un montant de base déjà converti par un taux de change secondaire.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Séparation Devise Utilisateur / Devise Locale
- `window.USER_CURRENCY` : Devise principale d'affichage et de filtrage (`EUR`, `USD`, `GBP`, `CHF`, `JPY`, `CAD`).
- `window.LOCAL_DEST_CURRENCY` : Devise locale du pays visité, stockée uniquement à titre indicatif.

### 2. Formatage Visuel Universel
Tout prix affiché doit suivre la convention de double affichage transparent :
- Si `LOCAL_DEST_CURRENCY !== USER_CURRENCY` :
  `107 € /nuit TTC (≈ 17 500 ¥)`
- Si les devises sont identiques :
  `107 € /nuit TTC`

### 3. Synchronisation Totale des Composants
Chaque changement de devise doit propager instantanément les symboles monétaires (`window.CURRENCY_SYMBOLS`) :
- Sliders de budget (`minPriceCurrSymbol`, `maxPriceCurrSymbol`)
- Cartes des 10 comparateurs
- Duel 3 Voies (`duelCurrencyLabelG/B/A`)
- Simulateur TCO et panier global
