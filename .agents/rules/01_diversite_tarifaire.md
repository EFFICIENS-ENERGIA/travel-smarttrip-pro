# 📜 RÈGLE 01 : DIVERSITÉ & POSITIONNEMENT TARIFAIRE ORGANIQUE

## 🎯 Objectif
Bannir définitivement et irrévocablement l'uniformité des prix entre comparateurs. Chaque plateforme doit refléter sa réalité économique de marché et afficher un tarif distinct et réaliste.

---

## 🚫 Interdictions Absolues
1. **ZÉRO FORMULE UNIFORME** : Il est formellement interdit d'appliquer une formule de calcul statique identique pour toutes les plateformes (ex. appliquer un ratio fixe de $0.15$ à tout le monde).
2. **ZÉRO SURCLASSEMENT SYNTHÉTIQUE** : Une offre calibrée ou synthétique de repli ne doit **JAMAIS** obtenir un score de pertinence supérieur ou égal à un établissement physique réel et conforme.
3. **ZÉRO CLONE DE PRIX** : Au sein des 10 comparateurs, il ne doit jamais y avoir de prix identique accidentel résultant d'une paresse algorithmique.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Hiérarchie Stricte des Scores de Pertinence
- **Palier 1 (20 000+ points)** : Établissements physiques réels conformes à 100% au Budget ET au Rayon (`CURATED` ou API en direct).
- **Palier 1B (14 000 points)** : Offres de repli calibrées (`generateCalibratedPlatformDeals`). Elles ne comblent que les slots manquants (< 4 offres) et ne peuvent JAMAIS surclasser un vrai hôtel.
- **Palier 2 (10 000 points)** : Respecte le Budget mais dépasse le Rayon.
- **Palier 3 (5 000 points)** : Respecte le Rayon mais dépasse le Budget.
- **Palier 4 (< 5 000 points)** : Dépasse Budget et Rayon.

### 2. Modélisation de Marché Obligatoire (`PLAT_PROFILES`)
Toute génération de prix par comparateur doit exploiter la grille de positionnement économique :
- **Hostelworld** (Ratio base $0.10$) : Dortoirs, pods, auberges de jeunesse & ultra-budget.
- **Agoda** (Ratio base $0.18$) : Deals flash discount Asie & monde.
- **Kayak** (Ratio base $0.23$) : Smart deals & comparateur agile.
- **Booking.com** (Ratio base $0.28$) : Hôtels 3★ de référence standard & Genius.
- **Google Hotels** (Ratio base $0.32$) : Référence marché & scraping direct.
- **Expedia** (Ratio base $0.36$) : Packages confort & vol+hôtel.
- **Hotels.com** (Ratio base $0.40$) : Programme fidélité One Key VIP.
- **Tripadvisor** (Ratio base $0.44$) : B&B de charme & Travellers' Choice.
- **Airbnb** (Ratio base $0.48$) : Appartements entiers & lofts (+ frais de ménage/service).
- **Abritel** (Ratio base $0.52$) : Grandes maisons familiales & villas (+ frais).

### 3. Sel Cryptographique de Diversité
Pour chaque destination, un sel organique dérivé du nom de la ville et de la plateforme (`destSalt`) doit introduire une dispersion naturelle pour éviter tout alignement mathématique artificiel.
