import sys, re
sys.stdout.reconfigure(encoding='utf-8')

with open('travel_dashboard.html', 'r', encoding='utf-8') as f:
    text = f.read()

pattern = r'<input[^>]*id=["\'](destInput|minPriceInput|maxPriceInput|distInput|checkInInput|checkOutInput|guestsInput)["\'][^>]*>'
for m in re.finditer(pattern, text):
    print(m.group(0))

pattern2 = r'<select[^>]*id=["\'](destInput|minPriceInput|maxPriceInput|distInput|checkInInput|checkOutInput|guestsInput)["\'][^>]*>.*?</select>'
for m in re.finditer(pattern2, text, re.DOTALL):
    print(m.group(0)[:120])
