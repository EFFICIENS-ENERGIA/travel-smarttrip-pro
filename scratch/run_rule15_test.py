import os, subprocess, time, sys

sys.stdout.reconfigure(encoding='utf-8')

print("=" * 70)
print("BANC D'ESSAI AUTOMATISÉ : RÈGLE 15 (GÉNÉRALISATION SYSTÉMIQUE SUR LES 10 OTA)")
print("=" * 70)

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

test_file = os.path.abspath("scratch/test_rule15_systemic_suite.html")
test_url = "file:///" + test_file.replace("\\", "/")
screenshot_path = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506\rule15_systemic_screenshot.png"

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--disable-web-security",
    "--virtual-time-budget=6000",
    f"--screenshot={screenshot_path}",
    "--window-size=1280,1400",
    test_url
]

print(f"Lancement de Microsoft Edge Headless sur : {test_url}")
t0 = time.time()
try:
    res = subprocess.run(cmd, capture_output=True, text=True, timeout=15)
except subprocess.TimeoutExpired:
    print("Edge process timed out after 15s")
elapsed = time.time() - t0
print(f"Capture d'écran générée : {screenshot_path} (Existe: {os.path.exists(screenshot_path)})")
if os.path.exists(screenshot_path):
    print(f"Taille de la capture : {os.path.getsize(screenshot_path)} octets")
print("=" * 70)
