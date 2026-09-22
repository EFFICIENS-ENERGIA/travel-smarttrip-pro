# 📖 Guide Utilisateur — PWA Task Manager Offline-First

**Application** : Gestionnaire de Tâches Personnel et Professionnel  
**Auteur** : `@DOC` (Tech Writer & Product Strategist)  
**Version** : 2.0.0 (Release PWA Certifiée)  

---

## 🌟 Présentation Générale

Le **PWA Task Manager Offline-First** est une application web moderne conçue pour vous permettre d'organiser vos tâches quotidiennes avec une fiabilité absolue, même sans connexion Internet. Grâce à sa persistance locale sécurisée, vous ne perdez jamais vos données en cas de panne réseau ou de fermeture inattendue du navigateur.

---

## 🚀 Prise en Main Rapide

### 1. Ouvrir l'Application
Ouvrez le fichier `index.html` situé dans le dossier `app_build/` directement dans votre navigateur web moderne (Google Chrome, Microsoft Edge, Safari, Mozilla Firefox).

### 2. Créer une Nouvelle Tâche
1. Saisissez le **Titre** de la tâche (obligatoire, max 120 caractères).
2. Ajoutez une **Description** ou des notes complémentaires (facultatif).
3. Sélectionnez le niveau de **Priorité** (*Basse*, *Moyenne*, ou *Haute*).
4. Définissez une **Date d'échéance** si nécessaire.
5. Cliquez sur le bouton **« Enregistrer la tâche »**. La tâche apparaît instantanément dans votre liste.

### 3. Valider ou Supprimer une Tâche
- **Terminer une tâche** : Cochez simplement la case à gauche du titre de la tâche. La tâche est barrée et son statut passe à *Terminée*.
- **Supprimer une tâche** : Cliquez sur le bouton **« 🗑️ Supprimer »** situé au bas de la carte de tâche.

### 4. Filtrer et Rechercher
Utilisez la barre de filtres au-dessus de la liste pour :
- Filtrer par statut (*Toutes*, *En cours*, *Terminées*).
- Filtrer par niveau d'importance (*Basse*, *Moyenne*, *Haute*).

---

## 🌓 Personnalisation : Thème Sombre / Clair
Cliquez sur le bouton **« 🌙 Mode Sombre »** en haut à droite pour basculer vers un contraste visuel reposant pour les yeux en environnement sombre. Votre préférence est automatiquement mémorisée.

---

## 📶 Utilisation Hors-Ligne (Offline)
- Lorsque vous perdez votre connexion réseau, le badge d'état affiche automatiquement **🟠 Mode Hors-Ligne**.
- Vous pouvez continuer à créer, cocher, modifier et supprimer vos tâches sans aucune interruption.
- Vos données sont conservées en toute sécurité dans la mémoire locale de votre appareil (`IndexedDB`).