import urllib.request, urllib.parse, json, math, sys

sys.stdout.reconfigure(encoding='utf-8')

def haversine_km(lat1, lon1, lat2, lon2):
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def universal_hotel_finder(city_name):
    # 1. Geocode city dynamically
    geo_url = f'https://photon.komoot.io/api/?q={urllib.parse.quote(city_name)}&limit=3'
    req = urllib.request.Request(geo_url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req, timeout=5) as resp:
            geo_data = json.loads(resp.read().decode('utf-8'))
    except Exception as e:
        print(f"Geocoding error for {city_name}: {e}")
        return

    features = geo_data.get('features', [])
    if not features:
        print(f'City not found: {city_name}')
        return

    # Pick best feature (city / locality)
    city_feat = features[0]
    for f in features:
        t = f.get('properties', {}).get('type')
        if t in ['city', 'town', 'village', 'administrative']:
            city_feat = f
            break

    c = city_feat['geometry']['coordinates']
    c_lon, c_lat = c[0], c[1]
    p = city_feat.get('properties', {})
    name = p.get('name')
    state = p.get('state', '')
    country = p.get('country', '')
    print(f'=== DYNAMIC GEOCODING FOR: {city_name} ===')
    print(f'Found: {name}, {state} {country} at ({c_lat:.4f}, {c_lon:.4f})')

    # 2. Query hotels around this exact coordinate
    hotels_url = f'https://photon.komoot.io/api/?q=hotel&lat={c_lat}&lon={c_lon}&limit=25'
    req2 = urllib.request.Request(hotels_url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req2, timeout=5) as resp:
            hotel_data = json.loads(resp.read().decode('utf-8'))
    except Exception as e:
        print(f"Hotel fetch error for {city_name}: {e}")
        return

    h_features = hotel_data.get('features', [])
    print(f'Found {len(h_features)} raw places. Filtering physical hotels:')
    valid_hotels = 0
    bad_names = ['street', 'rue', 'avenue', 'boulevard', 'road', 'chemin']
    for hf in h_features:
        hp = hf.get('properties', {})
        hc = hf['geometry']['coordinates']
        h_lon, h_lat = hc[0], hc[1]
        dist = haversine_km(c_lat, c_lon, h_lat, h_lon)
        hname = hp.get('name')
        if not hname or dist > 15.0 or any(b in hname.lower() for b in bad_names):
            continue
        valid_hotels += 1
        street = hp.get('street', '')
        hcity = hp.get('city', '')
        print(f'  [{valid_hotels}] {hname} ({street}, {hcity}) : {dist:.2f} km')
    print(f'Total valid physical hotels within 15 km: {valid_hotels}\n')

for test_city in ['Dallas', 'Reykjavik', 'Kyoto', 'Buenos Aires']:
    universal_hotel_finder(test_city)
