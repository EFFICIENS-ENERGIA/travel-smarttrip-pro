# 📜 RÈGLE 09 : INTÉGRITÉ ABSOLUE DES CONTRAINTES & ZÉRO REPLI SILENCIEUX

> **Type** : Règle Métier / Algorithmique / Éthique Logicielle  
> **Auteur** : Seb (Manager / Product Owner) & CE (Chef d'Équipe)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets

---

## 🎯 1. Contexte & Objectif

Dans les versions initiales, l'outil affichait parfois des établissements dépassant le budget utilisateur (ex: 159 € pour un plafond demandé de 150 €) ou situés au-delà du rayon kilométrique (ex: 3.5 km pour un rayon demandé de 2 km). Cela provenait d'algorithmes de repli ("fallbacks") qui élargissaient silencieusement les critères pour forcer l'affichage de résultats à tout prix.

**L'objectif de cette règle est de bannir tout compromis silencieux : les contraintes de Seb et de l'utilisateur sont sacrées.**

---

## 🛡️ 2. Directives Intangibles

1. **Étanchéité Stricte des Filtres** :
   - Si l'utilisateur définit un budget `[minPrice, maxPrice]`, aucune offre avec un prix $P < minPrice$ ou $P > maxPrice$ ne doit franchir le pipeline d'affichage ($0$ tolérance).
   - Si l'utilisateur définit un rayon maximal $D_{max}$, aucune offre à une distance $D > D_{max}$ ne doit être affichée ($0$ tolérance).
2. **Interdiction Formelle du Repli Silencieux** : Le code ne doit jamais relâcher en douce les paramètres saisis pour "meubler" une interface.
3. **Vérité & Transparence de l'État Vide** : Si aucun résultat ne remplit 100% des critères, l'outil doit afficher un état vide élégant et informatif (ex: *"Aucun logement ne correspond exactement à vos critères stricts dans ce rayon de X km. Élargissez le rayon ou relevez le plafond pour voir plus d'offres."*).

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour DEV (Fullstack)** :
  - Placer une barrière de validation finale systématique juste avant le rendu DOM :
    ```javascript
    const validDeals = allDeals.filter(d => 
      (maxPrice === 1000 || d.price <= maxPrice) &&
      (minPrice === 0 || d.price >= minPrice) &&
      (maxDist === 0 || d.realDistKm <= maxDist)
    );
    ```
  - Interdire tout écrasement des variables utilisateur par des valeurs par défaut non sollicitées.
- **Pour UIX (Design & Ergonomie)** :
  - Créer des bannières d'état vide pédagogiques expliquant clairement quel filtre bloque les résultats.
- **Pour AUD (Lead QA)** :
  - Injecter systématiquement des scénarios de test aux bornes très serrées (ex: budget 40-50 €, rayon 0.5 km) pour vérifier qu'aucune offre hors critères ne s'infiltre.

---

## 🧪 4. Protocole de Validation Obligatoire (AUD)

Pour chaque destination et chaque jauge de voyageurs testée :
- Nombre d'offres avec `price > maxPrice` : **strictement 0**.
- Nombre d'offres avec `price < minPrice` : **strictement 0**.
- Nombre d'offres avec `distance > maxDistance` : **strictement 0**.
- En cas de violation d'une seule offre, le statut du scénario passe immédiatement à **FAIL**.
