import sys
import json
import urllib.request
import urllib.error

def check_url(url, timeout=5):
    req = urllib.request.Request(
        url,
        headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'}
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as response:
            status = getattr(response, 'status', getattr(response, 'code', 200))
            return status in (200, 202, 301, 302), status
    except urllib.error.HTTPError as e:
        # 403 et 429 correspondent aux challenges WAF sur bot sans session, mais sont des URLs valides
        if e.code in (403, 429):
            return True, e.code
        return False, e.code
    except Exception:
        return False, None

def filter_and_validate_rentals(input_path, output_path, user_max_budget):
    with open(input_path, 'r', encoding='utf-8-sig') as f:
        data = json.load(f)

    data['user_max_budget_eur'] = float(user_max_budget)
    valid_listings = []
    over_budget_suggestions = []

    for item in data.get('listings', []):
        raw_url = item.get('url')
        price = item.get('price_per_night_eur')

        # 1. Validation HTTP du lien
        if raw_url and raw_url.startswith('http'):
            is_valid_url, status_code = check_url(raw_url)
            item['is_url_verified'] = is_valid_url
            item['http_status'] = status_code
        else:
            item['is_url_verified'] = False
            item['http_status'] = 400

        # Rejeter immédiatement les liens cassés
        if not item['is_url_verified']:
            continue

        # 2. Filtrage déterministe du budget
        if price is not None:
            price = float(price)
            if price <= user_max_budget:
                item['is_over_budget_suggestion'] = False
                valid_listings.append(item)
            elif price <= user_max_budget * 1.05: # Tolérance max +5%
                item['is_over_budget_suggestion'] = True
                over_budget_suggestions.append(item)

    data['listings'] = valid_listings
    data['over_budget_suggestions'] = over_budget_suggestions
    data['total_valid_listings'] = len(valid_listings)

    if len(valid_listings) > 0:
        data['search_status'] = "SUCCESS"
    elif len(over_budget_suggestions) > 0:
        data['search_status'] = "PARTIAL_MATCH"
    else:
        data['search_status'] = "NO_MATCH_UNDER_BUDGET"

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print("Filtrage & validation achevés avec succès : %d logements valides, %d suggestions hors budget." % (len(valid_listings), len(over_budget_suggestions)))

if __name__ == "__main__":
    in_file = sys.argv[1] if len(sys.argv) > 1 else "scratch/raw_rentals.json"
    out_file = sys.argv[2] if len(sys.argv) > 2 else "production_artifacts/rentals_extracted.json"
    budget = float(sys.argv[3]) if len(sys.argv) > 3 else 150.0
    filter_and_validate_rentals(in_file, out_file, user_max_budget=budget)
