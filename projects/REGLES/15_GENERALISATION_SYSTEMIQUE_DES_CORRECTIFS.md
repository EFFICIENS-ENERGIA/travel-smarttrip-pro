# 📜 RÈGLE 15 : GÉNÉRALISATION SYSTÉMIQUE & PROPAGATION UNIVERSELLE DES CORRECTIFS (SYSTEM-WIDE EXTENSION & ZERO LOCAL PATCH)

> **Type** : Règle Fondamentale d'Architecture, Qualité & Maintenance Évolutive  
> **Commanditaire & Vision** : Seb (Manager / Product Owner)  
> **Coordination & Rédaction** : CE (Chef d'Équipe / Lead Orchestrator)  
> **Application** : Obligatoire et immédiate pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`, `@coach`) sur tous les projets actuels et futurs  
> **Date de promulgation** : 17 Septembre 2026  

---

## 🎯 1. Contexte & Directive Explicite de Seb

Lors des cycles d'amélioration continue d'un logiciel complexe, une défaillance ou un comportement inattendu est fréquemment observé sur un composant spécifique (par exemple : une redirection d'URL vers la page d'accueil d'un comparateur comme Booking, un problème d'accent sur une ville comme São Paulo, un filtre de date incomplet, ou un paramètre orphelin).

Le réflexe traditionnel – et défaillant – consiste à appliquer un **« patch localisé »** uniquement sur la fonction ou l'élément incriminé (ex: corriger Booking seul, sans toucher aux 9 autres comparateurs ; corriger la grille principale sans corriger la modale ou les favoris).

**Consigne impérative de Seb :**
> *« Toutes modifications doit être systématiquement étendu dans tout l'outil pas seulement sur l'élément défaillant. Appliquer cette règle sur tous les projets. »*

Cette directive sanctuarise le principe de **Généralisation Systémique & Propagation Universelle** : toute solution validée sur un élément devient instantanément le standard obligatoire pour **l'ensemble des composants homologues** du système.

---

## 🛡️ 2. Les 4 Piliers Inviolables de la Règle 15

### Pilier 1 : Interdiction Formelle du « Patch Localisé » (Zero Local Patch)
- Tout correctif apporté à une anomalie ne doit **jamais** se limiter au seul cas d'usage ayant déclenché le signalement.
- Si une vulnérabilité, un bogue d'encodage, un défaut de validation ou une anomalie de routage est résolu sur un module :
  - L'équipe a l'obligation formelle d'auditer et d'appliquer le correctif à **tous les modules de même nature** dans l'application.
  - Exemple concret : si une routine de nettoyage d'accents et de suppression des caractères toxiques est créée pour un comparateur hôtelier, elle doit être **immédiatement intégrée à l'ensemble des 10 comparateurs**, ainsi qu'aux requêtes cartographiques, modales, modules de duel et favoris.

### Pilier 2 : Moteur Canonique Unifié & Source Unique de Vérité
- L'extension systémique ne doit pas être réalisée par un copier-coller de rustines ou une prolifération de blocs conditionnels dispersés.
- L'équipe technique (`@DEV`) doit concevoir un **moteur canonique réutilisable** (ex: `buildUniversalOtaUrl`, `normalizeSearchText`, `sanitizeInput`) qui centralise la règle métier et dessert uniformément l'ensemble des points d'appel de l'outil.
- Zéro divergence algorithmique : chaque composant consomme le même moteur certifié.

### Pilier 3 : Propagation Horizontale & Verticale de l'Interface
- **Propagation Horizontale** : L'amélioration s'applique à tous les acteurs d'une même couche (ex: Booking, Google Hotels, Airbnb, Agoda, Expedia, Hotels.com, Abritel, TripAdvisor, Kayak, Hostelworld).
- **Propagation Verticale** : L'amélioration s'applique à tous les niveaux de présentation de l'information :
  1. *Filtres & Barres de recherche* (gestion des diacritiques, dates, devises).
  2. *Grille principale des offres* (liens sortants, boutons de réservation).
  3. *Modale native in-app `#hotelDetailModal`* (auto-guérison des liens, boutons directs).
  4. *Panier Favoris & Historique* (re-calibrage des liens persistés).
  5. *Mode Duel & Cockpit* (vérification de la parité des paramètres).
  6. *Outils d'Export & Partage* (WhatsApp, ICS, PDF, Presse-papiers).

### Pilier 4 : Audit Matriciel Exhaustif & Preuve de Non-Régression (@AUD)
- L'auditeur (`@AUD`) ne valide jamais une tâche sur la seule base du cas d'origine.
- Le banc d'essai automatisé (Edge Chromium Headless) doit exécuter une **matrice de test exhaustive** couvrant :
  - L'ensemble des modules homologues (les 10 comparateurs, toutes les modales, tous les formats d'export).
  - Un panel de cas extrêmes (villes avec accents, cédilles, tildes, slashes, apostrophes, tirets, idéogrammes).
  - Différentes configurations d'utilisation (dates présentes vs absentes, voyageurs solos vs grands groupes, budgets serrés vs illimités).
