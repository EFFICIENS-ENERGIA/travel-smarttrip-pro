import sys, re

sys.stdout.reconfigure(encoding='utf-8')

with open('travel_dashboard.html', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Mise à jour de Rome dans VERIFIED_REAL_WORLD_HOTELS
old_rome_pattern = re.compile(r'rome:\s*\[.*?\]\s*,', re.DOTALL)
new_rome_code = '''rome: [
        { name: "The Rome EDITION", street: "Salita di San Nicola da Tolentino 14", lat: 41.9042, lon: 12.4907, stars: "Hôtel 5★ Luxe", basePrice: 580, rating: 9.6, reviews: 620, perks: ["Piscine Rooftop", "Jardin urbain", "Climatisation"] },
        { name: "Singer Palace Hotel", street: "Via Alessandro Specchi 10", lat: 41.8988, lon: 12.4812, stars: "Hôtel 5★", basePrice: 520, rating: 9.5, reviews: 850, perks: ["Fontaine de Trevi", "Rooftop vue panoramique", "Climatisation"] },
        { name: "Hotel Artemide", street: "Via Nazionale 22", lat: 41.9010, lon: 12.4925, stars: "Hôtel 4★ Sup", basePrice: 135, rating: 9.4, reviews: 3400, perks: ["Rooftop Restaurant", "Spa & Wellness", "Climatisation"] },
        { name: "Hotel Quirinale", street: "Via Nazionale 7", lat: 41.9015, lon: 12.4938, stars: "Hôtel 4★", basePrice: 125, rating: 9.1, reviews: 2900, perks: ["Opéra de Rome", "Jardin privé", "Petit-déjeuner inclus"] },
        { name: "Relais Fontana di Trevi", street: "Via del Lavatore 44", lat: 41.9009, lon: 12.4841, stars: "Hôtel 4★", basePrice: 110, rating: 9.2, reviews: 1450, perks: ["Vue Trevi", "Petit-déjeuner inclus", "Climatisation"] },
        { name: "Hotel Diocleziano", street: "Via Gaeta 71", lat: 41.9035, lon: 12.4990, stars: "Hôtel 4★", basePrice: 88, rating: 9.2, reviews: 1800, perks: ["Gare Termini", "Sauna & Gym", "Climatisation"] },
        { name: "Hotel Des Artistes Rome", street: "Via Villafranca 20", lat: 41.9055, lon: 12.5010, stars: "Hôtel 3★", basePrice: 58, rating: 9.0, reviews: 1450, perks: ["Terrasse fleurie", "WiFi rapide", "Climatisation"] },
        { name: "Ostello Bello Roma Colosseo", street: "Via Angelo Poliziano 75", lat: 41.8905, lon: 12.5015, stars: "Auberge Design", basePrice: 42, rating: 9.4, reviews: 2100, perks: ["Proche Colisée", "Jardin & Bar", "Climatisation"] },
        { name: "The RomeHello Hostel", street: "Via Torino 45", lat: 41.9018, lon: 12.4948, stars: "Auberge Design", basePrice: 36, rating: 9.3, reviews: 2700, perks: ["Centre-ville", "Street Art", "Climatisation"] },
        { name: "Generator Rome", street: "Via San Martino della Battaglia 6", lat: 41.8965, lon: 12.5020, stars: "Auberge Moderne", basePrice: 35, rating: 9.1, reviews: 3100, perks: ["Rooftop Bar", "Piazza Vittorio", "Climatisation"] },
        { name: "YellowSquare Rome", street: "Via Palestro 40", lat: 41.9045, lon: 12.5025, stars: "Auberge Festive & Coworking", basePrice: 32, rating: 9.2, reviews: 3600, perks: ["Espace Coworking", "Bar Lounge", "Climatisation"] }
      ],'''

assert old_rome_pattern.search(content), "old_rome_pattern introuvable"
content = old_rome_pattern.sub(lambda m: new_rome_code, content, count=1)

# 2. Mise à jour de Barcelone dans VERIFIED_REAL_WORLD_HOTELS
old_barc_pattern = re.compile(r'barcelone:\s*\[.*?\]\s*,', re.DOTALL)
new_barc_code = '''barcelone: [
        { name: "W Barcelona", street: "Plaça Rosa Del Vents 1", lat: 41.3685, lon: 2.1905, stars: "Hôtel 5★ Luxe", basePrice: 380, rating: 9.5, reviews: 4200, perks: ["Front de mer", "Piscine Infinity", "Rooftop Eclipse"] },
        { name: "Hotel Colón Barcelona", street: "Avinguda de la Catedral 7", lat: 41.3845, lon: 2.1760, stars: "Hôtel 4★ Sup", basePrice: 140, rating: 9.3, reviews: 2800, perks: ["Face à la Cathédrale", "Piscine Rooftop", "Bar panoramique"] },
        { name: "Hotel Jazz Barcelona", street: "Carrer de Pelai 3", lat: 41.3855, lon: 2.1675, stars: "Hôtel 3★ Sup", basePrice: 95, rating: 9.2, reviews: 3100, perks: ["Plaça Catalunya", "Piscine sur le toit", "Climatisation"] },
        { name: "Hostal Nouvel Barcelona", street: "Carrer de Santa Anna 20", lat: 41.3858, lon: 2.1712, stars: "Hôtel 3★ Historique", basePrice: 75, rating: 9.1, reviews: 1850, perks: ["Plein centre", "Architecture 1900", "Climatisation"] },
        { name: "Hotel Peninsular Barcelona", street: "Carrer de Sant Pau 34", lat: 41.3795, lon: 2.1725, stars: "Hôtel 2★ Charme", basePrice: 68, rating: 9.0, reviews: 2200, perks: ["Patio végétalisé", "Ramblas", "Petit-déjeuner inclus"] },
        { name: "TOC Hostel Barcelona", street: "Gran Via de les Corts Catalanes 580", lat: 41.3850, lon: 2.1620, stars: "Design Hostel", basePrice: 45, rating: 9.2, reviews: 3400, perks: ["Piscine extérieure", "Plaça Universitat", "Climatisation"] },
        { name: "Generator Barcelona", street: "Carrer de Còrsega 373", lat: 41.3995, lon: 2.1605, stars: "Auberge Design", basePrice: 38, rating: 9.1, reviews: 3800, perks: ["Gràcia", "Bar festif", "Climatisation"] },
        { name: "Sant Jordi Hostels Sagrada Familia", street: "Carrer del Freser 5", lat: 41.4110, lon: 2.1810, stars: "Auberge Moderne", basePrice: 35, rating: 9.3, reviews: 2600, perks: ["Sagrada Familia", "Terrasse Skate", "Climatisation"] },
        { name: "Yeah Hostel Barcelona", street: "Carrer de Girona 176", lat: 41.4005, lon: 2.1665, stars: "Auberge Design", basePrice: 34, rating: 9.3, reviews: 3500, perks: ["Eixample / Gràcia", "Piscine Rooftop", "Dîners conviviaux"] },
        { name: "Kabul Party Hostel Barcelona", street: "Plaça Reial 17", lat: 41.3790, lon: 2.1755, stars: "Auberge Jeunesse", basePrice: 32, rating: 9.0, reviews: 4100, perks: ["Plaça Reial", "Ramblas", "Ambiance légendaire"] }
      ],'''

assert old_barc_pattern.search(content), "old_barc_pattern introuvable"
content = old_barc_pattern.sub(lambda m: new_barc_code, content, count=1)

# 3. Ajout de Miami dans VERIFIED_REAL_WORLD_HOTELS (après montreal)
old_montreal_end = '''        { name: "M Montreal Hostel", street: "1245 Rue Saint-André", lat: 45.5175, lon: -73.5570, stars: "Auberge Réputée", basePrice: 38, rating: 9.3, reviews: 3100, perks: ["Village / Quartier Latin", "Spas sur le toit", "Bar comédie"] }
      ]
    };'''

new_montreal_and_miami = '''        { name: "M Montreal Hostel", street: "1245 Rue Saint-André", lat: 45.5175, lon: -73.5570, stars: "Auberge Réputée", basePrice: 38, rating: 9.3, reviews: 3100, perks: ["Village / Quartier Latin", "Spas sur le toit", "Bar comédie"] }
      ],
      miami: [
        { name: "The Betsy Hotel South Beach", street: "1440 Ocean Dr, Miami Beach", lat: 25.7870, lon: -80.1305, stars: "Hôtel 5★ Palace", basePrice: 390, rating: 9.6, reviews: 1800, perks: ["Ocean Drive", "Piscine Rooftop", "Cour intérieure"] },
        { name: "citizenM Miami Brickell", street: "955 S Miami Ave", lat: 25.7645, lon: -80.1930, stars: "Hôtel 4★ Design", basePrice: 145, rating: 9.3, reviews: 2400, perks: ["Brickell", "Rooftop & Piscine", "Climatisation"] },
        { name: "Roami at Habitat Brickell", street: "170 SW 7th St", lat: 25.7660, lon: -80.1965, stars: "Appart-Hôtel 4★", basePrice: 110, rating: 9.2, reviews: 1650, perks: ["Brickell", "Kitchenette complète", "Idéal 5 voyageurs", "Piscine"] },
        { name: "YVE Hotel Miami", street: "146 Biscayne Blvd", lat: 25.7760, lon: -80.1880, stars: "Hôtel 4★", basePrice: 105, rating: 9.1, reviews: 3200, perks: ["Face à Bayside", "Port de Miami", "Vue Baie Biscayne"] },
        { name: "Comfort Inn & Suites Downtown Brickell", street: "100 SE 4th St", lat: 25.7705, lon: -80.1915, stars: "Hôtel 3★ Sup", basePrice: 98, rating: 9.0, reviews: 2900, perks: ["Bord de rivière Miami", "Piscine extérieure", "Petit-déjeuner inclus"] },
        { name: "Selina Miami River", street: "437 SW 2nd St", lat: 25.7710, lon: -80.2010, stars: "Boutique Hôtel", basePrice: 78, rating: 9.1, reviews: 1400, perks: ["Bungalows historiques", "Piscine jardin", "Climatisation"] },
        { name: "Freehand Miami", street: "2727 Indian Creek Dr, Miami Beach", lat: 25.8035, lon: -80.1265, stars: "Auberge Design & Suites", basePrice: 55, rating: 9.0, reviews: 3600, perks: ["Broken Shaker Bar", "Piscine extérieure", "Ambiance tropicale"] },
        { name: "Generator Miami", street: "3120 Collins Ave, Miami Beach", lat: 25.8070, lon: -80.1255, stars: "Auberge Confort", basePrice: 48, rating: 9.1, reviews: 2800, perks: ["Collins Ave", "Piscine extérieure", "Plage à 100m"] }
      ]
    };'''

assert old_montreal_end in content, "old_montreal_end introuvable"
content = content.replace(old_montreal_end, new_montreal_and_miami, 1)

# 4. Ajout de miami dans aliases et cityDisplayNameMap
old_aliases = "'montreal': 'montreal', 'montréal': 'montreal'"
new_aliases = "'montreal': 'montreal', 'montréal': 'montreal',\n        'miami': 'miami'"
content = content.replace(old_aliases, new_aliases, 1)

old_display = "'lisbonne': 'Lisbonne', 'montreal': 'Montréal'"
new_display = "'lisbonne': 'Lisbonne', 'montreal': 'Montréal', 'miami': 'Miami'"
content = content.replace(old_display, new_display, 1)

# 5. Injection de CITY_CENTERS pour un calcul géodésique de haute précision
old_center_calc = '''      const centerCoords = (realHotels[0]?.lat && realHotels[0]?.lon)
        ? { lat: realHotels[0].lat, lon: realHotels[0].lon }
        : { lat: 36.5398, lon: -4.6247 };'''

new_center_calc = '''      const CITY_CENTERS = {
        rome: { lat: 41.8988, lon: 12.4812 },
        barcelone: { lat: 41.3870, lon: 2.1700 },
        miami: { lat: 25.7743, lon: -80.1937 },
        seville: { lat: 37.3890, lon: -5.9950 },
        grenoble: { lat: 45.1885, lon: 5.7245 },
        biarritz: { lat: 43.4832, lon: -1.5586 },
        tokyo: { lat: 35.6895, lon: 139.6917 },
        dunkerque: { lat: 51.0343, lon: 2.3768 },
        berlin: { lat: 52.5200, lon: 13.4050 },
        paris: { lat: 48.8566, lon: 2.3522 },
        madrid: { lat: 40.4168, lon: -3.7038 },
        fuengirola: { lat: 36.5398, lon: -4.6247 },
        lyon: { lat: 45.7640, lon: 4.8357 },
        marseille: { lat: 43.2965, lon: 5.3698 },
        bordeaux: { lat: 44.8378, lon: -0.5792 },
        nice: { lat: 43.7102, lon: 7.2620 },
        londres: { lat: 51.5074, lon: -0.1278 },
        amsterdam: { lat: 52.3676, lon: 4.9041 },
        bruxelles: { lat: 50.8466, lon: 4.3528 },
        lisbonne: { lat: 38.7223, lon: -9.1393 },
        montreal: { lat: 45.5017, lon: -73.5673 }
      };

      const cityKeyLower = stripAccents(cleanDest);
      let officialCenter = null;
      for (const [k, coords] of Object.entries(CITY_CENTERS)) {
        if (cityKeyLower === k || cityKeyLower.includes(k) || (realHotels[0]?.city && stripAccents(realHotels[0].city).includes(k))) {
          officialCenter = coords;
          break;
        }
      }

      const centerCoords = officialCenter || (realHotels[0]?.lat && realHotels[0]?.lon
        ? { lat: realHotels[0].lat, lon: realHotels[0].lon }
        : { lat: 36.5398, lon: -4.6247 });'''

assert old_center_calc in content, "old_center_calc introuvable"
content = content.replace(old_center_calc, new_center_calc, 1)

with open('travel_dashboard.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("travel_dashboard.html mis à jour avec Rome enrichie, Barcelone enrichie, Miami et CITY_CENTERS !")
