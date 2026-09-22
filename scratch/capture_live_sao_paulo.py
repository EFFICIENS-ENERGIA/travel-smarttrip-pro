import os, subprocess, time, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

test_file = os.path.abspath("travel_dashboard.html")
# On ouvre avec hash pour tester
test_url = "file:///" + test_file.replace("\\", "/") + "?dest=S%C3%A3o%20Paulo&checkin=2026-09-21&checkout=2026-09-23&guests=4&maxPrice=125"
screenshot_path = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506\sao_paulo_live_app_screenshot.png"

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--disable-web-security",
    "--virtual-time-budget=8000",
    f"--screenshot={screenshot_path}",
    "--window-size=1280,1200",
    test_url
]

subprocess.run(cmd, capture_output=True, text=True)
if os.path.exists(screenshot_path):
    print(f"Capture live générée : {screenshot_path} ({os.path.getsize(screenshot_path)} octets)")
