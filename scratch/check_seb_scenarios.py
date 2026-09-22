import math

def haversine(lat1, lon1, lat2, lon2):
    R = 6371
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    return R * c

# Rome
rome_center = (41.8988, 12.4812) # Trevi / Piazza Venezia
rome_hotels = [
    {"name": "The Rome EDITION", "lat": 41.9042, "lon": 12.4907, "price": 580},
    {"name": "Singer Palace Hotel", "lat": 41.8988, "lon": 12.4812, "price": 520},
    {"name": "Hotel Artemide", "lat": 41.9010, "lon": 12.4925, "price": 135},
    {"name": "Hotel Quirinale", "lat": 41.9015, "lon": 12.4938, "price": 125},
    {"name": "Relais Fontana di Trevi", "lat": 41.9009, "lon": 12.4841, "price": 110},
    {"name": "Hotel Diocleziano", "lat": 41.9035, "lon": 12.4990, "price": 88},
    {"name": "The RomeHello Hostel", "lat": 41.9018, "lon": 12.4948, "price": 36},
    {"name": "YellowSquare Rome", "lat": 41.9045, "lon": 12.5025, "price": 32},
    {"name": "Generator Rome", "lat": 41.8965, "lon": 12.5020, "price": 35},
    {"name": "Ostello Bello Roma Colosseo", "lat": 41.8905, "lon": 12.5015, "price": 42},
    {"name": "Hotel Des Artistes Rome", "lat": 41.9055, "lon": 12.5010, "price": 58},
]

print("=== SCENARIO 1 : ROME (max 60 €, max 4.0 km, 3 pers.) ===")
for h in rome_hotels:
    d = haversine(rome_center[0], rome_center[1], h['lat'], h['lon'])
    ok_price = h['price'] <= 60
    ok_dist = d <= 4.0
    print(f"{h['name']}: {h['price']} € | {d:.2f} km | Conforme: {ok_price and ok_dist} (Prix: {ok_price}, Dist: {ok_dist})")

# Barcelone
barc_center = (41.3870, 2.1700) # Plaça Catalunya
barc_hotels = [
    {"name": "W Barcelona", "lat": 41.3685, "lon": 2.1905, "price": 380},
    {"name": "Hotel Colón Barcelona", "lat": 41.3845, "lon": 2.1760, "price": 140},
    {"name": "Hotel Jazz Barcelona", "lat": 41.3855, "lon": 2.1675, "price": 95},
    {"name": "Hostal Nouvel Barcelona", "lat": 41.3858, "lon": 2.1712, "price": 75},
    {"name": "Hotel Peninsular Barcelona", "lat": 41.3795, "lon": 2.1725, "price": 68},
    {"name": "TOC Hostel Barcelona", "lat": 41.3850, "lon": 2.1620, "price": 45},
    {"name": "Generator Barcelona", "lat": 41.3995, "lon": 2.1605, "price": 38},
    {"name": "Sant Jordi Hostels Sagrada Familia", "lat": 41.4110, "lon": 2.1810, "price": 35},
    {"name": "Yeah Hostel Barcelona", "lat": 41.4005, "lon": 2.1665, "price": 34},
    {"name": "Kabul Party Hostel Barcelona", "lat": 41.3790, "lon": 2.1755, "price": 32}
]

print("\n=== SCENARIO 2 : BARCELONE (max 80 €, max 3.0 km, 2 pers.) ===")
for h in barc_hotels:
    d = haversine(barc_center[0], barc_center[1], h['lat'], h['lon'])
    ok_price = h['price'] <= 80
    ok_dist = d <= 3.0
    print(f"{h['name']}: {h['price']} € | {d:.2f} km | Conforme: {ok_price and ok_dist} (Prix: {ok_price}, Dist: {ok_dist})")

# Miami
miami_center = (25.7743, -80.1937) # Downtown Miami
miami_hotels = [
    {"name": "The Betsy Hotel South Beach", "lat": 25.7870, "lon": -80.1305, "price": 390},
    {"name": "citizenM Miami Brickell", "lat": 25.7645, "lon": -80.1930, "price": 145},
    {"name": "Roami at Habitat Brickell", "lat": 25.7660, "lon": -80.1965, "price": 110},
    {"name": "YVE Hotel Miami", "lat": 25.7760, "lon": -80.1880, "price": 105},
    {"name": "Comfort Inn & Suites Downtown Brickell", "lat": 25.7705, "lon": -80.1915, "price": 98},
    {"name": "Selina Miami River", "lat": 25.7710, "lon": -80.2010, "price": 78},
    {"name": "Freehand Miami", "lat": 25.8035, "lon": -80.1265, "price": 55},
    {"name": "Generator Miami", "lat": 25.8070, "lon": -80.1255, "price": 48}
]

print("\n=== SCENARIO 3 : MIAMI (max 110 €, max 3.0 km, 5 pers.) ===")
for h in miami_hotels:
    d = haversine(miami_center[0], miami_center[1], h['lat'], h['lon'])
    ok_price = h['price'] <= 110
    ok_dist = d <= 3.0
    print(f"{h['name']}: {h['price']} € | {d:.2f} km | Conforme: {ok_price and ok_dist} (Prix: {ok_price}, Dist: {ok_dist})")
