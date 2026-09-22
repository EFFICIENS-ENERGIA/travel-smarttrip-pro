# 📜 RÈGLE 04 : SYNCHRONISATION MIROIR OBLIGATOIRE (INDEX.HTML & TRAVEL_DASHBOARD.HTML)

## 🎯 Objectif
Éliminer tout risque de divergence ou de code obsolète entre les fichiers sources de l'application.

---

## 🚫 Interdictions Absolues
1. **ZÉRO DIVERGENCE FONCTIONNELLE** : Les fichiers [`index.html`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/index.html) et [`travel_dashboard.html`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/travel_dashboard.html) doivent être rigoureusement identiques au niveau du moteur JavaScript, des styles CSS et de la structure HTML.
2. **ZÉRO MODIFICATION ISOLÉE** : Il est formellement interdit de modifier `index.html` sans reporter la modification dans `travel_dashboard.html`, et réciproquement.
3. **ZÉRO VALIDATION SANS CONTRÔLE DE PARITÉ** : Aucun livrable n'est accepté si les deux fichiers n'ont pas la même taille en octets et la même signature fonctionnelle.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Protocole de Modification Bivalente
À chaque session de travail de l'équipe :
1. **DEV** applique les modifications sur le fichier cible.
2. **DEV** propage immédiatement l'intégralité du diff sur le fichier miroir.
3. **AUD** vérifie l'équivalence des tailles et des comportements :
   ```powershell
   (Get-Item index.html).Length -eq (Get-Item travel_dashboard.html).Length
   ```

### 2. Périmètre de Synchronisation
- Blocs d'algorithme : `generateCalibratedPlatformDeals`, `getPlatformTop4Listings`, `renderComparisonCards`, `renderOfferCard`.
- Bases de données intégrées : `CURATED`, `CERTIFIED_FALLBACKS`, `TEMPLATES`, `TAX_DATA`.
- Modales et utilitaires : `#hotelDetailModal`, `formatCurrencyPrice`, `trackOutboundClick`.
