---
name: extract_rentals_skill-v2
description: "Skill d'Extraction & Validation de Données Déterministes v2, standard Zero-Hallucination, typage strict JSON/Pydantic, vérification HTTP et filtrage de budget dans le code."
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

# 📊 SKILL d'Extraction & Validation Déterministe v2 (`extract_rentals_skill-v2.md`)

**Rôle** : Extraction, typage strict et validation déterministe d'annonces de logements sans aucune hallucination.  
**Agents Utilisateurs** : `@DEV`, `@extract_rentals`  
**Superviseur & Coach** : `@CE`, `@coach` (Claude 3 Opus)  
**Auditeur Qualité & Sécurité** : `@AUD` (Claude 3 Opus)  

---

## 🎯 1. Mission & Standard Zéro-Hallucination

Garantir une extraction de données 100% vérifiable, rigoureuse et exempte de toute extrapolation artificielle :
1. **Zéro Estimation / Zéro Invention** :
   - Interdiction formelle d'inventer, estimer, moyenner ou extrapoler un prix, une localisation, une note ou un nom d'établissement.
   - **Règle de la valeur nulle** : Si une information est absente de la source brute ou ambiguë, affecter obligatoirement la valeur `null`.
2. **Filtrage Déterministe du Budget (`user_max_budget_eur`)** :
   - Le filtrage s'exécute impérativement dans le code Python (`price <= user_max_budget_eur`).
   - Rejet automatique de toute annonce dépassant le budget fixé du tableau principal `listings`.
   - En l'absence totale d'offre respectant le budget, renvoyer explicitement `search_status = "NO_MATCH_UNDER_BUDGET"` sans jamais injecter d'offres hors budget pour "remplir" l'interface.
   - Les annonces en léger dépassement (tolérance maximale de +5%) ne peuvent figurer que dans la collection distincte `over_budget_suggestions` avec `is_over_budget_suggestion: true`.
3. **Validation HTTP des Liens (Anti-URL Cassées)** :
   - Exécution du script de validation réseau `validate_urls.py` dans le bac à sable.
   - Chaque URL doit répondre avec un code de succès (`200 OK` ou redirection valide `301/302`) ou un challenge WAF navigateur (`403/429`).
   - Tout lien renvoyant une erreur client `404 Not Found`, une erreur serveur `500` ou un dépassement de délai (*timeout*) est invalidé (`is_url_verified: false`) et écarté de `listings`.

---

## 📋 2. Schéma JSON Typé Strict (`rentals_schema_v2.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "RentalListingListV2",
  "type": "object",
  "required": [
    "extracted_at",
    "user_max_budget_eur",
    "total_valid_listings",
    "search_status",
    "listings",
    "over_budget_suggestions"
  ],
  "properties": {
    "extracted_at": {
      "type": "string",
      "format": "date-time",
      "description": "Horodatage ISO 8601 UTC de l'extraction"
    },
    "user_max_budget_eur": {
      "type": "number",
      "minimum": 0,
      "description": "Budget maximal strict défini par l'utilisateur"
    },
    "total_valid_listings": {
      "type": "integer",
      "minimum": 0,
      "description": "Nombre exact d'offres qualifiées sous budget"
    },
    "search_status": {
      "type": "string",
      "enum": ["SUCCESS", "NO_MATCH_UNDER_BUDGET", "PARTIAL_MATCH"]
    },
    "listings": {
      "type": "array",
      "description": "Liste principale des offres validées respectant le budget et l'intégrité HTTP",
      "items": {
        "type": "object",
        "required": [
          "id",
          "title",
          "price_per_night_eur",
          "url",
          "is_url_verified",
          "is_over_budget_suggestion"
        ],
        "properties": {
          "id": { "type": "string" },
          "title": { "type": ["string", "null"] },
          "location": { "type": ["string", "null"] },
          "price_per_night_eur": { "type": ["number", "null"] },
          "currency": { "type": "string", "default": "EUR" },
          "url": { "type": "string", "format": "uri" },
          "is_url_verified": { "type": "boolean" },
          "http_status": { "type": ["integer", "null"] },
          "is_over_budget_suggestion": { "type": "boolean", "enum": [false] }
        }
      }
    },
    "over_budget_suggestions": {
      "type": "array",
      "description": "Suggestions secondaires en dépassement maîtrisé (+5% max)",
      "items": {
        "type": "object",
        "required": [
          "id",
          "title",
          "price_per_night_eur",
          "url",
          "is_url_verified",
          "is_over_budget_suggestion"
        ],
        "properties": {
          "id": { "type": "string" },
          "title": { "type": ["string", "null"] },
          "location": { "type": ["string", "null"] },
          "price_per_night_eur": { "type": ["number", "null"] },
          "currency": { "type": "string", "default": "EUR" },
          "url": { "type": "string", "format": "uri" },
          "is_url_verified": { "type": "boolean" },
          "http_status": { "type": ["integer", "null"] },
          "is_over_budget_suggestion": { "type": "boolean", "enum": [true] }
        }
      }
    }
  }
}
```

---

## 🛠️ 3. Protocole Exécutable & Scripts

| Composant | Fichier | Rôle |
|---|---|---|
| **Vérificateur HTTP** | `scripts/validate_urls.py` | Contrôle réseau des URLs via requête HTTP HEAD/GET avec timeout de 5s |
| **Moteur de Filtrage** | `scripts/run_rentals_engine.py` | Pipeline unifié de validation de schéma, filtrage déterministe et écriture de l'artéfact |
| **Artéfact Final** | `production_artifacts/rentals_extracted.json` | Données certifiées conformes pour le tableau de bord |

---

## 🛡️ 4. Quality Gate d'Approbation (@AUD)

Pour obtenir le visa de mise en production, l'artéfact doit impérativement valider :
1. **Assertion Budget** : `all(l['price_per_night_eur'] <= user_max_budget for l in listings) == True`.
2. **Assertion Intégrité URL** : `all(l['is_url_verified'] is True for l in listings) == True`.
3. **Assertion Zéro-Hallucination** : `all(l['title'] is not None or l['price_per_night_eur'] is not None for l in listings)`.
4. **Assertion Statut Limite** : Si `len(listings) == 0`, `search_status` est rigoureusement `"NO_MATCH_UNDER_BUDGET"`.
