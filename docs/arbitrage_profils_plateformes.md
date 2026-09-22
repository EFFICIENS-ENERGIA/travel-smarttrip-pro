# 📊 Note d'Arbitrage : Modélisation des Profils Économiques OTA (Règle 01)
**Document Réf** : `CE-NOTE-OTA-PROFILES-2026`  
**Auteur** : `@CE` (Lead Orchestrator & Architect — Claude 3 Opus)  
**Superviseur** : `@coach` (Lead Tech Trainer)  
**Date** : 2026-09-12  

---

## 1. Objectif & Conformité Règle 01

La **Règle 01 (Diversité & Positionnement Tarifaire Organique)** interdit catégoriquement l'usage de formules statiques uniformes (ex: `prix * 0.95` ou écarts artificiels constants) entre plateformes.  
Chaque comparateur doit refléter sa réalité de marché et son modèle économique :

| Plateforme | Profil Marché | Commission / Frais Constatés | Spécificités d'Affichage |
|---|---|:---:|---|
| **Google Hotels** | Méta-moteur de référence | 0% utilisateur (Redirection directe) | Prix de référence officiel net |
| **Booking.com** | Leader hôtelier européen | 15% à 18% prélevés sur l'hôtelier | Tarifs souvent alignés avec le site officiel |
| **Kayak** | Comparateur méta | Redirection partenaires | Variations selon agrégateur sous-jacent |
| **Agoda** | Spécialiste Asie / Promotions éclair | Réductions flash mobiles (-3% à -8%) | Prix souvent compétitif mais conditions strictes |
| **Expedia** | Groupe mondial | Forfaits vol+hôtel | Alignement tarifaire standard |
| **Hotels.com** | Fidélité Rewards | Inclus 1 nuit offerte pour 10 | Prix affiché incluant le programme fidélité |
| **Trivago** | Méta-chercheur | Comparaison brute | Redirection vers marchands tiers |
| **Tripadvisor** | Avis & comparateur | Enchères au clic | Présentation de la meilleure offre partenaire |
| **Priceline** | Express Deals | Remises opaques (-10% à -15%) | Réservation sans confirmation du nom préalable |
| **Airbnb** | Logements entiers & hôtes | ~14% frais de service voyageur | Prix incluant frais de ménage et service |

---

## 2. Règle Déterministe d'Extraction sans Biais
- Interdiction d'ajuster artificiellement un prix pour favoriser un partenaire.
- Enregistrement brut du `price_per_night_eur` tel que retourné par l'API/HTML du partenaire.
- En cas de frais annexes obligatoires non mentionnés, affecter `fees_breakdown: null` sans estimer de montant forfaitaire.
