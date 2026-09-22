import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

brain_dir = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506"
harness_path = os.path.abspath("scratch/view_new_york_resolution.html").replace("\\", "/")

# Capture 1 : New York (Central Park, 40-180€)
out1 = os.path.join(brain_dir, "seb_resolution_new_york_usa_screenshot.png")
cmd1 = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--virtual-time-budget=9000",
    f"--screenshot={out1}",
    "--window-size=1280,2600",
    f"file:///{harness_path}?mode=nyc"
]
subprocess.run(cmd1, capture_output=True)
print(f"Capture NYC générée: {out1} (Existe: {os.path.exists(out1)})")

# Capture 2 : Hotel New York (Rotterdam)
out2 = os.path.join(brain_dir, "seb_resolution_hotel_new_york_rotterdam_screenshot.png")
cmd2 = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--virtual-time-budget=9000",
    f"--screenshot={out2}",
    "--window-size=1280,2600",
    f"file:///{harness_path}?mode=hotel_ny"
]
subprocess.run(cmd2, capture_output=True)
print(f"Capture Hotel NY Rotterdam générée: {out2} (Existe: {os.path.exists(out2)})")
