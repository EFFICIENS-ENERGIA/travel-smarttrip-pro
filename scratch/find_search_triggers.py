import sys, re
sys.stdout.reconfigure(encoding='utf-8')

with open('travel_dashboard.html', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if any(k in l.lower() for k in ['btn-search', 'handlesearch', 'onclick="search', 'onclick="fetch', 'lancer la recherche']):
        print(f"{i+1}: {l.strip()[:120]}")
