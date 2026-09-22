# ⚡ PROTOCOLE 00 : VÉRIFICATION SYSTÉMATIQUE & AUTONOME POUR TOUS PROJETS

> **Directive Suprême de Seb (Manager / Product Owner)**  
> **Exécution** : Obligatoire, automatique et systématique par toute l'équipe (**CE**, **AUD**, **DEV**, **UIX**, **OPS**, **DOC**).  
> **Condition de déclenchement** : **SANS ATTENDRE DE DEMANDE DE SEB**, pour tout projet actuel et futur, avant chaque livraison, restitution ou clôture de tâche.

---

## 🎯 1. Principe Fondamental & Mandat

À la suite de la consigne formelle de **Seb** :  
> *« CE vérifier avec toute l'équipe que l'outil respecte toutes les règles et réaliser dorénavant cette action systématiquement sans que je demande pour tout projet »*

Il est strictement interdit à tout agent (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) de considérer une tâche comme achevée ou de soumettre un livrable à Seb sans avoir **autonomement et systématiquement** exécuté la vérification intégrale des 7 Règles Intangibles.

---

## 📋 2. Checklist d'Audit Autonome en 7 Piliers

Avant toute remise de réponse à Seb, l'équipe passe obligatoirement en revue les 7 piliers :

| # | Règle Métier | Point de Contrôle Impératif | Validateur |
|:---:|---|---|:---:|
| **01** | **Diversité Tarifaire Organique** | Vérifier que les prix des 10 comparateurs sont distincts et calibrés via `PLAT_PROFILES`. Les établissements physiques réels doivent être scorés à 20 000+ points contre 14 000 pour les replis. | **DEV / AUD** |
| **02** | **Respect Inviolable Budget & Rayon** | 0 offre hors budget (`minPrice <= p <= maxPrice`) et 0 offre hors rayon (`dist <= maxDist`). Aucun compromis toléré. | **DEV / AUD** |
| **03** | **Intégrité Multi-Devises** | La devise utilisateur (`USER_CURRENCY`, ex: EUR) ne doit JAMAIS être écrasée par la destination visitée. Double affichage informatif systématique : `XXX € TTC (≈ YYY local)`. | **DEV / UIX** |
| **04** | **Synchronisation Miroir Obligatoire** | Parité binaire ou hash stricte `index.html` $\leftrightarrow$ `travel_dashboard.html`. Zéro divergence de versioning. | **OPS** |
| **05** | **Fiches Logement & Deep-Links OTA** | Modale native `#hotelDetailModal` 100% fonctionnelle au clic. Schémas d'URL vers les 10 OTA épurés, sans texte polluant et avec paramètre `adults=X`. | **UIX / DEV** |
| **06** | **Validation par Banc d'Essai Réel** | Exécution automatisée sous Edge Chromium Headless de la matrice des 50 scénarios (10 destinations × 5 jauges de voyageurs) validée à **50/50 PASS** avec capture d'écran certifiée. | **AUD** |
| **07** | **Conformité Google & Sécurité Web** | 100% des liens externes avec `rel="noopener noreferrer"`. Échappement anti-XSS (`escapeHtml`, `escapeAttr`). Tarifs TTC sans frais cachés. Conformité Search Essentials, YouTube & Google Ads. | **AUD / DOC** |

---

## ⚙️ 3. Automatisation Technique de l'Audit

Un banc d'essai automatisé d'audit (`scratch/audit_all_7_rules.ps1`) est maintenu et exécutable sous PowerShell :
```powershell
powershell -ExecutionPolicy Bypass -File "scratch/audit_all_7_rules.ps1"
```
Ce banc teste programmatiquement les 7 règles et ne concède la conformité que si **7/7 PASS** est obtenu.

---

## 📢 4. Formalisme de Restitution à Seb

Toute restitution finale de **CE** à **Seb** doit désormais intégrer :
1. L'état d'avancement de la demande métier de Seb.
2. Le **Certificat de Conformité Systématique aux 7 Règles** (tableau synthétique attestant du statut PASS sur chaque règle).
3. L'assurance qu'aucune régression n'a été introduite.
