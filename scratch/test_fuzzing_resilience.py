import os
import sys
import json

# Exécution du moteur durci sur la matrice de fuzzing
sys.path.append("scripts")
from run_rentals_engine import process_rentals_engine

def run_fuzzing_audit():
    print("=== [AUDIT FUZZING & INJECTIONS - @AUD (Claude 3 Opus)] ===")
    fuzz_src = "scratch/fuzzing_injection_matrix.json"
    fuzz_dst = "scratch/fuzzing_output.json"
    
    # Test avec budget 120 EUR
    data = process_rentals_engine(fuzz_src, fuzz_dst, user_max_budget=120.0)

    # Assertions de sécurité sans concession
    print("\n• Assertion Fuzzing 1 : Rejet formel des prix négatifs...")
    neg_item = next((x for x in data['listings'] if x['id'] == 'fuzz_negative_price'), None)
    assert neg_item is None, "FAILLE : Le prix négatif a été accepté dans listings !"
    print("  -> PASS : Prix négatif rejeté.")

    print("• Assertion Fuzzing 2 : Rejet formel des prix NaN et chaînes non numériques...")
    nan_item = next((x for x in data['listings'] if x['id'] == 'fuzz_nan_price'), None)
    str_item = next((x for x in data['listings'] if x['id'] == 'fuzz_string_formatted_price'), None)
    assert nan_item is None, "FAILLE : Le prix NaN a été accepté !"
    assert str_item is None, "FAILLE : Le prix chaîne '125,50 €' a été accepté !"
    print("  -> PASS : NaN et chaînes textuelles rejetés.")

    print("• Assertion Fuzzing 3 : Neutralisation XSS des balises HTML...")
    xss_item = next((x for x in data['listings'] if x['id'] == 'fuzz_xss_script'), None)
    assert xss_item is not None, "Item XSS manquant (devait être accepté mais assaini)"
    assert "<script>" not in xss_item['title'], "FAILLE CRITIQUE XSS : balise <script> non échappée !"
    assert "&lt;script&gt;" in xss_item['title'], "L'échappement HTML n'a pas été appliqué correctement"
    assert "<img" not in xss_item['location'], "FAILLE CRITIQUE XSS : balise <img> non échappée !"
    print("  -> PASS : Payloads XSS parfaitement neutralisés (&lt;script&gt;).")

    print("• Assertion Fuzzing 4 : Rejet des schémas d'URL malveillants (javascript: et file://)...")
    js_url_item = next((x for x in data['listings'] if x['id'] == 'fuzz_malformed_url_scheme'), None)
    file_url_item = next((x for x in data['listings'] if x['id'] == 'fuzz_file_url_scheme'), None)
    assert js_url_item is None, "FAILLE CRITIQUE : URL javascript: injectée dans listings !"
    assert file_url_item is None, "FAILLE CRITIQUE : URL file:/// injectée dans listings !"
    print("  -> PASS : Schémas non-HTTP/HTTPS rejetés immédiatement.")

    print("• Assertion Fuzzing 5 : Rejet des entrées vides et prix nuls...")
    empty_item = next((x for x in data['listings'] if x['id'] == 'fuzz_empty_payload'), None)
    assert empty_item is None, "FAILLE : Annonce vide sans URL/prix acceptée !"
    print("  -> PASS : Annonce vide écartée.")

    print("\n=======================================================")
    print("[SUCCESS] TOUTES LES ÉPREUVES DE FUZZING SONT VALIDÉES (5/5 PASS)")
    print("=======================================================")

if __name__ == "__main__":
    try:
        run_fuzzing_audit()
        sys.exit(0)
    except AssertionError as e:
        print("\n[ÉCHEC AUDIT FUZZING] : {0}".format(e))
        sys.exit(1)
