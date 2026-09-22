# 🛡️ DOSSIER RÈGLES & STANDARDS INTANGIBLES DU PROJET

> **Document de Référence Stratégique & Technique**  
> **Commanditaire** : Seb (Manager / Product Owner)  
> **Coordination** : CE (Chef d'Équipe / Lead Orchestrator)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`)  
> **Dernière mise à jour** : 10 Septembre 2026

---

## 📌 Pourquoi ce Dossier de Règles ?

À la suite de plusieurs anomalies récurrentes constatées au cours du développement (notamment l'uniformisation accidentelle des tarifs sur les 10 comparateurs, les télescopages de devises sur le Japon, ou les ruptures de synchronisation entre fichiers), **Seb a exigé l'instauration d'un dossier de règles immuables**.

Ce dossier formalise et verrouille les standards que **chaque agent doit scrupuleusement respecter avant toute modification de code et avant toute livraison**.

---

## 📑 Sommaire des Règles & Protocoles Fondamentaux

| Règle / Protocole | Fichier | Objectif Majeur | Garde-Fou Technique |
|:---:|---|---|---|
| **00** | [`00_PROTOCOLE_VERIFICATION_SYSTEMATIQUE.md`](./00_PROTOCOLE_VERIFICATION_SYSTEMATIQUE.md) | **Audit systématique & autonome pour TOUT projet** | **Exécution obligatoire avant chaque réponse ou livraison sans que Seb ait à le demander.** Exécution du banc d'essai multi-règles à 100% PASS. |
| **01** | [`01_DIVERSITE_TARIFAIRE.md`](./01_DIVERSITE_TARIFAIRE.md) | **Zéro prix identique entre comparateurs** | Modèle `PLAT_PROFILES` avec ratios économiques étagés + inversion des scores (vrais hôtels à 20 000+ pts > replis à 14 000 pts). |
| **02** | [`02_RESPECT_BUDGET_RAYON.md`](./02_RESPECT_BUDGET_RAYON.md) | **Étanchéité budgétaire & kilométrique absolue** | 0 offre hors budget (`minPrice <= p <= maxPrice`) et 0 offre hors rayon (`dist <= maxDist`). Filtrage strict sans complaisance. |
| **03** | [`03_GESTION_DEVISES.md`](./03_GESTION_DEVISES.md) | **Protection de la devise utilisateur** | La devise utilisateur (`USER_CURRENCY`, ex: EUR) n'est jamais écrasée. Double affichage informatif de la devise locale entre parenthèses. |
| **04** | [`04_SYNCHRONISATION_MIROIR.md`](./04_SYNCHRONISATION_MIROIR.md) | **Parité stricte `index.html` $\leftrightarrow$ `travel_dashboard.html`** | Interdiction formelle de modifier un fichier sans reporter immédiatement l'intégralité du code sur son jumeau. |
| **05** | [`05_FICHES_ET_LIENS_OTA.md`](./05_FICHES_ET_LIENS_OTA.md) | **Pérennité des fiches & deep-links vers les 10 OTA** | Modale native in-app `#hotelDetailModal` active sur tous les logements. URLs vers les 10 comparateurs sans texte parasite. |
| **06** | [`06_PROTOCOLE_VALIDATION_BANC_ESSAI.md`](./06_PROTOCOLE_VALIDATION_BANC_ESSAI.md) | **Certification obligatoire sous Edge Headless** | Validation systématique par AUD de la matrice 50 scénarios (10 destinations $\times$ 5 jauges de voyageurs) à **50/50 PASS**. |
| **07** | [`07_CONFORMITE_POLITIQUES_GOOGLE.md`](./07_CONFORMITE_POLITIQUES_GOOGLE.md) | **Conformité légale, vie privée & politiques Google** | Respect absolu des CGU Google ([policies.google.com/terms](https://policies.google.com/terms)), de la confidentialité ([policies.google.com/privacy](https://policies.google.com/privacy)), du centre de transparence ([transparency.google](https://transparency.google)), de la modération Search ([support.google.com/websearch/answer/10622781](https://support.google.com/websearch/answer/10622781)), de Google Search Essentials ([developers.google.com/search/docs/essentials](https://developers.google.com/search/docs/essentials)), du règlement YouTube ([youtube.com/howyoutubeworks/policies/community-guidelines](https://www.youtube.com/howyoutubeworks/policies/community-guidelines/)) et de Google Ads ([support.google.com/adspolicy](https://support.google.com/adspolicy)). |
| **08** | [`08_SANCTUARISATION_ACQUIS_ET_NON_REGRESSION.md`](./08_SANCTUARISATION_ACQUIS_ET_NON_REGRESSION.md) | **Sanctuarisation des acquis & non-régression** | Interdiction formelle de retour en arrière. Tout correctif validé devient un test d'assertion automatisé obligatoire. |
| **09** | [`09_INTEGRITE_CONTRAINTES_ET_ZERO_REPLI_SILENCIEUX.md`](./09_INTEGRITE_CONTRAINTES_ET_ZERO_REPLI_SILENCIEUX.md) | **Intégrité absolue des contraintes & zéro compromis silencieux** | 0 offre hors budget, 0 offre hors rayon. Interdiction d'élargir silencieusement les critères pour meubler l'interface. |
| **10** | [`10_VALIDATION_MATRICIELLE_DES_CAS_LIMITES.md`](./10_VALIDATION_MATRICIELLE_DES_CAS_LIMITES.md) | **Validation matricielle des cas limites & stress testing** | Interdiction de la validation mono-cas. Matrice obligatoire multi-jauges, multi-devises et multi-destinations à 100% PASS. |
| **11** | [`11_SOURCE_UNIQUE_DE_VERITE_ET_PARITE_BINAIRE.md`](./11_SOURCE_UNIQUE_DE_VERITE_ET_PARITE_BINAIRE.md) | **Source unique de vérité & parité binaire** | Parité binaire stricte (même hash SHA-256 et même taille) entre fichiers miroirs. Zéro divergence tolérée. |
| **12** | [`12_VERACITE_DES_INTEGRATIONS_ET_LIENS_REELS.md`](./12_VERACITE_DES_INTEGRATIONS_ET_LIENS_REELS.md) | **Véracité technique des intégrations & liens réels** | Zéro conjecture d'URL, zéro texte parasite (`pour X personnes`). 100% des liens sortants en `rel="noopener noreferrer"`. |
| **13** | [`13_GARDE_FOU_BUDGET_DETERMINISTE.md`](./13_GARDE_FOU_BUDGET_DETERMINISTE.md) | **Garde-fou budget déterministe & statut explicite** | Rejet systématique de tout logement dépassant le budget. Statut `NO_MATCH_UNDER_BUDGET` sans hallucination. |
| **14** | [`14_FIABILITE_AUDITS_ET_GROUND_TRUTH.md`](./14_FIABILITE_AUDITS_ET_GROUND_TRUTH.md) | **Fiabilité des audits & ancrage au réel (Ground Truth)** | Interdiction absolue des tests auto-référentiels et des hôtels inventés par template. Vérification cadastrale obligatoire. Mode méta-comparateur 1-clic direct. |
| **15** | [`15_GENERALISATION_SYSTEMIQUE_DES_CORRECTIFS.md`](./15_GENERALISATION_SYSTEMIQUE_DES_CORRECTIFS.md) | **Généralisation systémique & zéro patch localisé** | Toute modification ou correction sur un élément doit être systématiquement et immédiatement étendue à l'ensemble des modules homologues (10 comparateurs, modales, favoris, duel, cockpit) sur tous les projets. |
| **16** | [`16_HABILITATION_GENERALE_EXECUTION_COMMANDES.md`](./16_HABILITATION_GENERALE_EXECUTION_COMMANDES.md) | **Habilitation générale d'exécution & autonomie totale** | **Autorisation préalable donnée par Seb d'exécuter proactivement toute commande nécessaire au projet**, à condition stricte que les règles existantes (00 à 15) soient respectées. Zéro friction opérationnelle. |
| **17** | [`17_STANDARD_UNIVERSEL_NEXTJS_SUPABASE_SSR_MIDDLEWARE.md`](./17_STANDARD_UNIVERSEL_NEXTJS_SUPABASE_SSR_MIDDLEWARE.md) | **Standard universel Next.js SSR & Supabase Middleware** | Architecture Next.js App Router obligatoire : `@supabase/ssr`, `zod`, `middleware.ts`, `utils/supabase/` (client, server, middleware), isolation RLS PostgreSQL. |
| **18** | [`18_AUTHENTIFICATION_SECURISEE_OAUTH_MAGICLINKS_PKCE.md`](./18_AUTHENTIFICATION_SECURISEE_OAUTH_MAGICLINKS_PKCE.md) | **Authentification sécurisée PKCE, OAuth & Magic Links** | Flux PKCE complet via `app/auth/callback/route.ts`, `exchangeCodeForSession`, gestion des en-têtes `x-forwarded-host`, redirection sécurisée avec paramètre `?next=`. |
| **19** | [`19_STANDARD_BASCULE_AUTOMATIQUE_GITHUB_ET_SUPABASE.md`](./19_STANDARD_BASCULE_AUTOMATIQUE_GITHUB_ET_SUPABASE.md) | **Bascule automatique GitHub & Supabase SSR (Projets Actuels & Futurs)** | Obligation absolue d'initialisation et synchronisation automatique de TOUT projet existant ou futur vers l'organisation GitHub `EFFICIENS-ENERGIA` et Supabase Cloud SSR. Script universel 1-clic `NOUVEAU_PROJET.bat`. |

---

## ⚙️ Intégration dans le Moteur Antigravity

Ces règles existent sous deux formes interconnectées :
1. **Dossier Utilisateur (`REGLES/`)** : Directement consultable et éditable par Seb dans l'explorateur Windows.
2. **Dossier Système (`.agents/rules/`)** : Détecté et injecté automatiquement par le moteur Antigravity dans le contexte de chaque agent et sous-agent lors de toute session de travail.

---

## ✍️ Espace d'Évolution de Seb : Comment Ajouter de Nouvelles Règles ?

Seb peut à tout moment ajouter de nouvelles règles ou directives métier :
1. **Fiche Méthode** : Consultez [`COMMENT_AJOUTER_UNE_REGLE.md`](./COMMENT_AJOUTER_UNE_REGLE.md) pour les consignes pas-à-pas.
2. **Modèle Prêt à l'Emploi** : Dupliquez [`MODELE_NOUVELLE_REGLE.md`](./MODELE_NOUVELLE_REGLE.md) et nommez votre fichier `08_VOTRE_REGLE.md`, `09_...`.
3. **Synchronisation Automatique** : Double-cliquez sur [`synchroniser_regles.ps1`](./synchroniser_regles.ps1) pour propager immédiatement vos nouvelles règles sur tous les projets de la machine.
4. **Prise en Compte Immédiate** : L'équipe multi-agents intègre automatiquement vos nouvelles règles dès leur création, sans configuration additionnelle !

> [!CAUTION]
> **Règle d'or de l'équipe** : Aucune intervention humaine ou automatisée ne peut déroger à ces standards sans l'approbation explicite et écrite de **Seb**.

