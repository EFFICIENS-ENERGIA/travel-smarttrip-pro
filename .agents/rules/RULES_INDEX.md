# ⚡ INDEX SYNTHÉTIQUE DES RÈGLES ANTIGRAVITY (RULES_INDEX.md)
> **Guide d'application rapide & Lazy Loading (Gain : ~70% de tokens)**  
> **Commanditaire :** Seb (Manager / Product Owner) | **Coordination :** @CE  
> **Application :** Pour toute consultation rapide ou injection de contexte compact dans les sous-agents.

---

### 🏛️ STRATE A : SOCLE UNIVERSEL D'INGÉNIERIE (100% DES PROJETS)

| ID | Règle Métier | Statut | Portée | Contrainte Inviolable (1 Ligne) | Code Erreur | Fichier Source |
|:---:|---|:---:|:---:|---|:---:|---|
| **00** | Audit Systématique Autonome | ACTIVE | UNIVERSEL | Exécution autonome de l'audit matriciel avant TOUTE réponse à Seb. | `ERR_00_AUDIT` | [`00_...md`](./00_PROTOCOLE_VERIFICATION_SYSTEMATIQUE.md) |
| **04** | Synchronisation Miroir / DRY | ACTIVE | UNIVERSEL | Parité binaire SHA-256 pour jumeaux statiques ou modularité DRY stricte. | `ERR_04_MIRROR` | [`04_...md`](./04_SYNCHRONISATION_MIROIR.md) |
| **07** | Sécurité, Vie Privée & Secrets | ACTIVE | UNIVERSEL | Zéro secret dans Git (`pre-push-check`), 100% liens `noopener noreferrer`. | `ERR_07_SECURITY` | [`07_...md`](./07_CONFORMITE_POLITIQUES_GOOGLE.md) |
| **08** | Sanctuarisation & Non-Régression | ACTIVE | UNIVERSEL | Non-régression continue : tout bug corrigé devient un test d'assertion permanent. | `ERR_08_REGRESSION` | [`08_...md`](./08_SANCTUARISATION_ACQUIS_ET_NON_REGRESSION.md) |
| **09** | Intégrité des Contraintes | ACTIVE | UNIVERSEL | Zéro repli silencieux : interdiction formelle d'élargir les filtres pour meubler l'UI. | `ERR_09_FALLBACK` | [`09_...md`](./09_INTEGRITE_CONTRAINTES_ET_ZERO_REPLI_SILENCIEUX.md) |
| **10** | Validation Matricielle | ACTIVE | UNIVERSEL | Interdiction du test mono-cas : matrice multi-scénarios et cas limites à 100% PASS. | `ERR_10_MATRIX` | [`10_...md`](./10_VALIDATION_MATRICIELLE_DES_CAS_LIMITES.md) |
| **11** | Source Unique & Parité Binaire | ACTIVE | UNIVERSEL | Même taille et hash binaire entre miroirs déployés ou composant unique partagé. | `ERR_11_PARITY` | [`11_...md`](./11_SOURCE_UNIQUE_DE_VERITE_ET_PARITE_BINAIRE.md) |
| **12** | Véracité Technique des Liens | ACTIVE | UNIVERSEL | Zéro URL conjecturée, zéro texte parasite dans les liens de redirection sortants. | `ERR_12_LINK_VERACITY` | [`12_...md`](./12_VERACITE_DES_INTEGRATIONS_ET_LIENS_REELS.md) |
| **14** | Fiabilité & Ground Truth | ACTIVE | UNIVERSEL | Interdiction des entités fictives ou générées par template : ancrage réel obligatoire. | `ERR_14_GROUND_TRUTH` | [`14_...md`](./14_FIABILITE_AUDITS_ET_GROUND_TRUTH.md) |
| **15** | Généralisation Systémique | ACTIVE | UNIVERSEL | Zéro patch localisé : tout correctif doit être généralisé aux modules homologues. | `ERR_15_SYSTEMIC` | [`15_...md`](./15_GENERALISATION_SYSTEMIQUE_DES_CORRECTIFS.md) |
| **16** | Habilitation Générale Commandes | ACTIVE | UNIVERSEL | Autorisation d'exécuter proactivement toute commande utile dans le respect des règles. | `ERR_16_EXEC_BLOCKED` | [`16_...md`](./16_HABILITATION_GENERALE_EXECUTION_COMMANDES.md) |
| **17** | Standard Next.js & Supabase SSR | ACTIVE | WEB CLOUD | Next.js App Router, `@supabase/ssr`, Middleware de session, validation Zod. | `ERR_17_NEXT_SSR` | [`17_...md`](./17_STANDARD_UNIVERSEL_NEXTJS_SUPABASE_SSR_MIDDLEWARE.md) |
| **18** | Authentification PKCE & OAuth | ACTIVE | WEB CLOUD | Échange de session sécurisé `app/auth/callback/route.ts`, redirection `?next=`. | `ERR_18_PKCE_AUTH` | [`18_...md`](./18_AUTHENTIFICATION_SECURISEE_OAUTH_MAGICLINKS_PKCE.md) |
| **19** | Bascule Automatique GitHub | ACTIVE | UNIVERSEL | Dépôt sur `EFFICIENS-ENERGIA`, architecture SSR injectée, validation pré-push. | `ERR_19_GITHUB_AUTO` | [`19_...md`](./19_STANDARD_BASCULE_AUTOMATIQUE_GITHUB_ET_SUPABASE.md) |
| **20** | Fail-Honest State & ARIA | ACTIVE | UI / UX | Composant accessible pour états vides avec méta-recherche réelle et modales WCAG. | `ERR_20_FAIL_HONEST` | [`20_...md`](./20_STANDARD_UIX_FAIL_HONEST_ET_ACCESSIBILITE.md) |
| **21** | Initialisation & Config Automatique | ACTIVE | UNIVERSEL | .cursorrules, OAuth 2.0, modèles emails, SQL unifié, formulaires UI et GitHub auto. | `ERR_21_CONFIG_AUTO` | [`21_...md`](./21_DIRECTIVES_INITIALISATION_CONFIGURATION_AUTOMATIQUE.md) |

