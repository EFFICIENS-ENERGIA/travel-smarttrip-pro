import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

test_file = os.path.abspath("dist_smarttrip_pro/index.html")
test_url = "file:///" + test_file.replace("\\", "/") + "?dest=Hotel+Alfonso+XIII&min=0&max=105"
screenshot_path = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506\dist_smarttrip_pro_alfonso_screenshot.png"

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--virtual-time-budget=8000",
    f"--screenshot={screenshot_path}",
    "--window-size=1280,1400",
    test_url
]

subprocess.run(cmd, capture_output=True)
print(f"Screenshot taken: {screenshot_path}, Exists: {os.path.exists(screenshot_path)}, Size: {os.path.getsize(screenshot_path)}")
