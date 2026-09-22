import unicodedata, re

def normalizeSearchText(str_val):
    if not str_val:
        return ""
    nfd = unicodedata.normalize("NFD", str(str_val))
    no_acc = "".join(c for c in nfd if unicodedata.category(c) != "Mn")
    cleaned = re.sub(r"[^\w\s-]", " ", no_acc)
    return re.sub(r"\s+", " ", cleaned).strip()

print("n1:", repr(normalizeSearchText("São Paulo / Jardins")))
print("n2:", repr(normalizeSearchText("Málaga, Andalucía")))
print("n3:", repr(normalizeSearchText("Séville - Triana")))
print("n4:", repr(normalizeSearchText("Dallas / Fort Worth, TX")))
print("n5:", repr(normalizeSearchText("Côte d'Azur")))
print("n6:", repr(normalizeSearchText("Zürich (Centre)")))
