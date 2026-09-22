import json, re

# Let's extract VERIFIED_REAL_WORLD_HOTELS and getVerifiedHotelsForDest from travel_dashboard.html
with open('travel_dashboard.html', 'r', encoding='utf-8') as f:
    code = f.read()

# Let's inspect getVerifiedHotelsForDest logic
test_queries = [
    "Rome",
    "Séville",
    "seville",
    "Hotel Alfonso XIII",
    "Alfonso XIII",
    "Mercure Grenoble Alpha Meylan Hotel",
    "Mercure Meylan",
    "Meylan",
    "Grenoble",
    "Biarritz",
    "Hôtel du Palais Biarritz",
    "Tokyo",
    "Park Hyatt Tokyo",
    "Dunkerque",
    "Radisson Blu Grand Hotel Malo-les-Bains",
    "Berlin",
    "Paris",
    "Madrid",
    "Fuengirola",
    "New York",
    "file:///C:/Users/EFFICIENS ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/dist_smarttrip_pro/index.html"
]

# Let's test the aliases logic in JS
aliases = {
    'sevil': 'seville', 'seville': 'seville', 'séville': 'seville', 'sevilla': 'seville',
    'grenoble': 'grenoble', 'meylan': 'grenoble',
    'biarritz': 'biarritz',
    'tokyo': 'tokyo', 'tokio': 'tokyo',
    'rome': 'rome', 'roma': 'rome',
    'berlin': 'berlin',
    'paris': 'paris',
    'madrid': 'madrid',
    'fuengirola': 'fuengirola',
    'dunkerque': 'dunkerque', 'dunkirk': 'dunkerque'
}

def strip_accents(s):
    import unicodedata
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn').lower().strip()

for q in test_queries:
    raw_norm = q.lower().strip()
    stripped_norm = strip_accents(q)
    matched = None
    for k, v in aliases.items():
        if k in raw_norm or k in stripped_norm:
            matched = v
            break
    print(f"Query: '{q[:40]}' -> Matched city: {matched}")
