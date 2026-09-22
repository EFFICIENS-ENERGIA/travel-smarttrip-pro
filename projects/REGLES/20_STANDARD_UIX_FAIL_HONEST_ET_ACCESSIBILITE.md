# 📜 RÈGLE 20 : STANDARD UI/UX DES ÉTATS VIDES "FAIL-HONEST" & ACCESSIBILITÉ ARIA

> **Type** : Règle Fondamentale d'Ergonomie, Design System & Accessibilité Universelle  
> **Commanditaire** : Seb (Manager / Product Owner)  
> **Auteurs** : @UIX (Lead UI/UX & Design System) & @DEV (Senior Fullstack)  
> **Application** : Obligatoire pour tous les projets actuels et futurs dotés d'une interface utilisateur  
> **Date de promulgation** : 22 Septembre 2026  

---

## 🎯 1. Contexte & Doctrine "Fail-Honest"

Les Règles 13 (Garde-Fou Budget) et 14 (Ground Truth) interdisent formellement de générer des entités fictives ou de violer les contraintes utilisateur pour meubler l'écran.  
Cependant, l'absence de résultats ne doit jamais se traduire par un écran blanc, un crash silencieux ou une interface hostile.

**La Règle 20 impose la matérialisation visuelle et accessible de la politique "Fail-Honest" via le composant standardisé `FailHonestState`.**

---

## 🎨 2. Les 4 Éléments Obligatoires du Composant `FailHonestState`

Tout écran ou conteneur affichant un résultat vide ou filtré à zéro doit intégrer :

1. **Un Diagnostic Explicite & Bienveillant** :
   - Indication claire des filtres ayant conduit à l'absence de résultat (ex: *"Aucun logement physique certifié sous 50 € dans un rayon de 3 km"*).
   - Bannissement des messages anxiogènes ou techniques bruts (*« Error 404 / No data »*).
2. **Un Bouton d'Action 1-Clic de Réinitialisation** :
   - Bouton permettant de réinitialiser ou d'élargir instantanément les filtres les plus contraignants (ex: *"Réinitialiser le budget"* ou *"Élargir le rayon à 10 km"*).
3. **Le Méta-Comparateur Direct 1-Clic (Règle 14)** :
   - Bouton d'action primaire ouvrant les moteurs de recherche réels certifiés (Booking, Google Hotels, Airbnb, registre officiel) pré-remplis avec 100% des critères utilisateur réels.
4. **Accessibilité ARIA & WCAG AA/AAA** :
   - Conteneur avec `role="status"` et `aria-live="polite"`.
   - Contraste de texte supérieur ou égal à 4.5:1 (WCAG AA).
   - Support complet de la navigation clavier (Tabulation / Entrée).

---

## 🪟 3. Standard d'Accessibilité des Boîtes de Dialogue & Modales

Toute modale native in-app (ex: `#hotelDetailModal` de la Règle 05 ou modale de prise de RDV) doit satisfaire 4 règles d'accessibilité inviolables :

1. **Attributs ARIA** : L'élément conteneur doit porter `role="dialog"`, `aria-modal="true"` et `aria-labelledby="[id_titre]"`.
2. **Focus Trap (Capture du Focus)** : Dès l'ouverture, le focus est positionné sur le premier élément interactif (ou bouton fermer) et reste enfermé dans la modale lors de la tabulation (`Tab` / `Shift+Tab`).
3. **Fermeture Universelle sur `Échap`** : L'appui sur la touche clavier `Escape` doit fermer immédiatement la modale.
4. **Restauration du Focus** : À la fermeture, le focus doit être automatiquement renvoyé vers l'élément déclencheur qui avait ouvert la modale.

---

## 💻 4. Implémentations de Référence Disponibles

- **Version Web Native / Vanilla JS** : [`$HOMEagy2-projectsmy-first-project/js/FailHonestState.js`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/$HOMEagy2-projectsmy-first-project/js/FailHonestState.js)
- **Version React / Next.js TypeScript** : [`SAAS EFFICIENS ENERGIA/components/ui/FailHonestState.tsx`](file:///c:/Users/EFFICIENS%20ENERGIA/Desktop/ANTIGRAVITY/SAAS%20EFFICIENS%20ENERGIA/components/ui/FailHonestState.tsx)
