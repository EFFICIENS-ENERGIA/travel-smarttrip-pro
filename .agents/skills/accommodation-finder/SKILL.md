---
name: accommodation-finder
description: >-
  Expert de la recherche, du filtrage et de la comparaison d'hébergements et d'hôtels
  (Booking.com, comparateurs) selon la destination, les dates, le budget et la proximité d'un lieu clé.
---

# Guide de Recherche d'Hébergement & Logement

Ce skill guide l'agent pour mener des recherches rigoureuses et trouver les hébergements optimaux pour l'utilisateur.

## Méthodologie

1. **Collecte des critères clés** :
   - **Lieu / Point de repère** (adresse, hôtel, centre de congrès, gare).
   - **Dates exactes** : Arrivée (check-in) et Départ (check-out) pour calculer le nombre total de nuits.
   - **Composition** : Nombre d'adultes, enfants, nombre de chambres.
   - **Budget max** / nuit ou pour le séjour complet.

2. **Cartographie et calcul de proximité** :
   - Identifier le quartier et les stations de transports les plus proches (lignes de métro, bus, train).
   - Calculer la distance réelle (à pied, transports, taxi).
   - Explorer les quartiers adjacents bien connectés pour trouver des alternatives moins chères.

3. **Analyse multi-plateformes & Méta-moteurs (100% gratuit)** :
   - Exécuter le script d'automatisation local :
     [MultiPlatformSearch.ps1](./scripts/MultiPlatformSearch.ps1)
     ```powershell
     powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/MultiPlatformSearch.ps1' -Location "<Lieu>" -Landmark "<Monument/Adresse>" -MaxDistanceKm <Km> -CheckIn "<YYYY-MM-DD>" -CheckOut "<YYYY-MM-DD>" -Guests <Nb> -MinBudget <MinEUR> -MaxBudget <MaxEUR>
     ```
   - **Pour les Hôtels & Appart'hôtels** : Interroger Google Hotels et Kayak (comparaison Booking, Expedia, Agoda, direct).
   - **Pour les Locations de particuliers (Airbnb / Abritel)** : Utiliser HomeToGo / Holidu pour regrouper 100% du marché sans API payante.
   - Calculer le coût total du séjour (prix/nuit × nombre de nuits + taxes/extras éventuels).

4. **Présentation des résultats** :
   - Tableau synthétique clair (Nom, Type, Distance, Prix/nuit, Total séjour, Source / Plateforme).
   - Liens directs pré-filtrés vers chaque plateforme (Google Hotels, HomeToGo, Booking, Kayak).
   - Conseils pratiques (bouclier d'annulation gratuite, transports et parking, événements locaux).

## Préférences favorites de l'utilisateur
- **Type d'hébergement privilégié** : Polyvalent (Hôtels traditionnels avec service ET Appartements / Appart'hôtels avec cuisine pour cuisiner).
- **Petit-déjeuner & Repas** : Indiquer systématiquement l'option petit-déjeuner pour les hôtels, et la présence d'une cuisine pour les appartements.
- **Transports & Parking** : Vérifier et afficher toujours la proximité d'un arrêt de transport (métro/tramway) ET les options pour garer la voiture (parking).
- **Annulation & Flexibilité** : Comparer systématiquement le tarif avec **bouclier magique (Annulation gratuite)** et le tarif **non remboursable (le moins cher)**.
- **Confort & Sommeil d'or** : Vérifier systématiquement la présence de la **climatisation (air frais)** et privilégier les hébergements bien insonorisés et calmes.
- **Classement Podium & Notes** : Présenter les choix sous forme de podium :
  - 🥇 **Médaille d'or (Top Confort)** : Note >= 8.5/10 (propreté et accueil irréprochables).
  - 🥈 **Médaille d'argent (Top Éco)** : Note >= 7.5/10 (très bon compromis budget).
  - ⚠️ Écarter systématiquement les établissements notés en-dessous de 7/10.
## Règles pour les recherches à l'étranger (International)
1. **Toponymie & Traduction des villes** :
   - Traduire systématiquement les noms de villes étrangères en **anglais** et dans la **langue locale** (ex: *Rome* ➔ *Roma*, *Munich* ➔ *München*, *Florence* ➔ *Firenze*, *Séville* ➔ *Sevilla*, *Londres* ➔ *London*) pour maximiser le taux de résultats pertinents.
2. **Spécialistes régionaux** :
   - **Asie & Pacifique** (Japon, Thaïlande, Bali, Vietnam...) : Consulter et prioriser **Agoda** (tarifs souvent 15% à 30% plus bas que les centrales européennes).
   - **Amérique du Nord** (USA, Canada, Mexique) : Consulter **Expedia** et **HomeToGo/VRBO**.
