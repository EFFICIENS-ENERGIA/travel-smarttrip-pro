import json
import sys

def run_qa_assertions():
    print("=== [AUDIT QA & SECURITY - @AUD (Claude 3 Opus)] ===")
    
    # Test 1 : Vérification de l'artéfact nominal
    with open("production_artifacts/rentals_extracted.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    print("• Test 1 : Schema JSON v2 et Typage Strict...")
    assert "extracted_at" in data, "Cle manquante : extracted_at"
    assert "user_max_budget_eur" in data, "Cle manquante : user_max_budget_eur"
    assert "total_valid_listings" in data, "Cle manquante : total_valid_listings"
    assert "search_status" in data, "Cle manquante : search_status"
    assert "listings" in data, "Cle manquante : listings"
    assert "over_budget_suggestions" in data, "Cle manquante : over_budget_suggestions"
    print("  -> PASS : Schema structurellement valide.")

    print("• Test 2 : Respect Inviolable du Budget (price <= user_max_budget)...")
    budget = data["user_max_budget_eur"]
    assert budget == 150.0, "Budget inattendu"
    for item in data["listings"]:
        p = item["price_per_night_eur"]
        assert p is not None, "Prix null dans la liste active des offres tarifees"
        assert p <= budget, "VIOLATION BUDGET : offre a {0}€ > {1}€".format(p, budget)
        assert item["is_over_budget_suggestion"] is False, "is_over_budget_suggestion doit etre False dans listings"
    print("  -> PASS : 0 offre sur {0} ne depasse {1} EUR.".format(len(data['listings']), budget))

    print("• Test 3 : Integrite Reseau HTTP des Liens (is_url_verified == True)...")
    for item in data["listings"]:
        assert item["is_url_verified"] is True, "Lien non verifie : {0}".format(item['url'])
        assert item["http_status"] in (200, 201, 202, 301, 302, 403, 429), "Code HTTP invalide : {0}".format(item['http_status'])
    print("  -> PASS : 100% des {0} offres actives ont une URL valide.".format(len(data['listings'])))

    print("• Test 4 : Isolement Strict des Suggestions Hors Budget (+5% max)...")
    for sug in data["over_budget_suggestions"]:
        p = sug["price_per_night_eur"]
        assert p > budget, "Suggestion a {0}€ devrait etre dans listings".format(p)
        assert p <= budget * 1.05, "Suggestion a {0}€ depasse le seuil max de +5% ({1}€)".format(p, budget * 1.05)
        assert sug["is_over_budget_suggestion"] is True, "Drapeau is_over_budget_suggestion manquant"
    print("  -> PASS : {0} suggestion(s) cantonnee(s) dans over_budget_suggestions.".format(len(data['over_budget_suggestions'])))

    print("• Test 5 : Standard Zero-Hallucination (Null Handling)...")
    item_null = next((x for x in data["listings"] if x["id"] == "item_02_valid_zero_hallucination_nulls"), None)
    assert item_null is not None, "Item item_02 introuvable"
    assert item_null["title"] is None, "Titre hallucine : {0}".format(item_null['title'])
    assert item_null["location"] is None, "Localisation vehiculee non nulle : {0}".format(item_null['location'])
    assert item_null["price_per_night_eur"] == 135.0, "Prix altere"
    print("  -> PASS : Preservation stricte de null sans conjecture ni hallucination.")

    print("• Test 6 : Cas Limite Zero Resultat (NO_MATCH_UNDER_BUDGET)...")
    with open("scratch/rentals_no_match.json", "r", encoding="utf-8") as f:
        no_match_data = json.load(f)
    assert no_match_data["search_status"] == "NO_MATCH_UNDER_BUDGET", "Statut incorrect : {0}".format(no_match_data['search_status'])
    assert len(no_match_data["listings"]) == 0, "listings ne doit pas contenir d'offres"
    assert len(no_match_data["over_budget_suggestions"]) == 0, "over_budget_suggestions doit etre vide"
    assert no_match_data["total_valid_listings"] == 0, "total_valid_listings doit valoir 0"
    print("  -> PASS : Statut NO_MATCH_UNDER_BUDGET parfaitement respecte (0 repli silencieux).")

    print("\n=======================================================")
    print("[SUCCESS] TOUTES LES ASSERTIONS D'AUDIT SONT VALIDEES (6/6 PASS)")
    print("=======================================================")

if __name__ == "__main__":
    try:
        run_qa_assertions()
        sys.exit(0)
    except AssertionError as e:
        print("\n[ECHEC ASSERTION] : {0}".format(e))
        sys.exit(1)
