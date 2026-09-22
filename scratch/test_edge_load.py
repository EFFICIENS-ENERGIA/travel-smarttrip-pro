import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
if not os.path.exists(edge_path):
    edge_path = r'C:\Program Files\Microsoft\Edge\Application\msedge.exe'

target_url = 'file:///' + os.path.abspath('dist_smarttrip_pro/index.html').replace('\\', '/')
screenshot_path = os.path.abspath('scratch/dist_index_rendered.png')

print(f"Testing URL: {target_url}")
cmd = [
    edge_path,
    '--headless',
    '--disable-gpu',
    '--virtual-time-budget=6000',
    f'--screenshot={screenshot_path}',
    '--window-size=1280,1000',
    target_url
]

subprocess.run(cmd, capture_output=True)
print(f"Screenshot exists: {os.path.exists(screenshot_path)}")

# Also dump DOM
dom_cmd = [
    edge_path,
    '--headless',
    '--disable-gpu',
    '--virtual-time-budget=6000',
    '--dump-dom',
    target_url
]
res = subprocess.run(dom_cmd, capture_output=True, text=True, encoding='utf-8', errors='ignore')
dom = res.stdout

print("DOM length:", len(dom))
# Check if liveAccommodationsGrid has content
import re
grid_match = re.search(r'id=["\']liveAccommodationsGrid["\'][^>]*>(.*?)</div>\s*</div>', dom, re.DOTALL)
if grid_match:
    print("liveAccommodationsGrid content (first 500 chars):")
    print(grid_match.group(1)[:500])
else:
    print("liveAccommodationsGrid not matched or empty")

# Check liveAccommodationsCount
count_match = re.search(r'id=["\']liveAccommodationsCount["\'][^>]*>(.*?)</span>', dom)
if count_match:
    print("liveAccommodationsCount:", count_match.group(1))

# Check platforms count
plat_cards = len(re.findall(r'data-platform=', dom))
print("Platform cards count:", plat_cards)
