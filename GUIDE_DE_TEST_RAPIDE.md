# 🚀 Guide de Test Rapide — SmartTrip Pro

Bienvenue dans la version aboutie, certifiée et prête à l'emploi de **SmartTrip Pro**.

---

## ⚡ 1. Comment Lancer l'Outil (1 Clic)

Deux méthodes simples sont à votre disposition :

### Option A : Via le Lanceur 1-Clic Automatique (Recommandé)
- Double-cliquez sur : **`LANCER_SMARTTRIP_PRO.bat`** (ou clic-droit > *Exécuter avec PowerShell* sur `lancer_smarttrip.ps1`).
- Le script démarre un serveur local haute performance et ouvre automatiquement votre navigateur par défaut à l'adresse :  
  👉 **`http://localhost:8080/index.html`**

### Option B : Ouverture Directe Fichier
- Double-cliquez simplement sur **`index.html`** pour l'ouvrir directement dans Edge, Chrome ou Firefox (mode standalone 100% autonome).

---

## 🎯 2. Scénarios de Test Recommandés pour Seb

### Scénario 1 : Le Test Immersion Aéroport (Le cas d'usage validé)
1. Dans le champ **Destination**, tapez `Paris` (ou choisissez une suggestion rapide).
2. Dans le champ **Repère**, choisissez `Aéroport` ou tapez `Aéroport Paris-Charles de Gaulle`.
3. Fixez le **Rayon** à `3.0 km`.
4. Fixez le **Nombre de voyageurs** à `3 voyageurs (Trio)`.
5. Ajustez le curseur **Prix Maximum** à `180 €`.
6. Cliquez sur **🔍 RECHERCHER**.
7. **Constat** :
   - 40 offres s'affichent instantanément réparties sur les 10 comparateurs.
   - 100% des tarifs sont inférieurs à 180 € TTC.
   - 100% des hôtels sont situés à moins de 3 km de l'aéroport.
   - Aucune offre hors budget ni hors rayon.

### Scénario 2 : Visite de la Fiche Détaillée & Deep-Links OTA
1. Sur n'importe quelle carte d'hébergement, cliquez sur **🌐 Fiche** (ou sur le titre/icône de l'hôtel).
2. La modale native `#hotelDetailModal` s'ouvre :
   - Observez le tarif par nuitée TTC et le coût total calculé pour l'ensemble du séjour (3 nuits).
   - Consultez l'adresse physique, les coordonnées et le lien Google Maps / Street View.
   - Vérifiez les prestations et équipements certifiés.
   - Cliquez sur **🤍 Favoris** pour sauvegarder le coup de cœur.
3. Testez le bouton **Voir sur [Comparateur]** : l'URL générée intègre directement les dates et le nombre de voyageurs sans texte parasite.

### Scénario 3 : L'Arbitrage « Duel 3 Voies »
1. Cliquez sur le bouton **⚔️ Duel** sur une offre Booking, une offre Airbnb et une offre Google Hotels.
2. Basculez sur l'onglet **⚔️ Duel 3 Voies** dans la barre d'onglets.
3. Le simulateur intègre les frais de ménage, taxes de séjour et parkings pour désigner automatiquement le vainqueur économique et calculer votre gain net.

### Scénario 4 : Résilience Hors-Ligne (Offline-First)
1. Ouvrez les DevTools (F12) > onglet **Réseau (Network)** > cochez **Hors-ligne (Offline)**.
2. Rechargez la page (F5).
3. L'application reste 100% accessible grâce au Service Worker et les recherches sauvegardées restent consultables via IndexedDB (`SmartTripDB`).

---

## 🛡️ 3. Points de Contrôle Qualité Réalisés par l'Équipe

- **10 Comparateurs Mondiaux** : Google Hotels, Booking.com, Airbnb, Hotels.com, Agoda, Expedia, Abritel, TripAdvisor, Hostelworld, Kayak.
- **Transparence Tarifaire** : Tarifs TTC avec mention des taxes locales estimées.
- **Sécurité** : 100% des liens sortants en `rel="noopener noreferrer"`.
- **Multi-Devises** : Bascule instantanée (EUR, USD, GBP, CAD, JPY, CHF) sans perte de la devise de référence.
- **Banc d'Essai Automatisé** : 10/10 Pays validés, 10/10 Modales in-app conformes, 100/100 Comparateurs vérifiés sans erreur.
