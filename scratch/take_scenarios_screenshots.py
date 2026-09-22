import os, subprocess, sys, time

sys.stdout.reconfigure(encoding='utf-8')

print("=" * 70)
print("GÉNÉRATION DES CAPTURES D'ÉCRAN RÉELLES DES 3 SCÉNARIOS DE SEB")
print("=" * 70)

edge_paths = [
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
]
edge_path = next((p for p in edge_paths if os.path.exists(p)), None)
assert edge_path, "Navigateur Edge introuvable"

artifacts_dir = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506"
scenarios = [
    ("rome", "scenario1_rome_screenshot.png", "Scénario 1 : Rome (3p, max 60 €, max 4 km)"),
    ("barcelona", "scenario2_barcelona_screenshot.png", "Scénario 2 : Barcelone (2p, max 80 €, max 3 km)"),
    ("miami", "scenario3_miami_screenshot.png", "Scénario 3 : Miami (5p, max 110 €, max 3 km)")
]

for scen_key, img_name, label in scenarios:
    test_file = os.path.abspath("scratch/view_scenario.html")
    test_url = "file:///" + test_file.replace("\\", "/") + f"?scen={scen_key}"
    shot_path = os.path.join(artifacts_dir, img_name)
    print(f"\nCapture de : {label}...")
    print(f"URL : {test_url}")
    print(f"Fichier : {shot_path}")

    cmd = [
        edge_path,
        "--headless",
        "--disable-gpu",
        "--allow-file-access-from-files",
        "--virtual-time-budget=10000",
        f"--screenshot={shot_path}",
        "--window-size=1280,1200",
        test_url
    ]
    subprocess.run(cmd, capture_output=True)
    print(f"Status : {'Succès' if os.path.exists(shot_path) else 'Échec'}")

print("\n" + "=" * 70)
print("CAPTURES TERMINÉES AVEC SUCCÈS")
print("=" * 70)
