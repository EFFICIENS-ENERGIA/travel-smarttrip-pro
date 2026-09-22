import os, subprocess, sys, json, re

sys.stdout.reconfigure(encoding='utf-8')

print("=" * 70)
print("BANC D'ESSAI AUTOMATISÉ v2 : CIBLAGE D'ÉTABLISSEMENTS & GROUND TRUTH")
print("=" * 70)

edge_paths = [
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
]
edge_path = next((p for p in edge_paths if os.path.exists(p)), None)
assert edge_path, "Navigateur Edge introuvable"

test_file = os.path.abspath("scratch/test_hotel_reliability_suite_v2.html")
test_url = "file:///" + test_file.replace("\\", "/")
screenshot_path = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506\test_hotel_reliability_v2_screenshot.png"

print(f"Lancement de Microsoft Edge Headless sur : {test_url}")

# Exécuter Edge avec capture d'écran et virtual-time-budget
cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--virtual-time-budget=12000",
    f"--screenshot={screenshot_path}",
    "--window-size=1280,1200",
    test_url
]

subprocess.run(cmd, capture_output=True)

# Dump DOM pour vérifier les résultats
dump_cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--virtual-time-budget=12000",
    "--dump-dom",
    test_url
]

res = subprocess.run(dump_cmd, capture_output=True, text=True, encoding='utf-8', errors='ignore')
dom = res.stdout

# Extraire les tests du DOM
test_boxes = re.findall(r'<div class="test-box (pass|fail)">\s*<div[^>]*>\s*<span[^>]*>([^<]+)</span>\s*<span class="badge [^"]*">([^<]+)</span>\s*</div>\s*<div[^>]*>([^<]+)</div>\s*<pre>([^<]*)</pre>', dom)

print("\nRÉSULTATS DÉTAILLÉS DU BANC D'ESSAI :")
all_pass = True
for status, t_id, badge, title, details in test_boxes:
    is_ok = status == 'pass'
    if not is_ok:
        all_pass = False
    print(f"  [{' PASS ' if is_ok else ' FAIL '}] {t_id} : {title}")
    if not is_ok:
        print(f"         Détails: {details}")

print("=" * 70)
print(f"TOTAL TESTS DÉTECTÉS : {len(test_boxes)}")
print(f"CAPTURE D'ÉCRAN : {screenshot_path} (Existe: {os.path.exists(screenshot_path)})")
if all_pass and len(test_boxes) >= 10:
    print("STATUT GLOBAL : 100% PASS - TOUS LES CRITÈRES SONT HOMOLOGUÉS")
else:
    print("STATUT GLOBAL : ÉCHECS DÉTECTÉS")
print("=" * 70)
