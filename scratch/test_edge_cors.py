import os, subprocess, sys

sys.stdout.reconfigure(encoding='utf-8')

edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if not os.path.exists(edge_path):
    edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

test_html = """<!DOCTYPE html>
<html>
<body>
<pre id="out">Testing...</pre>
<script>
async function test() {
  const el = document.getElementById('out');
  try {
    const res = await fetch('https://photon.komoot.io/api/?q=Dallas&limit=2');
    const data = await res.json();
    el.innerText = 'STATUS: ' + res.status + '\\n' + JSON.stringify(data.features[0].properties);
  } catch(e) {
    el.innerText = 'FETCH ERROR: ' + e.message;
  }
}
test();
</script>
</body>
</html>"""

with open("scratch/test_fetch_edge.html", "w", encoding="utf-8") as f:
    f.write(test_html)

out_png = os.path.abspath("scratch/test_fetch_edge.png")
url = "file:///" + os.path.abspath("scratch/test_fetch_edge.html").replace("\\", "/")

cmd = [
    edge_path,
    "--headless",
    "--disable-gpu",
    "--allow-file-access-from-files",
    "--disable-web-security",
    "--virtual-time-budget=6000",
    f"--screenshot={out_png}",
    url
]
subprocess.run(cmd, capture_output=True)
print(f"Screenshot exists: {os.path.exists(out_png)}")
