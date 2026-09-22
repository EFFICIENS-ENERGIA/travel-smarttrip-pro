import json, re

# Let's inspect getVerifiedHotelsForDest in travel_dashboard.html
with open('travel_dashboard.html', 'r', encoding='utf-8') as f:
    html = f.read()

# Let's test the hotel names in VERIFIED_REAL_WORLD_HOTELS
hotels_dict = {}
current_city = None

# Extract hotels from JS
match = re.search(r'const VERIFIED_REAL_WORLD_HOTELS = \{(.*?)\n    \};', html, re.DOTALL)
if match:
    block = match.group(1)
    print("Found VERIFIED_REAL_WORLD_HOTELS block length:", len(block))
    # Count occurrences of 'name:'
    names = re.findall(r'name:\s*["\']([^"\']+)["\']', block)
    print(f"Total verified hotels in code: {len(names)}")
    for n in names[:15]:
        print("  -", n)
