# 📜 RÈGLE 11 : SOURCE UNIQUE DE VÉRITÉ & PARITÉ BINAIRE

> **Type** : Règle DevOps / Versioning / Intégrité du Code  
> **Auteur** : Seb (Manager / Product Owner) & CE (Chef d'Équipe)  
> **Application** : Obligatoire pour tous les agents (`CE`, `AUD`, `DEV`, `UIX`, `OPS`, `DOC`) sur tous les projets

---

## 🎯 1. Contexte & Objectif

L'existence de fichiers jumeaux ou de miroirs de déploiement (comme `index.html` pour la vitrine Web et `travel_dashboard.html` pour le banc d'application) a provoqué des désynchronisations où un correctif appliqué dans l'un était absent de l'autre, provoquant la confusion et des bugs fantômes.

**L'objectif de cette règle est de garantir l'unicité de la vérité et la parité binaire absolue entre fichiers miroirs.**

---

## 🛡️ 2. Directives Intangibles

1. **Source Unique de Vérité (SSOT)** :
   - Chaque composant logique, algorithme ou règle métier ne doit exister qu'en une seule implémentation de référence.
2. **Parité Binaire Stricte des Fichiers Miroirs** :
   - Si un projet exige deux fichiers jumeaux (ex: `index.html` $\leftrightarrow$ `travel_dashboard.html`), ils doivent être rigoureusement identiques au bit près :
     - **Même empreinte SHA-256**.
     - **Même taille en octets**.
3. **Zéro Modification Orpheline** : Il est formellement interdit d'éditer un fichier miroir sans répliquer immédiatement l'intégralité du contenu sur son jumeau avant de clore l'intervention.

---

## ⚙️ 3. Garde-Fous Techniques Imposés

- **Pour OPS (DevOps & Résilience)** :
  - Automatiser la réplication par script pré-livraison :
    ```powershell
    Copy-Item -Path $source -Destination $destination -Force
    ```
- **Pour AUD (Lead QA)** :
  - Intégrer dans le banc d'essai systématique la comparaison des hashs cryptographiques :
    ```powershell
    $hashA = (Get-FileHash $fileA -Algorithm SHA256).Hash
    $hashB = (Get-FileHash $fileB -Algorithm SHA256).Hash
    if ($hashA -ne $hashB) { throw "DIVERGENCE MIROIR DÉTECTÉE !" }
    ```
- **Pour DEV (Fullstack)** :
  - Toujours identifier clairement quel fichier constitue la référence de développement avant d'effectuer des modifications.

---

## 🧪 4. Protocole de Validation Obligatoire (AUD)

Avant toute remise de version à Seb :
1. Calcul du hash SHA-256 de chaque fichier miroir.
2. Comparaison mathématique stricte ($Hash_A == Hash_B$).
3. Certification du résultat dans le tableau de conformité du Protocole 00 (**PASS** obligatoire).
