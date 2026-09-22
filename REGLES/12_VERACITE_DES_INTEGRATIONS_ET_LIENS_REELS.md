# 📜 RÈGLE 12 : VÉRACITÉ DES INTÉGRATIONS & LIENS RÉELS

> **Type** : Règle Intégration / Sécurité / Viabilité des Liens Web  
> **Auteur** : Seb (Manager / Product Owner) & CE (Chef d'Équipe)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets

---

## 🎯 1. Contexte & Objectif

Dans les versions antérieures, des dysfonctionnements majeurs de liens sortants ont été identifiés :
1. **Pollution textuelle** : injection de chaînes parasites (ex: `"pour 3 personnes"`) dans le champ de recherche Google Hotels.
2. **Filtres restrictifs artificiels** : génération de fourchettes de prix microscopiques arbitraires (ex: `price_min=23&price_max=50` sur Airbnb alors que l'utilisateur avait demandé jusqu'à 70 € sans minimum), aboutissant à **"Aucun résultat trouvé"**.
3. **Contamination croisée de cache** : utilisation de clés de repères non cloisonnées par ville (ex: repère `"aeroport"` pollué par une recherche précédente au Japon appliqué à Milan).

**Exigence formelle de Seb : Les liens doivent systématiquement être vérifiés quel que soit le projet. Zéro lien mort, zéro filtre destructeur de résultats, zéro conjecture.**

---

## 🛡️ 2. Directives Intangibles

1. **Zéro Conjecture sur les Formats d'URL** : Tout schéma d'URL ou paramètre d'intégration (query strings, paramètres GET) doit être conforme aux spécifications réelles des plateformes tierces.
2. **Interdiction des Filtres Artificiels Destructeurs** :
   - Si l'utilisateur n'a pas défini de budget minimum (`minPrice === 0`), ne **JAMAIS** injecter de paramètre `price_min` arbitraire.
   - Le paramètre `price_max` doit refléter fidèlement le plafond fixé par l'utilisateur, sans être réduit artificiellement par des formules locales.
   - Ne jamais forcer de filtres catégoriels trop restrictifs (ex: `room_types[]=Entire home/apt`) dans les liens de recherche génériques qui réduiraient à néant les propositions viables.
3. **Interdiction de la Pollution de Requête** :
   - Ne jamais mélanger le nombre de voyageurs, les dates ou des mots-clés parasites dans un champ destiné au nom d'un établissement ou d'une ville.
   - Utiliser exclusivement les paramètres officiels dédiés (ex: `&adults=X`, `&checkin=YYYY-MM-DD`).
4. **Cloisonnement Strict des Repères Géodésiques par Ville** :
   - Tout cache ou dictionnaire de repères urbains doit être indexé par une clé composite destination + repère (`${lmKey}_${destKey}`).
   - Interdiction formelle d'utiliser un mot-clé générique global (ex: `"aeroport"`, `"gare"`, `"centre"`) sans rattachement strict à la ville sélectionnée.
5. **Sécurité Web Inviolable** :
   - 100% des liens sortants ouvrant un nouvel onglet (`target="_blank"`) doivent impérativement comporter l'attribut `rel="noopener noreferrer"`.
6. **Véracité des Données Affichées** :
   - Tout nom d'établissement, adresse physique, coordonnées GPS ou note affichée doit correspondre à une réalité vérifiable et cohérente avec la ville sélectionnée.

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour DEV (Fullstack)** :
  - Encoder rigoureusement chaque paramètre avec `encodeURIComponent()`.
  - Construire les paramètres de prix de manière conditionnelle et fidèle aux filtres réels :
    ```javascript
    let airbnbPriceParams = "";
    if (minPrice > 0) airbnbPriceParams += `&price_min=${minPrice}`;
    if (maxPrice < 1000) airbnbPriceParams += `&price_max=${maxPrice}`;
    ```
  - Épurer les chaînes de recherche avant injection dans les deep-links :
    ```javascript
    const cleanTargetQuery = isFallback ? `hotels ${dest}` : cleanQuery;
    const directUrl = `https://www.google.com/travel/hotels?q=${encodeURIComponent(cleanTargetQuery)}&dates=${ci}%2C${co}&adults=${guestsNum}&hl=fr`;
    ```
  - Cloisonner les accès de géocodage :
    ```javascript
    const compositeKey = `${lmKey}_${destKey}`;
    // UNIQUEMENT compositeKey, JAMAIS lmKey seul
    ```
- **Pour AUD (Lead QA)** :
  - Auditer syntaxiquement et structurellement toutes les URLs générées par l'outil pour chaque plateforme.
  - Vérifier l'absence totale de texte parasite (`pour X personnes`) et de filtres de prix destructeurs (`price_min` inventé).
  - Vérifier par expression régulière que 100% des liens `target="_blank"` possèdent bien `rel="noopener noreferrer"`.
  - Exécuter des tests de viabilité réels des liens sur des scénarios représentatifs avant toute mise en production.
- **Pour DOC & UIX** :
  - S'assurer que le texte de l'interface annonce clairement la destination du lien (pas de clic trompeur / clickbait).

---

## 🧪 4. Protocole de Validation Obligatoire (AUD)

Avant toute remise de version à Seb :
1. **Analyse automatisée de 100% des liens et redirections** : extraction de toutes les URLs et validation de leurs query strings.
2. **Contrôle de conformité des bornes de recherche** : vérifier que les URLs reflètent fidèlement les critères utilisateur sans altération.
3. **Contrôle d'intégrité géographique** : s'assurer qu'aucun repère n'affiche d'adresse ou de label issu d'une autre métropole.
4. **Certification formelle** : rapport d'audit confirmant **0 lien corrompu, 0 filtre destructeur, 100% de liens sécurisés et viables**.
