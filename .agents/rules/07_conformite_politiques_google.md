# 📜 RÈGLE 07 : CONFORMITÉ LÉGALE, VIE PRIVÉE & POLITIQUES DE CONTENU GOOGLE

## 🎯 Objectif
Assurer l'alignement absolu et sans compromis de tous les projets, applications, interfaces et développements avec les standards légaux, de confidentialité, de modération, de qualité web et de conformité publicitaire de l'écosystème Google.

---

## 🏛️ 1. Conditions Générales & Propriété Intellectuelle
> **Référence officielle** : [policies.google.com/terms](https://policies.google.com/terms)

- **Cadre légal régissant l'utilisation des services** : Tout code, interface ou outil développé doit respecter les conditions de service des API et plateformes intégrées.
- **Respect de la Propriété Intellectuelle** :
  - Interdiction stricte de l'usurpation de marque ou de logo. Les marques tierces (Google, Booking, Airbnb, Expedia, etc.) doivent être référencées de manière nominative et loyale, sans induire l'utilisateur en erreur sur une affiliation non autorisée.
  - Respect scrupuleux des droits d'auteur sur les assets visuels, icônes, typographies et médias embarqués.
- **Motifs de suspension / résiliation** : Tout comportement abusif, tentative de reverse engineering illicite, contournement de quotas d'API ou exploitation non autorisée entraîne le rejet immédiat du code par l'équipe d'audit (**AUD**).

---

## 🔒 2. Confidentialité & Protection des Données Personnelles
> **Référence officielle** : [policies.google.com/privacy](https://policies.google.com/privacy)

- **Minimisation des données (Privacy by Design)** :
  - Aucune collecte de données personnelles sensibles (santé, opinions, identifiants bancaires) sans infrastructure chiffrée et conforme.
  - Les préférences utilisateur (destination, budget, dates, panier, favoris) doivent être stockées de manière strictement locale (`localStorage`) sans transmission à des serveurs tiers non consentie.
- **Transparence et Consentement** :
  - Tout cookie ou stockage local persistant doit être explicite, avec possibilité de purge ou réinitialisation en un clic pour l'utilisateur.
  - Échappement et assainissement systématique des entrées utilisateur (`escapeHtml`, `escapeAttr`) pour neutraliser tout risque d'injection XSS ou d'exfiltration de données.

---

## 🛡️ 3. Transparence, Modération & Intégrité du Contenu
> **Références officielles** : 
> - Centre de transparence Google : [transparency.google](https://transparency.google)
> - Règles relatives au contenu du moteur de recherche : [support.google.com/websearch/answer/10622781](https://support.google.com/websearch/answer/10622781)

- **Critères stricts d'exclusion et de suppression** :
  - Bannissement absolu de tout contenu incitant à la haine, harcelant, violent, diffamatoire ou portant atteinte à la dignité des personnes.
  - Tolérance zéro pour les contenus explicites non consentis, l'exposition de données personnelles sensibles privées (doxing) ou la désinformation trompeuse.
- **Transparence des algorithmes de recommandation** :
  - Les critères de tri, de scoring et de classement des offres (ex : Coût & Prestation, Distance, Budget) doivent être objectifs, vérifiables et auditables.
  - Aucune manipulation opaque du classement au détriment de l'intérêt réel de l'utilisateur.

---

## 🚀 4. Google Search Essentials (Qualité Web & Anti-Spam)
> **Référence officielle** : [developers.google.com/search/docs/essentials](https://developers.google.com/search/docs/essentials)

- **Interdiction Formelle des Pratiques Trompeuses** :
  - **Zéro Cloaking** : L'application doit présenter rigoureusement le même contenu, les mêmes tarifs et la même structure aux moteurs de recherche et aux utilisateurs humains.
  - **Zéro Liens Trompeurs** : Les boutons, fiches et deep-links doivent pointer exactement vers la destination, la page d'établissement ou la recherche promise, sans redirection parasite ou piège à clic (clickbait).
  - **Zéro Contenu Généré Automatiquement Spammy** : Les descriptions, fiches et métadonnées doivent apporter une valeur informative réelle et authentique.
- **Qualité Technique & Performance** :
  - Conformité stricte aux Core Web Vitals (temps de chargement LCP < 2.5s, réactivité INP < 200ms, stabilité visuelle CLS < 0.1).
  - Structure sémantique HTML5 propre, balisage ARIA pour l'accessibilité universelle et responsive design mobile-first irréprochable.

---

## 📺 5. Règlement de la Communauté YouTube & Médias
> **Référence officielle** : [youtube.com/howyoutubeworks/policies/community-guidelines](https://www.youtube.com/howyoutubeworks/policies/community-guidelines/)

- **Sécurité et conformité des médias embarqués** :
  - Toute vidéo ou intégration YouTube doit respecter les directives communautaires : interdiction de la désinformation, de la violence graphique, du contenu trompeur et protection absolue des mineurs.
  - Utilisation exclusive de lecteurs officiels (YouTube IFrame API) respectant les conditions d'affichage, sans masquage des contrôles ni altération des flux légitimes.

---

## 📢 6. Règles du Programme Google Ads & Pratiques Commerciales
> **Référence officielle** : [support.google.com/adspolicy](https://support.google.com/adspolicy)

- **Exigences Éditoriales & Professionnelles** :
  - Clarté totale des offres : les tarifs affichés doivent inclure les taxes et frais obligatoires sans frais cachés découverts au dernier moment.
  - Mention explicite et transparente de tout lien d'affiliation, partenariat commercial ou sponsoring.
- **Interdiction des Pratiques Trompeuses** :
  - Ne jamais prétendre être une entité officielle tierce ou un organisme gouvernemental.
  - Ne jamais afficher de fausses réductions artificielles ou de faux comptes à rebours d'urgence non fondés.
- **Produits et services restreints ou interdits** : Conformité immédiate aux listes d'interdictions sectorielles Google Ads.

---

## 📋 Protocole de Contrôle Obligatoire (AUD)
Avant chaque mise en production ou validation :
1. **AUD** valide la conformité des liens externes (`rel="noopener noreferrer"`, cibles valides).
2. **AUD** contrôle l'absence de fuite de données personnelles ou de scripts de tracking non autorisés.
3. **AUD** s'assure qu'aucun cloaking ni contenu trompeur n'est injecté dans les templates de rendu.
