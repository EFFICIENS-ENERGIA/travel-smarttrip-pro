# 🌐 Spécification d'Architecture : Pipeline d'Agrégation Multi-Fournisseurs v2
**Document Réf** : `CE-SPEC-ROUTING-2026-09-12`  
**Auteur** : `@CE` (Lead Orchestrator & Architect — Claude 3 Opus)  
**Superviseur** : `@coach` (Lead Tech Trainer)  
**Projet** : `travel_dashboard`  
**Statut** : `[APPROUVÉ PAR LE LEAD ARCHITECTE]`  

---

## 1. Contexte & Problématique Métier

Le système de recherche de logements de `travel_dashboard` doit agréger en temps réel 4 flux hétérogènes de données :
- **Google Hotels** (Méta-moteur physique & avis)
- **Kayak** (Agrégateur OTA multi-partenaires)
- **Booking.com** (OTA direct avec inventaire hôtelier et appartements)
- **Airbnb** (Logements entiers entre particuliers et professionnels)

### Risques Identifiés :
1. **Doublons d'établissements physiques** sous des appellations commerciales divergentes (ex: *"Grand Hotel Milano"* sur Booking vs *"Grand Hotel de Milan & Spa"* sur Kayak).
2. **Divergences tarifaires** dues aux taxes et commissions variables (Règle 01 Diversité tarifaire & Règle 13 Garde-fou budget déterministe).
3. **Sursolicitation des flux (Rate Limiting / Quotas)** et blocages WAF (Cloudflare, Akamai).

---

## 2. Clé Universelle de Déduplication Physique (`DEDUP_KEY`)

Pour éviter d'afficher deux fois le même établissement physique dans `listings`, le système calcule une clé canonique déterministe :

$$\text{DEDUP\_KEY} = \text{SHA256}\left(\text{Round}(\text{lat}, 4) \;\|\; \text{Round}(\text{lng}, 4) \;\|\; \text{Normalize}(\text{name})\right)$$

### Algorithme de Normalisation du Nom (`Normalize`) :
1. Conversion en minuscules (`lowercase`).
2. Suppression des accents et caractères diacritiques (NFD -> ASCII).
3. Élagage des termes génériques hôteliers : `hotel`, `residence`, `resort`, `spa`, `grand`, `boutique`, `aparthotel`, `chambres`, `b&b`.
4. Suppression des caractères spéciaux et espaces superflus.

*Exemple concret* :
- Source A : `"Grand Hôtel Duomo Milano & Spa"` -> `geo:(45.4642, 9.1905)` -> Termes épurés : `"duomo milano"`.
- Source B : `"Hotel Duomo Milan"` -> `geo:(45.4641, 9.1904)` -> Termes épurés : `"duomo milano"`.
- Clé identique à $\Delta < 50\text{m}$ -> **Fusion déterministe en un seul établissement physique**, conservation de l'offre la plus économique sous budget.

---

## 3. Matrice de Priorisation & Résolution des Conflits Tarifaires

Conformément à la **Règle 01 (Diversité Tarifaire)** et à la **Règle 14 (Ground Truth)** :
1. **Priorité aux Données Physiques Réelles** : Un hôtel physiquement vérifié au cadastre / OSM surpasse toute annonce non géo-référencée.
2. **Meilleur Prix Net Vérifié** : En cas de doublon avéré, l'offre retenue pour l'affichage principal est celle présentant le `price_per_night_eur` le plus faible **sous réserve d'un lien HTTP vérifié (`200 OK`)**.
3. **Consolidation Multi-OTA** : Les liens vers les autres plateformes sont rattachés sous forme d'options de comparaison dans la modale `#hotelDetailModal`.

---

## 4. Contrat d'Échange Inter-Services (`RoutingResponse`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "AggregatedRoutingResponse",
  "type": "object",
  "required": ["timestamp", "query_city", "user_budget_eur", "total_raw_found", "total_deduplicated", "providers_status", "listings"],
  "properties": {
    "timestamp": { "type": "string", "format": "date-time" },
    "query_city": { "type": "string" },
    "user_budget_eur": { "type": "number" },
    "total_raw_found": { "type": "integer" },
    "total_deduplicated": { "type": "integer" },
    "providers_status": {
      "type": "object",
      "properties": {
        "google_hotels": { "type": "string", "enum": ["UP", "DEGRADED", "DOWN"] },
        "kayak": { "type": "string", "enum": ["UP", "DEGRADED", "DOWN"] },
        "booking": { "type": "string", "enum": ["UP", "DEGRADED", "DOWN"] },
        "airbnb": { "type": "string", "enum": ["UP", "DEGRADED", "DOWN"] }
      }
    },
    "listings": {
      "type": "array",
      "items": { "$ref": "../.agents/skills/extract_rentals_skill/schemas/rentals_schema_v2.json#/properties/listings/items" }
    }
  }
}
```

---

## 5. Garde-fous de Sécurité & Validation (@AUD)
- Tout flux externe doit être assaini (`sanitizeHTML`) avant injection dans le DOM.
- Aucune requête ne doit dépasser 5 secondes de latence par provider.