3. **Frais cachés et taxes locales** :
   - **Taxes de séjour obligatoires** : Signaler les « City Taxes » locales (ex: Italie, Espagne, Japon) qui sont généralement facturées sur place par personne et par nuit.
   - **Resort Fees / Amenity Fees** : Aux États-Unis et aux Caraïbes, toujours vérifier et alerter l'utilisateur si l'hôtel facture des frais d'établissement supplémentaires (souvent $30 à $50/nuit).
   - **Devise** : Indiquer le tarif converti en **EUR (€)** et rappeler la devise locale pour éviter les frais bancaires de change inattendus.

## Le Top 10 Mondial des Plateformes de Location & Super-pouvoirs
L'agent utilise la matrice suivante pour choisir la meilleure plateforme selon le profil du voyage :

1. 🌐 **Google Hotels (Rang 1 - Méta-moteur Ultime)** : Compare en temps réel tous les prix du web pour trouver qui vend la même chambre le moins cher.
2. 🛎️ **Booking.com (Rang 2 - Leader mondial hôtels)** : Le choix incontournable pour les hôtels, appart'hôtels et annulation flexible sans avance.
3. 🏡 **Airbnb (Rang 3 - Particuliers & Villas)** : Leader incontournable des logements uniques, insolites et appartements chez l'habitant avec cuisine.
4. 🔍 **HomeToGo (Rang 4 - Méta-locations)** : Agrège en une seule recherche Airbnb, Abritel, Vrbo, Novasol et Booking.
5. 🌏 **Agoda (Rang 5 - Roi de l'Asie)** : Prioritaire pour l'Asie et le Pacifique (tarifs souvent 15% à 30% inférieurs).
6. 🗽 **Expedia (Rang 6 - Leader Amérique)** : Prioritaire pour les USA/Canada et les packages vol+hôtel.
7. 🏖️ **Abritel / Vrbo (Rang 7 - Grandes villas)** : Idéal pour les grands groupes, familles nombreuses et maisons avec piscine.
8. 🚄 **Trip.com (Rang 8 - Géant mondial)** : Très compétitif pour la Chine, l'Asie et les tarifs négociés internationaux.
9. 🎒 **Hostelworld (Rang 9 - Ultra-budget)** : Le n°1 mondial des auberges de jeunesse, dortoirs et séjours économiques.
10. 🧭 **Kayak (Rang 10 - Comparateur multi-agences)** : Vue cartographique complète et historique des tendances de prix.

## Enrichissement en direct via Micro-APIs Libres (100% sans clé)
Le script [MultiPlatformSearch.ps1](./scripts/MultiPlatformSearch.ps1) intègre automatiquement deux flux d'informations ouverts et gratuits :
1. **Taux de change en direct (Frankfurter API)** :
   - Détecte automatiquement la devise locale de la destination (USD, JPY, GBP, CHF, CAD, THB, MAD, etc.).
   - Calcule la parité en temps réel avec l'Euro (ex: `1 EUR = 1.16 USD (100 USD ≈ 86.21 EUR)`).
2. **Météo prévisionnelle (Open-Meteo API)** :
   - Géocode instantanément la ville de destination.
   - Renvoie la température minimale, maximale et la condition météo (Ensoleillé, Pluie, Neige, etc.) pour adapter les conseils d'hébergement (présence d'une piscine, climatisation, parapluie).

## 1. Surveillance Automatique des Baisses de Prix (Commande `/schedule`)
L'agent peut surveiller un voyage de façon récurrente sans intervention humaine :
* **Déclencheur utilisateur** : L'utilisateur tape `/schedule` ou demande à l'agent de surveiller un voyage à intervalle régulier.
* **Fonctionnement natif** : L'agent programme une tâche planifiée d'arrière-plan (ex. tous les matins à 9h ou tous les lundis) pour ré-exécuter la recherche, vérifier si les tarifs ont baissé ou si de nouvelles disponibilités sont apparues, et envoyer une notification directe dans le chat.

