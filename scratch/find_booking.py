import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('travel_dashboard.html', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

for i, line in enumerate(lines, start=1):
    if 'booking.com' in line.lower():
        print(f'{i}: {line.strip()[:140]}')
