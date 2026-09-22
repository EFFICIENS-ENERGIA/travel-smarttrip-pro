# 📜 RÈGLE 06 : PROTOCOLE DE VALIDATION PAR BANC D'ESSAI RÉEL (LEAD AUD)

## 🎯 Objectif
Interdire formellement toute validation théorique ou déclaration de conformité non étayée par un banc d'essai automatisé sur un navigateur réel (Edge Chromium Headless).

---

## 🚫 Interdictions Absolues
1. **ZÉRO VALIDATION SANS EXÉCUTION RÉELLE** : Aucun agent (`DEV`, `CE`, etc.) ne peut prétendre à **Seb** qu'un bogue est résolu ou qu'une fonctionnalité est prête sans avoir exécuté le banc d'essai correspondant.
2. **ZÉRO VALIDATION PARTIELLE** : La matrice des 50 scénarios (10 destinations mondiales $\times$ 5 jauges de voyageurs : 2, 3, 4, 5, 6 personnes) doit être exécutée dans sa totalité et obtenir **50 / 50 PASS**.
3. **ZÉRO ÉCHEC TOLÉRÉ** : Même un seul échec ($49/50$) invalide le livrable et déclenche un blocage immédiat par **AUD**.

---

## 📐 Standards Obligatoires d'Implémentation

### 1. Procédure d'Exécution du Banc d'Essai
Avant toute clôture de tâche ou restitution à Seb :
1. Exécuter la suite matrice complète :
   ```powershell
   powershell -ExecutionPolicy Bypass -File "scratch/run_matrix_suite.ps1"
   ```
2. Vérifier la sortie :
   - `50/50 SCÉNARIOS VALIDÉS AVEC SUCCÈS`
   - `0 offre hors budget`
   - `0 offre hors rayon`
   - `0 échec de fiche`
3. Vérifier la diversité tarifaire réelle :
   - Relever les prix réels affichés sur les 10 cartes.
   - Constater que chaque comparateur présente un tarif cohérent avec son profil de marché.
4. Générer une capture d'écran horodatée avec taille d'image valide (> 0 octets).

### 2. Archivage des Preuves dans `walkthrough.md`
Le fichier `walkthrough.md` doit être systématiquement enrichi du tableau d'audit actualisé et de la référence vers la capture d'écran d'audit.
