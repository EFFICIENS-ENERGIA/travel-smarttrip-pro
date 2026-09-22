---
name: extract_rentals_skill
description: "Skill d'Extraction & Validation de Données Déterministes, typage strict JSON/Pydantic, vérification HTTP et filtrage de budget dans le code."
tools:
  - view_file
  - replace_file_content
  - run_command
  - web_search
  - browse_url
subagent: true
model: flash
commandExecutionPolicy: sandbox
---

# 📊 SKILL de Données Déterministes & Zéro-Hallucination (`extract_rentals_skill.md`)

**Rôle** : Extrait et valide les données métiers complexes (ex: logements, tarifs, fiches produits, disponibilités).  
**Agents Utilisateurs** : `@DEV`, `@extract_rentals_agent`  
**Supervision & Arbitrage** : `@CE`  
**Audit & Quality Gate** : `@AUD`  

---

## 🎯 1. Mission & Responsabilité

Garantir l'extraction et la restitution de données 100% fiables, vérifiables et exploitables sans aucune hallucination d'intelligence artificielle :
- Ne jamais deviner, estimer, ni extrapoler de prix ou de nom d'établissement.
- Appliquer les filtres métiers (plafond de budget, rayon) directement dans le code exécutable avant toute présentation à l'utilisateur.
- Valider systématiquement l'existence réseau des URLs par des requêtes HTTP réelles avant intégration dans l'artéfact final.

---

## 🏛️ 2. Garanties de Qualité Intransigeantes

### A. Format Typé Strict (JSON Schema & Pydantic)
- Utilisation obligatoire du schéma [`schemas/rentals_schema.json`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/schemas/rentals_schema.json) ou modèle Pydantic équivalent.
- Tout champ absent ou incertain dans la source HTML/API reçoit la valeur stricte `null` (jamais de texte inventé).
- Typage numérique strict : `price_per_night_eur` est un nombre flottant pur (ex: `120.50`), excluant tout format textuel approximatif (ex: `"environ 120€"`).

### B. Vérification HTTP Exécutable des Liens (Health Check)
- Chaque lien extrait est soumis à un test de disponibilité HTTP en direct (`HTTP 200 OK` ou redirection valide `301/302`).
- Les challenges anti-bot WAF (`HTTP 403 / 429`) sont qualifiés opérationnels pour un navigateur réel avec session utilisateur.
- Tout lien renvoyant une erreur `404 Not Found`, une erreur DNS ou un dépassement de délai (*timeout*) est **rejeté immédiatement** du jeu de données (`is_url_verified: false`).

### C. Filtre de Budget dans le Code (`user_max_budget_eur`)
- Injection amont du filtre de prix (`max_price=...`) dans les requêtes de recherche.
- Application d'un filtre déterministe dans le code : **tout logement dont le prix dépasse `user_max_budget_eur` est strictement exclu du tableau principal `listings`**.
- Gestion explicite des états :
  - Si aucune offre ne respecte le budget : `search_status = "NO_MATCH_UNDER_BUDGET"`.
  - Suggestions en léger dépassement (tolérance maximale de **+5%**) : isolées exclusivement dans le bloc `over_budget_suggestions` avec l'indicateur `is_over_budget_suggestion: true`.

---

## 📋 3. Schéma de Données Typé (`rentals_schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "RentalListingList",
  "type": "object",
  "required": ["extracted_at", "user_max_budget_eur", "total_valid_listings", "listings"],
  "properties": {
    "extracted_at": { "type": "string", "format": "date-time" },
    "user_max_budget_eur": { "type": "number" },
    "total_valid_listings": { "type": "integer" },
    "search_status": {
      "type": "string",
      "enum": ["SUCCESS", "NO_MATCH_UNDER_BUDGET", "PARTIAL_MATCH"]
    },
    "listings": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "title", "price_per_night_eur", "url", "is_url_verified", "is_over_budget_suggestion"],
        "properties": {
          "id": { "type": "string" },
          "title": { "type": ["string", "null"] },
          "location": { "type": ["string", "null"] },
          "price_per_night_eur": { "type": ["number", "null"] },
          "currency": { "type": "string", "default": "EUR" },
          "url": { "type": "string", "format": "uri" },
          "is_url_verified": { "type": "boolean" },
          "http_status": { "type": ["integer", "null"] },
          "is_over_budget_suggestion": { "type": "boolean", "default": false }
        }
      }
    },
    "over_budget_suggestions": {
      "type": "array",
      "items": { "$ref": "#/properties/listings/items" }
    }
  }
}
```

---

## 🛠️ 4. Scripts d'Exécution & Garde-Fous Déterministes

| Script | Environnement | Action & Rôle |
|---|---|---|
| [`validate_and_filter_rentals.py`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/scripts/validate_and_filter_rentals.py) | Python 3.5+ | Filtre le budget, teste les URLs via `urllib` et génère l'artéfact `production_artifacts/rentals_extracted.json`. |
| [`validate_and_filter_rentals.ps1`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/scripts/validate_and_filter_rentals.ps1) | PowerShell Natif Windows | Exécution immédiate zéro-dépendance sous Windows pour le filtrage et les requêtes HTTP. |
| [`validate_urls.ps1`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/.agents/skills/extract_rentals_skill/scripts/validate_urls.ps1) | PowerShell Natif Windows | Vérification HTTP ciblée autonome des listes d'URLs. |

---

## 🛡️ 5. Quality Gate & Protocole d'Audit (@AUD)

Toute extraction doit franchir la porte d'approbation (@AUD) :
1. **Validation du Budget** : 0 offre dans `listings` avec `price_per_night_eur > user_max_budget_eur`.
2. **Validation des Liens** : 100% des offres principales ont `is_url_verified == true`.
3. **Artéfact Final** : Fichier certifié dans `production_artifacts/rentals_extracted.json`.
