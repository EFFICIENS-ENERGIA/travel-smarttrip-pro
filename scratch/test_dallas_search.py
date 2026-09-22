import urllib.request, json, sys, math

sys.stdout.reconfigure(encoding='utf-8')

def haversine_km(lat1, lon1, lat2, lon2):
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

# 1. Test photon for Dallas
url = 'https://photon.komoot.io/api/?q=hotel+Dallas&limit=16'
print(f"Interrogation Photon: {url}")
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
try:
    with urllib.request.urlopen(req, timeout=5) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        features = data.get('features', [])
        print(f"Total features: {len(features)}")
        for i, f in enumerate(features):
            p = f.get('properties', {})
            c = f.get('geometry', {}).get('coordinates', [])
            name = p.get('name')
            city = p.get('city')
            country = p.get('country')
            osm_val = p.get('osm_value')
            print(f"[{i+1}] Name: {name} | City: {city} | Country: {country} | osm: {osm_val} | coords: {c}")
except Exception as e:
    print(f"Photon Error: {e}")

# 2. Test city geocoding for Dallas center
url_geo = 'https://photon.komoot.io/api/?q=Dallas&limit=5'
print(f"\nInterrogation Geocoding Dallas: {url_geo}")
try:
    with urllib.request.urlopen(urllib.request.Request(url_geo, headers={'User-Agent': 'Mozilla/5.0'}), timeout=5) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        features = data.get('features', [])
        print(f"Total features geocoding: {len(features)}")
        for i, f in enumerate(features):
            p = f.get('properties', {})
            c = f.get('geometry', {}).get('coordinates', [])
            print(f"[{i+1}] Name: {p.get('name')} | Type: {p.get('type')} | State: {p.get('state')} | Country: {p.get('country')} | Coords: {c}")
except Exception as e:
    print(f"Geocoding Error: {e}")