- Un test n'est certifié **PASS** que si **100% de la matrice est validée**.

---

## ⚙️ 3. Protocole Opératoire & Répartition des Rôles

| Rôle | Responsabilité opérationnelle sous la Règle 15 |
|:---:|---|
| **Seb** | Donneur d'ordres, validation finale de la généralisation et arbitrage stratégique. |
| **CE** | Identification du périmètre global d'extension dès la prise de consigne, cadrage de l'architecture canonique et contrôle de propagation. |
| **DEV** | Implémentation du moteur canonique unifié, refactoring des points d'appel dans tout le codebase, éradication des duplications et des rustines locales. |
| **AUD** | Conception et exécution du banc d'essai matriciel global sous Edge Headless (100% PASS exigé sur tous les comparateurs et modules). |
| **UIX** | Garantie de l'homogénéité visuelle, ergonomique et responsive des composants modifiés sur Mobile, Tablette et Desktop. |
| **OPS** | Synchronisation miroir binaire stricte (Règles 04 & 11) sur tous les fichiers maîtres et distribution, mise à jour des zips livrables. |
| **DOC** | Documentation de la règle et mise à jour des walkthroughs et manuels utilisateurs sans conjecture. |

---

## 📋 4. Exemple d'Application Concrète (Projet SmartTrip Pro)

| Bogue Découvert | Réflexe Local Défaillant (Interdit) | Généralisation Systémique Exigée (Règle 15) |
|---|---|---|
| Redirection Booking vers `index.fr.html` sur São Paulo (diacritiques + paramètres manquants). | Créer un `if (city === 'São Paulo')` ou corriger uniquement Booking. | 1. Création de `normalizeSearchText` (suppression universelle des diacritiques et caractères toxiques).<br>2. Création de `buildUniversalOtaUrl` étendu aux 10 comparateurs.<br>3. Auto-guérison dans la modale in-app pour TOUTES les plateformes.<br>4. Test matriciel sur São Paulo, Málaga, Séville, Dallas, Tokyo, Paris sur les 10 OTA. |
| Bouton fiche inopérant sur un favori orphelin. | Réparer uniquement le clic dans la vue favoris. | Auditer et unifier l'ouverture de `#hotelDetailModal` sur la grille principale, les favoris, le duel, le cockpit et les bannières de budget. |
| Dépassement de budget sur un hôtel à Tokyo. | Filtrer Tokyo dans une condition spécifique. | Appliquer le garde-fou déterministe absolu (Règle 13) sur toutes les requêtes mondiales. |

---

## 🚀 5. Statut & Pérennité Inter-Projets

- La Règle 15 est **inscrite au référentiel central** `c:\Users\EFFICIENS ENERGIA\Desktop\ANTIGRAVITY\projects\REGLES\`.
- Elle est synchronisée par le script `synchroniser_regles.ps1` sur tous les dossiers de travail et configurations système Antigravity.
- Elle est active et opposable dès à présent pour **tous les projets en cours et futurs**.
