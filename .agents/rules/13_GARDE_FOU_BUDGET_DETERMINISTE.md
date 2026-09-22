# 📜 RÈGLE 13 : GARDE-FOU DE BUDGET DÉTERMINISTE & POLITIQUE « AUCUN RÉSULTAT SOUS LE BUDGET »

> **Type** : Règle Métier & Sécurité Logicielle (Zero-Hallucination & Code-Level Guardrail)  
> **Auteur** : Seb (Manager / Product Owner)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets  

---

## 🎯 1. Contexte & Objectif
Garantir l'intégrité budgétaire absolue de l'application en interdisant formellement l'inclusion d'offres excédant le budget maximal du client (`user_max_budget`).  
Cette règle élimine toute complaisance ou hallucination algorithmique visant à "meubler" une interface avec des offres trop chères lorsque aucun logement ne rentre dans les critères.

---

## 🛡️ 2. Directives Intangibles & Spécifications Métier

### A. Injection en Amont
- La contrainte de prix maximal choisie par l'utilisateur doit être transmise dès la requête initiale de recherche, de scraping ou d'appel API :
  `max_price = user_max_budget` (ou paramètres équivalents `price_max=`, `maxPrice=`).
- Aucune requête ne doit être exécutée sans ce paramètre de cadrage financier.

### B. Filtrage Déterministe dans le Code Obligatoire
- Avant toute restitution dans l'interface ou dans les artéfacts finaux, un script de vérification déterministe ([`validate_and_filter_rentals.py`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/scripts/validate_and_filter_rentals.py) / [`validate_and_filter_rentals.ps1`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/scripts/validate_and_filter_rentals.ps1)) doit être exécuté.
- **Règle d'exclusion binaire** : Tout logement dont le prix par nuit dépasse `user_max_budget` est **systématiquement et irrévocablement exclu** du tableau principal `listings`.

### C. Politique Encadrée « Aucun Résultat sous le Budget »
1. **Statut Explicite `NO_MATCH_UNDER_BUDGET`** :
   - Si aucun établissement ne respecte le budget fixé, le système renvoie obligatoirement l'état explicite `"NO_MATCH_UNDER_BUDGET"`.
   - Il est formellement interdit à l'IA ou aux algorithmes de deviner, d'interpoler ou d'injecter des annonces au-dessus du budget dans la liste principale.
2. **Compartiment Étanche des Suggestions (`over_budget_suggestions`)** :
   - Les offres dépassant le budget jusqu'à un plafond strict de **+5 % maximum** (`user_max_budget * 1.05`) peuvent être présentées **uniquement dans une section secondaire distincte** : `over_budget_suggestions`.
   - Chaque suggestion hors budget doit obligatoirement porter l'attribut explicite :
     `is_over_budget_suggestion: true`.
   - Toute offre dépassant `user_max_budget * 1.05` est définitivement éliminée (0 affichage, même en suggestion).

### D. Schéma JSON Typé & Contrôle Qualité Sans Concession (@AUD)
- Le fichier d'artéfact [`production_artifacts/rentals_extracted.json`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/production_artifacts/rentals_extracted.json) doit respecter rigoureusement le schéma typé imposant :
  - `user_max_budget_eur` (numérique flottant pur),
  - `search_status` (`"SUCCESS"`, `"NO_MATCH_UNDER_BUDGET"`, `"PARTIAL_MATCH"`),
  - `is_over_budget_suggestion` (booléen sur chaque item).
- **Quality Gate @AUD** : L'auditeur @AUD rejette automatiquement l'artéfact au statut **FAILED** si :
  1. Une seule entrée du tableau `listings` dépasse `user_max_budget_eur`.
  2. Une seule entrée du tableau `listings` possède `is_url_verified: false` ou un code HTTP d'échec (ex: 404).
  3. Une entrée de `over_budget_suggestions` dépasse le seuil strict de +5%.

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour @DEV (Code Métier)** :
  - Interdiction absolue de modifier dynamiquement le prix pour le faire rentrer artificiellement sous la barre du budget.
  - Exécution du script de validation avant écriture dans le DOM ou dans le JSON.
- **Pour @UIX (Design & Ergonomie)** :
  - En cas de statut `NO_MATCH_UNDER_BUDGET`, afficher un message bienveillant et clair invitant à assouplir le budget ou les dates, sans jamais présenter d'écran blanc.
  - Les suggestions +5% doivent arborer un badge visuel distinct (ex: ambré avec mention « Suggestion +X € »).
- **Pour @AUD (Lead QA & Security)** :
  - Exécuter le banc d'essai automatisé [`audit_quality_gate.ps1`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/scratch/audit_quality_gate.ps1).
  - Validation binaire : 100% de conformité exigée avant transmission à Seb.

---

## 🧪 4. Protocole de Validation Obligatoire (@AUD)

1. **Test unitaire automatisé** :
   ```powershell
   powershell -ExecutionPolicy Bypass -File "scratch/audit_quality_gate.ps1"
   ```
2. **Critère de Succès Intransigeant** :
   - `search_status` valide (`SUCCESS`, `PARTIAL_MATCH` ou `NO_MATCH_UNDER_BUDGET`).
   - `0` anomalie de budget détectée dans `listings`.
   - `0` lien non vérifié dans `listings`.
   - **Verdict `@AUD` : PASSED obligatoire**.
