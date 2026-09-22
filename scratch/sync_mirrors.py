import shutil, os, hashlib, zipfile

project_dir = r"c:\Users\EFFICIENS ENERGIA\Desktop\ANTIGRAVITY\$HOMEagy2-projectsmy-first-project"
src = os.path.join(project_dir, "index.html")

targets = [
    os.path.join(project_dir, "travel_dashboard.html"),
    os.path.join(project_dir, "dist_smarttrip_pro", "travel_dashboard.html"),
    os.path.join(project_dir, "dist_smarttrip_pro", "index.html"),
]

for t in targets:
    shutil.copy2(src, t)
    print(f"Copied to: {t}")

# Check SHA-256 parity
files_all = [src] + targets
hashes = {}
for f in files_all:
    with open(f, "rb") as fp:
        h = hashlib.sha256(fp.read()).hexdigest()
        hashes[f] = h
        print(f"{os.path.basename(os.path.dirname(f))}/{os.path.basename(f)}: {h[:20]}...")

unique_hashes = set(hashes.values())
if len(unique_hashes) == 1:
    print("\nPARITÉ BINAIRE SHA-256 STRICTE CONFIRMÉE : 100% IDENTIQUES !")
else:
    print("\nERREUR : DIVERGENCE DÉTECTÉE !")

# Update SmartTrip_Pro_v2_Livrable.zip
zip_path = os.path.join(project_dir, "SmartTrip_Pro_v2_Livrable.zip")
dist_dir = os.path.join(project_dir, "dist_smarttrip_pro")

with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
    for root, dirs, files in os.walk(dist_dir):
        for file in files:
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, dist_dir)
            zf.write(full_path, arcname=rel_path)

print(f"Zip mis à jour avec succès : {zip_path} (Taille: {os.path.getsize(zip_path)} octets)")
