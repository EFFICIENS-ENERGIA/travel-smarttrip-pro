import unicodedata, re, sys
sys.stdout.reconfigure(encoding='utf-8')

def strip_accents(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn').lower().strip()

CITY_ALIASES = {
    'sevil': 'seville', 'seville': 'seville', 'séville': 'seville', 'sevilla': 'seville',
    'grenoble': 'grenoble', 'meylan': 'grenoble',
    'biarritz': 'biarritz',
    'tokyo': 'tokyo', 'tokio': 'tokyo',
    'rome': 'rome', 'roma': 'rome',
    'berlin': 'berlin',
    'paris': 'paris',
    'madrid': 'madrid',
    'fuengirola': 'fuengirola',
    'dunkerque': 'dunkerque', 'dunkirk': 'dunkerque',
    'lyon': 'lyon',
    'marseille': 'marseille',
    'bordeaux': 'bordeaux',
    'nice': 'nice',
    'barcelon': 'barcelone', 'barcelone': 'barcelone', 'barcelona': 'barcelone',
    'londres': 'londres', 'london': 'londres',
    'amsterdam': 'amsterdam',
    'bruxelles': 'bruxelles', 'brussels': 'bruxelles',
    'lisbonne': 'lisbonne', 'lisboa': 'lisbonne',
    'montreal': 'montreal', 'montréal': 'montreal'
}

# Mini check of hotel list
VERIFIED = {
    'seville': [
        {'name': "Hotel Alfonso XIII", 'basePrice': 480},
        {'name': "Hotel Las Casas de la Judería", 'basePrice': 130},
        {'name': "Hotel Fernando III", 'basePrice': 88},
        {'name': "Hotel Don Paco Sevilla", 'basePrice': 72},
        {'name': "Hostal Santa Catalina", 'basePrice': 38},
        {'name': "Oasis Backpackers Hostel Sevilla", 'basePrice': 28}
    ],
    'grenoble': [
        {'name': "Grand Hôtel Grenoble Centre", 'basePrice': 135},
        {'name': "Mercure Grenoble Alpha Meylan Hotel", 'basePrice': 98},
    ]
}

def get_verified_hotels_for_dest(dest):
    if not dest:
        return None
    raw = dest.lower().strip()
    stripped = strip_accents(dest)

    # 0. Protection contre les liens de fichiers locaux ou URL collés par inadvertance
    if raw.startswith('file:') or '.html' in raw or 'smarttrip' in raw or 'desktop' in raw:
        dest = 'Séville'
        raw = 'séville'
        stripped = 'seville'

    # 1. Si la recherche correspond EXACTEMENT ou presque à un nom de ville / alias connu
    for alias, city_key in CITY_ALIASES.items():
        if stripped == alias or raw == alias:
            hotels = VERIFIED.get(city_key)
            if hotels:
                return [dict(h) for h in hotels], city_key, False

    # 2. Recherche par nom d'établissement spécifique dans toutes les villes
    clean_query_words = [w for w in re.split(r'[^a-z0-9]+', stripped) if len(w) > 2 and w not in ('hotel', 'hostel', 'the', 'les', 'des', 'aux', 'del', 'centre')]
    
    best_match = None
    best_score = 0
    matched_city = None

    for city_key, hotel_list in VERIFIED.items():
        for h in hotel_list:
            h_name_stripped = strip_accents(h['name'])
            if stripped in h_name_stripped or (len(stripped) > 5 and h_name_stripped in stripped):
                score = 100
            else:
                score = 0
                for w in clean_query_words:
                    if w in h_name_stripped:
                        score += 20
            if score > best_score and score >= 20:
                best_score = score
                best_match = h
                matched_city = city_key

    if matched_city and best_match and best_score >= 20:
        city_hotels = VERIFIED[matched_city]
        reordered = [dict(best_match, isTargetHotel=True)]
        for h in city_hotels:
            if h['name'] != best_match['name']:
                reordered.append(dict(h))
        return reordered, matched_city, True

    # 3. Repli : si la recherche contient un nom de ville
    for alias, city_key in CITY_ALIASES.items():
        if alias in raw or alias in stripped:
            hotels = VERIFIED.get(city_key)
            if hotels:
                return [dict(h) for h in hotels], city_key, False

    return None, None, False

queries = [
    ("Hotel Alfonso XIII", 105),
    ("Alfonso XIII", 500),
    ("Séville", 105),
    ("Mercure Grenoble Alpha Meylan Hotel", 150),
    ("file:///C:/Users/EFFICIENS ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/dist_smarttrip_pro/index.html", 105)
]

for q, max_b in queries:
    res, city, is_target = get_verified_hotels_for_dest(q)
    print(f"\nRecherche: '{q[:35]}' (Max budget: {max_b} €)")
    print(f"  -> Ville détectée: {city}, is_target: {is_target}")
    if res:
        first = res[0]
        print(f"  -> 1er hôtel: {first['name']} (Prix: {first['basePrice']} €, isTarget: {first.get('isTargetHotel', False)})")
        # Simuler filtrage budget
        compliant = [h for h in res if h['basePrice'] <= max_b]
        over_budget = [h for h in res if h['basePrice'] > max_b]
        print(f"  -> Conformes ≤ {max_b} €: {len(compliant)} hôtels ({[h['name'] for h in compliant]})")
        print(f"  -> Hors budget > {max_b} €: {len(over_budget)} hôtels ({[h['name'] for h in over_budget]})")
        if is_target and first['basePrice'] > max_b:
            print(f"  -> 🎯 CAS SEB : Hôtel ciblé hors budget ! Affichage Encart Spécial + {len(compliant)} alternatives conformes.")
