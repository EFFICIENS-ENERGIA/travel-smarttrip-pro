# 📖 Guide Utilisateur : Moteur de Recherche de Logements & Transparence Tarifaire
**Projet** : `travel_dashboard`  
**Auteur** : `@DOC` (Tech Writer & Product Strategist)  
**Supervision** : `@coach` (Lead Tech Trainer)  
**Date** : Septembre 2026  

---

## 🌟 1. Pourquoi le Standard Zéro-Hallucination Change la Donne

La plupart des comparateurs de voyage sur le web ont recours à des algorithmes de "remplissage" : lorsqu'aucun hôtel ne correspond à votre budget, ils élargissent silencieusement vos critères ou affichent des prix d'appel obsolètes qui grimpent lors du clic final.

Notre moteur applique une charte d'ingénierie stricte :
1. **Plafond Inviolable** : Si vous fixez un budget à 150 € / nuit, vous ne verrez **absolument aucune offre à 151 €** dans la sélection principale.
2. **Statut "Aucun Résultat sous Budget" Honnête** : Si les hôtels de la destination sont tous au-dessus de votre enveloppe, le système vous en informe clairement (`NO_MATCH_UNDER_BUDGET`) et vous propose des simulations transparentes (+10%, +20%) ou un lien 1-clic direct.
3. **Zéro Nom ni Prix Inventé** : Tout renseignement non confirmé par la source officielle est affecté à `null`. Pas d'hôtel fantôme ni d'adresse approximative.

---

## 🔒 2. Comprendre le Badge d'Intégrité HTTP

À côté de chaque établissement, vous trouverez le badge **HTTP 200 OK** :
- **Vérification Réseau en Direct** : Le lien de réservation a été testé et validé sur les serveurs de la plateforme partenaire.
- **Zéro Lien Cassé** : Aucune erreur 404, aucun lien périmé.
- **Sécurité Garantie** : 100% des liens s'ouvrent dans un nouvel onglet sécurisé (`rel="noopener noreferrer"`), préservant votre navigation.

---

## 🌐 3. Consultation Hors-Ligne (Mode Avion)

Grâce à notre architecture *Offline-First* propulsée par IndexedDB et un Service Worker dédié :
- Vos **dernières recherches restent consultables** sans connexion internet.
- Aucune perte de données si le réseau est coupé dans le train ou l'avion.
- Synchronisation et rafraîchissement automatique dès le retour du réseau.
