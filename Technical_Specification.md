# 📐 Spécification Technique : Moteur d'Extraction et de Recherche de Logements
**Projet** : `travel_dashboard`  
**Auteur** : `@CE` (Lead Orchestrator & Architect — Claude 3 Opus)  
**Supervision & Approbation** : `@coach` (Lead Tech Trainer & Engineering Coach — Claude 3 Opus)  
**Date** : 2026-09-12 10:10:00  
**Statut** : `[STATUS: APPROVED BY COACH]`  

---

## 1. Contexte & Enjeux Fonctionnels

Le tableau de bord `travel_dashboard` nécessite un sous-système d'extraction et d'interrogation d'annonces de logements garantissant une véracité absolue des données présentées à l'utilisateur final.  
En accord avec les règles fondamentales (Règle 01 Diversité tarifaire, Règle 02 Respect strict du budget et du rayon, Règle 09 Intégrité des contraintes et zéro repli silencieux, Règle 12 Véracité technique des liens, Règle 13 Garde-fou de budget déterministe et Règle 14 Fiabilité des audits & Ground Truth), ce module bannit toute estimation algorithmique non ancrée dans une source vérifiée.

---

## 2. Contrats d'Échange & Garde-Fous Déterministes

### A. Extraction Typée (Standard Zéro-Hallucination)
- **Schéma cible** : `.agents/skills/extract_rentals_skill/schemas/rentals_schema_v2.json`.
- **Règle de la valeur nulle** : Tout attribut non détecté de manière formelle dans les données brutes (ex: tarif manquant, titre tronqué, note inexistante) est obligatoirement instancié à `null`.
- **Interdiction formelle** : Toute extrapolation numérique (ex: "environ 130€", arrondi arbitraire, imputation par moyenne locale) ou génération d'adresse fictive est considérée comme un défaut bloquant de niveau critique (Fail-Stop).

### B. Filtrage Déterministe du Budget (`user_max_budget_eur`)
- **Condition de qualification principale** : Une annonce `item` ne peut intégrer `listings` que si et seulement si :
  $$\text{item.price\_per\_night\_eur} \le \text{user\_max\_budget\_eur}$$
- **Rejet automatique** : Tout prix strictement supérieur à `user_max_budget_eur` est exclu du flux principal.
- **Gestion des cas limites (`NO_MATCH_UNDER_BUDGET`)** :
  - Si aucune annonce ne remplit la condition de budget :
    $$\text{len}(\text{listings}) == 0 \implies \text{search\_status} = \text{"NO_MATCH\_UNDER\_BUDGET"}$$
  - Interdiction absolue d'abaisser les exigences ou d'injecter des logements plus onéreux pour meubler l'interface.
- **Suggestions secondaires (+5% max)** : Les logements dont le prix vérifié vérifie $\text{user\_max\_budget} < p \le \text{user\_max\_budget} \times 1.05$ sont cantonnés dans la collection isolée `over_budget_suggestions` avec le drapeau booléen explicite `is_over_budget_suggestion: true`.

### C. Validation Réseau HTTP des Liens (`validate_urls.py`)
- **Test d'accessibilité** : Chaque URL fait l'objet d'un contrôle de code de statut HTTP avec un `User-Agent` standardisé et un timeout strict de 5 secondes.
- **Codes admissibles** : `HTTP 200 OK`, `301/302 Redirection`, ou `403/429` (challenges WAF/Cloudflare considérés accessibles dans un contexte navigateur avec session utilisateur).
- **Codes de rejet** : `HTTP 404 Not Found`, `HTTP 500+`, erreurs DNS ou `Timeout` entraînent immédiatement `is_url_verified = false` et l'exclusion de la liste active `listings`.

---

## 3. Décomposition des Tâches & Architecture des Scripts

```text
.
├── .agents/skills/extract_rentals_skill-v2.md
├── .agents/skills/extract_rentals_skill/
│   ├── schemas/rentals_schema_v2.json
│   └── scripts/validate_urls.py
├── scripts/
│   └── run_rentals_engine.py
├── scratch/
│   ├── raw_rentals_test_matrix.json
│   └── test_edge_cases.py
└── production_artifacts/
    └── rentals_extracted.json
```

1. **`scratch/raw_rentals_test_matrix.json`** : Données brutes de banc d'essai intégrant cas nominaux, dépassements budgétaires, liens défaillants et données lacunaires.
2. **`scripts/run_rentals_engine.py`** : Orchestrateur Python (Claude 3.5 Sonnet / `@DEV`) assurant le filtrage, le dispatch HTTP et la sérialisation conforme au schéma v2.
3. **`test_results.md`** : Bilan d'audit d'assertions automatisées par `@AUD` (Claude 3 Opus).

---

## 4. Visa de Validation du Coach

> [!IMPORTANT]
> **Décision de Revue `@coach`** :  
> - **Lazy Invocation** : Respecté (Mobilisation de `@DEV` pour l'implémentation et `@AUD` pour l'audit).  
> - **Contrat de Transfert** : Typage JSON v2 strict avec gestion `null`.  
> - **Garde-Fous FinOps** : Session *Clean Slate*, respect du plafond 35k tokens.  
> 
> **Visa Formel** : `[STATUS: APPROVED BY COACH]` — Autorisation de passage en Phase 2 accordée.
