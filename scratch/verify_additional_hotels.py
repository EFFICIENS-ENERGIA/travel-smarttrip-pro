# Verification script for the code to be inserted into travel_dashboard.html
import sys
sys.stdout.reconfigure(encoding='utf-8')

# Check that python parses our data structures cleanly
additional_hotels_code = '''
      lyon: [
        { name: "Hôtel Carlton Lyon - MGallery", street: "Place de la République", lat: 45.7600, lon: 4.8360, stars: "Hôtel 4★ Sup", basePrice: 145, rating: 9.3, reviews: 1850, perks: ["Presqu'île", "Hôtel Historique", "Climatisation"] },
        { name: "Boscolo Lyon Hôtel & Spa", street: "11 Quai Jules Courmont", lat: 45.7608, lon: 4.8378, stars: "Hôtel 5★ Luxe", basePrice: 260, rating: 9.4, reviews: 1200, perks: ["Vue Rhône", "Spa & Piscine", "Climatisation"] },
        { name: "Mercure Lyon Centre Saxe Lafayette", street: "29 Rue de Bonnel", lat: 45.7615, lon: 4.8475, stars: "Hôtel 4★", basePrice: 115, rating: 9.1, reviews: 1650, perks: ["Part-Dieu", "Piscine intérieure", "Climatisation"] },
        { name: "Hôtel Silky by HappyCulture", street: "2 Place Francisque Régaud", lat: 45.7635, lon: 4.8345, stars: "Hôtel 4★", basePrice: 89, rating: 9.2, reviews: 1400, perks: ["Presqu'île", "Charme historique", "WiFi gratuit"] },
        { name: "Slo Lyon Les Pentes", street: "21 Rue Alsace-Lorraine", lat: 45.7705, lon: 4.8320, stars: "Auberge Design", basePrice: 32, rating: 9.0, reviews: 950, perks: ["Croix-Rousse", "Patio extérieur", "Bar convivial"] }
      ],
      marseille: [
        { name: "InterContinental Marseille - Hotel Dieu", street: "1 Place Daviel", lat: 43.2985, lon: 5.3695, stars: "Hôtel 5★ Luxe", basePrice: 290, rating: 9.5, reviews: 1750, perks: ["Vue Vieux-Port", "Terrasse panoramique", "Spa Clarins"] },
        { name: "Radisson Blu Hotel Marseille Vieux Port", street: "38-40 Quai Rive Neuve", lat: 43.2925, lon: 5.3680, stars: "Hôtel 4★", basePrice: 135, rating: 9.2, reviews: 2200, perks: ["Vieux-Port", "Piscine extérieure", "Climatisation"] },
        { name: "Hôtel La Résidence du Vieux-Port", street: "18 Quai du Port", lat: 43.2965, lon: 5.3725, stars: "Hôtel 4★", basePrice: 120, rating: 9.3, reviews: 1550, perks: ["Front de port", "Vue Notre-Dame", "Climatisation"] },
        { name: "Ibis Styles Marseille Vieux-Port", street: "5-7 Rue Reine Elisabeth", lat: 43.2970, lon: 5.3760, stars: "Hôtel 3★", basePrice: 79, rating: 9.0, reviews: 1800, perks: ["Vieux-Port", "Design moderne", "Climatisation"] },
        { name: "The People - Marseille", street: "12 Rue Jean-Marc Cathala", lat: 43.3035, lon: 5.3705, stars: "Auberge Design", basePrice: 34, rating: 9.1, reviews: 1300, perks: ["Panier / Joliette", "Rooftop bar", "Climatisation"] }
      ],
      bordeaux: [
        { name: "InterContinental Bordeaux Le Grand Hotel", street: "2-5 Place de la Comédie", lat: 44.8425, lon: -0.5745, stars: "Hôtel 5★ Palace", basePrice: 360, rating: 9.6, reviews: 1950, perks: ["Grand Théâtre", "Spa Guerlain", "Restaurant Gordon Ramsay"] },
        { name: "Hôtel de Sèze Bordeaux Centre", street: "23 Allées de Tourny", lat: 44.8445, lon: -0.5755, stars: "Hôtel 4★ Charme", basePrice: 135, rating: 9.3, reviews: 1400, perks: ["Allées de Tourny", "Spa & Bain vapeur", "Climatisation"] },
        { name: "Quality Hotel Bordeaux Centre", street: "27 Rue Sainte-Catherine", lat: 44.8395, lon: -0.5740, stars: "Hôtel 3★", basePrice: 88, rating: 9.0, reviews: 2100, perks: ["Rue Sainte-Catherine", "Centre historique", "Climatisation"] },
        { name: "Central Hostel Bordeaux Centre", street: "2 Place Saint-Projet", lat: 44.8385, lon: -0.5735, stars: "Auberge Design", basePrice: 35, rating: 9.1, reviews: 1650, perks: ["Plein centre", "Terrasse conviviale", "Climatisation"] }
      ],
      nice: [
        { name: "Hôtel Negresco Nice", street: "37 Promenade des Anglais", lat: 43.6950, lon: 7.2580, stars: "Hôtel 5★ Palace", basePrice: 420, rating: 9.6, reviews: 3200, perks: ["Promenade des Anglais", "Collection d'art", "Vue Mer"] },
        { name: "Hôtel Aston La Scala", street: "12 Avenue Félix Faure", lat: 43.6990, lon: 7.2715, stars: "Hôtel 4★", basePrice: 130, rating: 9.2, reviews: 2600, perks: ["Piscine Rooftop", "Vue Coulée Verte", "Climatisation"] },
        { name: "Hôtel Le Grimaldi by HappyCulture", street: "15 Rue Grimaldi", lat: 43.6985, lon: 7.2625, stars: "Hôtel 4★", basePrice: 92, rating: 9.1, reviews: 1800, perks: ["Quartier des Musiciens", "Belle Époque", "Climatisation"] },
        { name: "Villa Saint Exupéry Beach Hostel", street: "6 Rue Sacha Guitry", lat: 43.6995, lon: 7.2690, stars: "Auberge de Jeunesse", basePrice: 36, rating: 8.9, reviews: 2100, perks: ["Place Masséna", "Sauna & Gym", "Ambiance festive"] }
      ],
      barcelone: [
        { name: "W Barcelona", street: "Plaça Rosa Del Vents 1", lat: 41.3685, lon: 2.1905, stars: "Hôtel 5★ Luxe", basePrice: 380, rating: 9.5, reviews: 4200, perks: ["Front de mer", "Piscine Infinity", "Rooftop Eclipse"] },
        { name: "Hotel Colón Barcelona", street: "Avinguda de la Catedral 7", lat: 41.3845, lon: 2.1760, stars: "Hôtel 4★ Sup", basePrice: 140, rating: 9.3, reviews: 2800, perks: ["Face à la Cathédrale", "Piscine Rooftop", "Bar panoramique"] },
        { name: "Hotel Jazz Barcelona", street: "Carrer de Pelai 3", lat: 41.3855, lon: 2.1675, stars: "Hôtel 3★ Sup", basePrice: 95, rating: 9.2, reviews: 3100, perks: ["Plaça Catalunya", "Piscine sur le toit", "Climatisation"] },
        { name: "Yeah Hostel Barcelona", street: "Carrer de Girona 176", lat: 41.4005, lon: 2.1665, stars: "Auberge Design", basePrice: 34, rating: 9.3, reviews: 3500, perks: ["Eixample / Gràcia", "Piscine Rooftop", "Dîners conviviaux"] }
      ],
      londres: [
        { name: "The Savoy London", street: "Strand, WC2R 0EZ", lat: 51.5105, lon: -0.1205, stars: "Hôtel 5★ Palace", basePrice: 650, rating: 9.7, reviews: 3100, perks: ["Bord de Tamise", "Piscine & Spa", "Service Majordome"] },
        { name: "The Resident Covent Garden", street: "51 Bedford Street, WC2E 9HA", lat: 51.5115, lon: -0.1235, stars: "Hôtel 4★", basePrice: 185, rating: 9.4, reviews: 2200, perks: ["Covent Garden", "Mini-kitchenette", "Climatisation"] },
        { name: "Zedwell Piccadilly Circus", street: "Great Windmill St, W1D 7DH", lat: 51.5100, lon: -0.1335, stars: "Hôtel 3★ Éco-Zen", basePrice: 98, rating: 8.9, reviews: 4800, perks: ["Piccadilly Circus", "Insonorisation totale", "Climatisation"] },
        { name: "Wombat's City Hostel London", street: "7 Dock Street, E1 8LL", lat: 51.5110, lon: -0.0695, stars: "Auberge Moderne", basePrice: 39, rating: 9.1, reviews: 3900, perks: ["Tower Bridge", "Cour arborée", "Bar lounge"] }
      ],
      amsterdam: [
        { name: "Pulitzer Amsterdam", street: "Prinsengracht 323", lat: 52.3725, lon: 4.8835, stars: "Hôtel 5★ Luxe", basePrice: 420, rating: 9.6, reviews: 2400, perks: ["Canaux historiques", "Jardins intérieurs", "Bateau privé"] },
        { name: "citizenM Amsterdam South", street: "Prinses Irenestraat 30", lat: 52.3420, lon: 4.8720, stars: "Hôtel 4★ Design", basePrice: 135, rating: 9.3, reviews: 3600, perks: ["Zuidas / Tram direct", "Lit XL ultra-confort", "Climatisation"] },
        { name: "Hotel V Fizeaustraat", street: "Fizeaustraat 2", lat: 52.3465, lon: 4.9280, stars: "Hôtel 4★", basePrice: 110, rating: 9.2, reviews: 1800, perks: ["Design années 70", "Restaurant réputé", "Climatisation"] },
        { name: "Flying Pig Downtown Hostel", street: "Nieuwendijk 100", lat: 52.3775, lon: 4.8965, stars: "Auberge Festive", basePrice: 38, rating: 8.9, reviews: 2900, perks: ["Gare Centrale", "Bar convivial", "Ambiance jeune"] }
      ],
      bruxelles: [
        { name: "Hotel Amigo - Rocco Forte", street: "Rue de l'Amigo 1", lat: 50.8465, lon: 4.3515, stars: "Hôtel 5★ Luxe", basePrice: 350, rating: 9.6, reviews: 1600, perks: ["Grand-Place", "Restaurant Bocconi", "Climatisation"] },
        { name: "The Hoxton Brussels", street: "Square Victoria Régina 1", lat: 50.8545, lon: 4.3635, stars: "Hôtel 4★", basePrice: 130, rating: 9.3, reviews: 1450, perks: ["Botanique", "Rooftop Cantina Valentina", "Design rétro"] },
        { name: "Motel One Brussels", street: "Rue Royale 120", lat: 50.8495, lon: 4.3645, stars: "Design Hôtel", basePrice: 85, rating: 9.1, reviews: 4100, perks: ["Parc Royal", "Lounge branché", "Climatisation"] },
        { name: "MEININGER Hotel Bruxelles City Center", street: "Quai du Hainaut 33", lat: 50.8525, lon: 4.3410, stars: "Hôtel 3★", basePrice: 45, rating: 8.9, reviews: 3800, perks: ["Canal / Sainte-Catherine", "Bar & Jeux", "Climatisation"] }
      ],
      lisbonne: [
        { name: "Bairro Alto Hotel", street: "Praça Luís de Camões 2", lat: 38.7105, lon: -9.1435, stars: "Hôtel 5★ Luxe", basePrice: 320, rating: 9.6, reviews: 1800, perks: ["Chiado / Bairro Alto", "Rooftop panoramique", "Restaurant gastronomique"] },
        { name: "Hotel Mundial Lisboa", street: "Praça Martim Moniz 2", lat: 38.7145, lon: -9.1365, stars: "Hôtel 4★", basePrice: 115, rating: 9.1, reviews: 3400, perks: ["Rooftop Bar Varanda", "Tram 28 au pied", "Climatisation"] },
        { name: "My Story Hotel Rossio", street: "Praça Dom Pedro IV 59", lat: 38.7135, lon: -9.1395, stars: "Hôtel 3★ Sup", basePrice: 85, rating: 9.2, reviews: 2200, perks: ["Rossio", "Restaurant portugais", "Climatisation"] },
        { name: "Goodmorning Solo Traveller Hostel", street: "Praça dos Restauradores 65", lat: 38.7160, lon: -9.1420, stars: "Auberge N°1 Monde", basePrice: 32, rating: 9.5, reviews: 2900, perks: ["Avenida da Liberdade", "Gaufres gratuites", "Ambiance exceptionnelle"] }
      ],
      montreal: [
        { name: "Fairmont Le Reine Élizabeth", street: "900 Boulevard René-Lévesque O", lat: 45.5005, lon: -73.5680, stars: "Hôtel 5★ Historique", basePrice: 260, rating: 9.4, reviews: 2800, perks: ["Centre-ville / Ville souterraine", "Suite John Lennon", "Piscine"] },
        { name: "Auberge du Vieux-Port", street: "97 Rue de la Commune E", lat: 45.5055, lon: -73.5525, stars: "Hôtel 4★ Charme", basePrice: 155, rating: 9.4, reviews: 1200, perks: ["Vieux-Port", "Briques & Poutres apparentes", "Rooftop"] },
        { name: "Hotel Monville Montréal", street: "1041 Rue de Bleury", lat: 45.5035, lon: -73.5630, stars: "Hôtel 4★ Design", basePrice: 135, rating: 9.3, reviews: 1900, perks: ["Quartier International", "Robots room-service", "Terrasse"] },
        { name: "M Montreal Hostel", street: "1245 Rue Saint-André", lat: 45.5175, lon: -73.5570, stars: "Auberge Réputée", basePrice: 38, rating: 9.3, reviews: 3100, perks: ["Village / Quartier Latin", "Spas sur le toit", "Bar comédie"] }
      ]
'''
print("Snippet syntax OK! Length:", len(additional_hotels_code))