---

### 📦 STRATE B : PACKS MÉTIERS SPÉCIFIQUES

| ID | Règle Métier | Pack | Contrainte Inviolable (1 Ligne) | Code Erreur | Fichier Source |
|:---:|---|:---:|---|:---:|---|
| **01** | Diversité Tarifaire Organique | VOYAGE | Profils `PLAT_PROFILES`, 0 tarif identique, vrais hôtels favorisés (+20 000 pts). | `ERR_01_PRICING` | [`01_...md`](./01_DIVERSITE_TARIFAIRE.md) |
| **02** | Respect Budget & Rayon | VOYAGE | 0 offre hors budget (`min <= p <= max`) et 0 offre hors rayon (`dist <= max`). | `ERR_02_FILTER` | [`02_...md`](./02_RESPECT_BUDGET_RAYON.md) |
| **03** | Intégrité Multi-Devises | VOYAGE | `USER_CURRENCY` jamais écrasée. Double affichage systématique `XXX € (≈ YYY local)`. | `ERR_03_CURRENCY` | [`03_...md`](./03_GESTION_DEVISES.md) |
| **05** | Fiches Logement & Deep-Links | VOYAGE | Modale `#hotelDetailModal` active, liens propres vers les 10 OTA avec `adults=X`. | `ERR_05_MODAL_OTA` | [`05_...md`](./05_FICHES_ET_LIENS_OTA.md) |
| **06** | Banc d'Essai Edge Headless | VOYAGE | Matrice 50 scénarios (10 dest × 5 jauges) validée à 50/50 PASS avec capture. | `ERR_06_TESTBENCH` | [`06_...md`](./06_PROTOCOLE_VALIDATION_BANC_ESSAI.md) |
| **13** | Garde-Fou Budget Déterministe| VOYAGE | Rejet systématique des offres hors budget. Statut explicite sans meublage. | `ERR_13_NO_MATCH` | [`13_...md`](./13_GARDE_FOU_BUDGET_DETERMINISTE.md) |
