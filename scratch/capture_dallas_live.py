import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

brain_dir = r"C:\Users\EFFICIENS ENERGIA\.gemini\antigravity\brain\f076e0be-08ee-48cc-9303-5a3edb1e0506"
out_png = os.path.join(brain_dir, "dallas_resolution_live_screenshot.png")

harness_html = """<!DOCTYPE html>
<html>
<body style="margin:0; background:#0f172a;">
  <iframe id="app" src="../dist_smarttrip_pro/index.html" style="width:1280px; height:2600px; border:none;"></iframe>
  <script>
    window.addEventListener('DOMContentLoaded', async () => {
      const frame = document.getElementById('app');
      let win = frame.contentWindow;
      let doc = win ? win.document : null;
      for (let i = 0; i < 50; i++) {
        if (win && doc && doc.getElementById('destInput') && typeof win.executeSearch === 'function') break;
        await new Promise(r => setTimeout(r, 100));
        win = frame.contentWindow;
        doc = win ? win.document : null;
      }
      doc.getElementById('destInput').value = 'Dallas';
      doc.getElementById('minPriceInput').value = '40';
      doc.getElementById('minPriceRange').value = '40';
      doc.getElementById('maxPriceInput').value = '180';
      doc.getElementById('maxPriceRange').value = '180';
      doc.getElementById('distInput').value = '5.0';
      doc.getElementById('distRange').value = '5.0';
      doc.getElementById('guestsInput').value = '2';
      win.updatePriceBadge();
      win.updateDistanceBadge();
      win.executeSearch();
    });
  </script>
</body>
</html>"""

with open("scratch/view_dallas_live.html", "w", encoding="utf-8") as f:
    f.write(harness_html)

harness_url = "file:///" + os.path.abspath("scratch/view_dallas_live.html").replace("\\", "/")

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--disable-web-security",
    "--virtual-time-budget=12000",
    f"--screenshot={out_png}",
    "--window-size=1280,2600",
    harness_url
]
subprocess.run(cmd, capture_output=True)
print(f"Dallas live screenshot exists: {os.path.exists(out_png)}")
