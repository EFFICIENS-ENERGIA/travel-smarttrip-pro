import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

test_file = os.path.abspath("scratch/debug_dallas.html")
test_url = "file:///" + test_file.replace("\\", "/")
screenshot_path = os.path.abspath("scratch/debug_dallas.png")

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--disable-web-security",
    "--virtual-time-budget=10000",
    f"--screenshot={screenshot_path}",
    "--window-size=1280,1000",
    test_url
]
subprocess.run(cmd, capture_output=True)
print(f"Debug screenshot exists: {os.path.exists(screenshot_path)}")
