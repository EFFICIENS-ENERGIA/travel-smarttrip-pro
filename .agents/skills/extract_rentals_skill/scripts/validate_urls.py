import os
import sys
import json
import urllib.request
import urllib.error

def check_url(url, timeout=4):
    """
    Vérification de l'accessibilité réseau de l'URL.
    - 200, 201, 202, 301, 302 -> Succès HTTP direct
    - 403, 429 -> Challenge WAF/Cloudflare (URL vivante pour navigateur réel)
    - 404, 410, 500, 502, 503, timeout -> URL invalide / cassée (False)
    """
    req = urllib.request.Request(
        url,
        headers={
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        }
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as response:
            status = getattr(response, 'status', getattr(response, 'code', 200))
            return status in (200, 201, 202, 301, 302), status
    except urllib.error.HTTPError as e:
        if e.code in (403, 429):
            # Challenge WAF anti-bot sur script sans session mais l'endpoint existe
            return True, e.code
        # 404 Not Found, 500 Server Error, etc.
        return False, e.code
    except Exception:
        # Timeout réseau, erreur de résolution DNS ou connexion refusée
        return False, None

def validate_rentals_urls(input_path, output_path):
    if not os.path.exists(input_path):
        print(f"Erreur : le fichier source {input_path} est introuvable.")
        sys.exit(1)

    with open(input_path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)

    listings = data.get('listings', [])
    print(f"[validate_urls.py] Validation HTTP de {len(listings)} annonces...")

    verified_listings = []
    for idx, item in enumerate(listings, 1):
        raw_url = item.get('url')
        if raw_url and raw_url.startswith('http'):
            is_valid, status_code = check_url(raw_url)
            item['is_url_verified'] = is_valid
            item['http_status'] = status_code
            status_label = f"HTTP {status_code}" if status_code else "TIMEOUT/ERR"
            print(f"  [{idx}/{len(listings)}] {status_label} (Valide: {is_valid}) -> {raw_url[:70]}")
        else:
            item['is_url_verified'] = False
            item['http_status'] = 400
            print(f"  [{idx}/{len(listings)}] INVALID_URL -> {raw_url}")

        if item['is_url_verified']:
            verified_listings.append(item)

    data['listings'] = verified_listings
    data['total_valid_listings'] = len(verified_listings)

    out_dir = os.path.dirname(os.path.abspath(output_path))
    if out_dir and not os.path.exists(out_dir):
        os.makedirs(out_dir, exist_ok=True)

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"[OK] Fichier certifié écrit avec succès : {output_path}")

if __name__ == "__main__":
    input_file = sys.argv[1] if len(sys.argv) > 1 else "scratch/raw_rentals.json"
    output_file = sys.argv[2] if len(sys.argv) > 2 else "production_artifacts/rentals_extracted.json"
    validate_rentals_urls(input_file, output_file)
