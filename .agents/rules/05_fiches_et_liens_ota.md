# 📜 RÈGLE 05 : PÉRENNITÉ DES FICHES LOGEMENT & DES DEEP-LINKS OTA

## 🎯 Objectif
Garantir que chaque interaction utilisateur (consultation de fiche, clic sortant vers un comparateur, copie de lien) fonctionne sans faille et sans dégradation.

---

## 🚫 Interdictions Absolues
1. **ZÉRO FICHE INACCESSIBLE OU MORTE** : Tout clic sur un titre d'hébergement, son icône, ou le bouton dédié **🌐 Fiche** doit instantanément ouvrir la modale native `#hotelDetailModal`.
2. **ZÉRO POLLUTION DANS LES REQUÊTES D'URL** : Il est interdit d'injecter des mentions textuelles naturelles (comme `"pour X personnes"`) dans le paramètre de recherche `q=` des API hôtelières (notamment Google Hotels). Le nombre de voyageurs est exclusivement transmis via `adults=X`.
3. **ZÉRO LIEN SORTANT NON SÉCURISÉ** : 100% des balises `<a>` pointant vers l'extérieur doivent porter `target="_blank"` et `rel="noopener noreferrer"`.
4. **ZÉRO FAIL-SOFT BLOQUANT** : Si une ressource externe (tuile Leaflet, API météo, reverse géocodeur) est inaccessible, l'application doit basculer silencieusement sur ses fallbacks locaux sans altérer l'interface.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Structure de la Modale Native In-App (`#hotelDetailModal`)
La modale doit comporter les données certifiées :
- Nom officiel complet sans troncature
- Catégorie d'établissement et icône thématique
- Note certifiée sur 10 et volume d'avis vérifiés
- Adresse postale physique exacte + lien interactif Google Maps / Street View
- Décomposition tarifaire exhaustive (prix/nuit, durée, taxes de séjour, frais de ménage/service, total TTC)
- Badge d'économie par rapport au plafond budgétaire de l'utilisateur
- Liste des équipements majeurs vérifiés (Wi-Fi Fibre, Climatisation, Parking, etc.)
- Boutons d'action : Réserver via la plateforme officielle, Comparer sur Google Hotels, Duel 3 Voies, Favoris.

### 2. Standardisation des URL des 10 Comparateurs
Chaque constructeur d'URL dans `PLATFORMS` doit impérativement respecter :
- `googletravel` : `https://www.google.com/travel/search?q=${cleanQuery}&dates=${ci}_${co}&adults=${g}`
- `booking` : `https://www.booking.com/searchresults.html?ss=${dest}&checkin=${ci}&checkout=${co}&group_adults=${g}`
- `airbnb` : `https://www.airbnb.fr/s/${dest}/homes?checkin=${ci}&checkout=${co}&adults=${g}`
- `hotelscom` / `expedia` / `agoda` / `kayak` / `hostelworld` / `abritel` / `tripadvisor` : schémas d'URL validés avec encodage strict `encodeURIComponent`.