## 2. Générateur de Rappels Calendrier (`.ics`)
Pour sécuriser les réservations et ne jamais dépasser la date limite d'annulation gratuite :
* **Script dédié** : [GenerateCalendarReminder.ps1](./scripts/GenerateCalendarReminder.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/GenerateCalendarReminder.ps1' -HotelName "<Nom Hôtel>" -CheckIn "<YYYY-MM-DD>" -CheckOut "<YYYY-MM-DD>" -CancellationDeadline "<YYYY-MM-DDTHH:mm:ss>" -Address "<Adresse>" -Price "<Prix>"
  ```
* **Contenu du fichier `.ics` (compatible Google Calendar, Apple, Outlook)** :
  1. Événement séjour complet du Check-in au Check-out avec adresse et tarif.
  2. Alarme d'urgence 24h et 2h avant l'expiration de l'annulation gratuite.

## 3. Calculateur de « Coût Réel Tout Compris » (TCO - Total Cost of Stay)
Pour comparer loyalement un Airbnb et un Hôtel sans mauvaise surprise :
* **Script dédié** : [CalculateTotalCost.ps1](./scripts/CalculateTotalCost.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/CalculateTotalCost.ps1' -BasePricePerNight <Prix> -Nights <NbNuits> -Guests <NbPers> -CleaningFee <Ménage> -CityTaxPerPersonPerNight <Taxe> -ParkingPerDay <Parking> -TransitPerPersonPerDay <Métro>
  ```
* **Formule mathématique appliquée** :
  $$\text{Coût réel} = (\text{Prix nuit} \times \text{Nuits}) + \text{Frais ménage} + (\text{Taxe séjour} \times \text{Pers.} \times \text{Nuits}) + (\text{Parking} \times \text{Nuits}) + (\text{Transports} \times \text{Pers.} \times \text{Nuits}) + \text{Resort fees}$$
* Présente systématiquement le coût total, le coût réel par nuit et le coût réel par personne.

## 4. Bouclier Anti-Arnaques & Vérificateur d'Avis
L'agent applique un protocole d'inspection rigoureux avec **4 critères éliminatoires** :
1. ⚠️ **Volume d'avis insuffisant** : Moins de 10 avis vérifiés ➔ Alerte vigilance immédiate.
2. 🆕 **Ancienneté du profil** : Établissement ou hôte créé il y a moins de 3 mois ➔ Alerte nouveau profil sans historique.
3. 🛑 **Mots-clés d'alerte rouge** : Scan systématique des avis négatifs pour détecter les signaux critiques : *punaises de lit, cafards, saleté, bruit insupportable, annulation dernière minute par l'hôte, caution retenue abusivement*.
4. 📉 **Incohérence des notes** : Écart supérieur à 1 point entre la note d'emplacement et la note de propreté (indique souvent un logement très bien placé mais délabré ou mal entretenu).

## 5. Détecteur de Jours Fériés & Pics de Prix (API Nager.Date)
Pour anticiper les envolées tarifaires et la saturation des disponibilités :
* **Script dédié** : [CheckPublicHolidays.ps1](./scripts/CheckPublicHolidays.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/CheckPublicHolidays.ps1' -Destination "<Ville>" -StartDate "<YYYY-MM-DD>" -EndDate "<YYYY-MM-DD>"
  ```
* Interroge les calendriers officiels de plus de 100 pays et alerte si des jours fériés ou ponts nationaux coïncident avec le séjour.

## 6. Négociateur Diplomatique Multilingue pour Hôtes
Pour obtenir 10% à 15% de réduction ou des avantages gracieux :
* **Script dédié** : [NegotiateStay.ps1](./scripts/NegotiateStay.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/NegotiateStay.ps1' -Scenario "Discount" -Language "IT" -GuestName "<Prénom>" -Nights <Nb> -DiscountPercent 12
  ```
* Scénarios supportés : `Discount` (remise séjour long), `EarlyCheckIn` (arrivée anticipée/bagages), `WiFiCheck` (débit fibre pro), `LateCheckOut` (départ tardif).
* Langues : Français (`FR`), Anglais (`EN`), Espagnol (`ES`), Italien (`IT`), Allemand (`DE`), Japonais (`JA`).

## 7. Carnet de Voyage Hors-Ligne & Fiche d'Urgence
Pour disposer de toutes les informations clés sans aucune connexion Internet à l'étranger :
* **Script dédié** : [GenerateTravelHandbook.ps1](./scripts/GenerateTravelHandbook.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/GenerateTravelHandbook.ps1' -Destination "<Ville, Pays>" -HotelName "<Hôtel>" -Address "<Adresse>" -CheckIn "<YYYY-MM-DD>" -CheckOut "<YYYY-MM-DD>"
  ```
* Génère un fichier HTML/Markdown autonome et imprimable avec les numéros d'urgence locaux (police, secours, consulat de France) et un lexique local d'accueil.

## 8. Calculateur de Distance Piétonne & Walk Score (OSRM / OpenStreetMap)
Pour mesurer le temps de marche réel et l'accessibilité sans voiture :
* **Script dédié** : [CalculateWalkScore.ps1](./scripts/CalculateWalkScore.ps1)
  ```powershell
  powershell -ExecutionPolicy Bypass -File '.agents/skills/accommodation-finder/scripts/CalculateWalkScore.ps1' -Origin "<Adresse Logement>" -Target "<Monument ou Gare>"
  ```
* Calcule l'itinéraire piéton réel en mètres et minutes, et attribue une note d'accessibilité sur 10.

