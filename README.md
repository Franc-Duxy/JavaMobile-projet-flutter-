# 🎯 Quiz Anime - Application Flutter

Ce projet est une application mobile Flutter de quiz sur le thème des **animes japonais**.  
L’utilisateur choisit un niveau de difficulté (Facile, Moyen, Difficile), répond à des questions à choix multiples, et obtient son score à la fin du quiz.

---

## 🧩 Vue d’ensemble de l’architecture

Le projet est organisé en plusieurs couches, chacune ayant un rôle bien défini :

| Type | Fichier | Rôle principal |
|------|----------|----------------|
| 🏁 **Démarrage** | `main.dart` | Initialise l’application et la base de données |
| 🧱 **Base de données** | `db/database_helper.dart` | Crée et gère la base SQLite (ajout, lecture, mise à jour, suppression) |
| 📦 **Modèle** | `models/question.dart` | Définit la classe `Question`, représentant une ligne de la table SQLite |
| 🧭 **Interface** | `pages/difficulty_page.dart` | Page d’accueil : permet de choisir le niveau de difficulté |
| 🕹️ **Logique du jeu** | `pages/quiz_page.dart` | Gère le déroulement du quiz (affichage, réponses, score, transitions) |

### 🔗 Schéma de navigation
```

main.dart
↓
difficulty_page.dart (choix du niveau)
↓
quiz_page.dart (logique du quiz)
↳ database_helper.dart (lecture des questions SQLite)
↳ question.dart (modèle de données)

````

---

## ⚙️ **Fonctionnalités principales**

- 📚 Trois niveaux de difficulté : **Facile**, **Moyen**, **Difficile**  
- 💾 Stockage local via **SQLite**  
- 🧠 Mélange aléatoire des réponses à chaque question  
- ✅ Coloration dynamique :
  - Vert ✅ pour la bonne réponse
  - Rouge ❌ pour la mauvaise réponse  
- ⏩ Passage automatique à la question suivante  
- 🏁 Affichage du score final avec option “Rejouer” ou “Retour”

---

## 🧱 **Dépendances utilisées**

Voici les bibliothèques indispensables dans ton fichier `pubspec.yaml` :

```yaml
dependencies:
  flutter:
    sdk: flutter

  sqflite: ^2.3.0         # Gestion de la base de données SQLite
  path: ^1.9.0            # Gestion des chemins pour SQLite
````

> 💡 Tu peux ajouter d’autres dépendances (animations, sons, etc.) si tu veux enrichir le projet.

---

## 💻 **Exécution du projet dans VS Code**

### 1️⃣ Prérequis

Assure-toi d’avoir installé :

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [VS Code](https://code.visualstudio.com/)
* Les extensions suivantes :

  * **Flutter**
  * **Dart**
  * **SQLite Viewer** *(optionnel, pour visualiser la base locale)*

### 2️⃣ Installation des packages

Dans le terminal du projet :

```bash
flutter pub get
```

### 3️⃣ Lancer l’application

Branche un émulateur ou un téléphone Android, puis exécute :

```bash
flutter run
```

---

## 📁 **Structure du projet**

```
lib/
│
├── db/
│   └── database_helper.dart        # Gestion de la base SQLite
│
├── models/
│   └── question.dart               # Modèle de données Question
│
├── pages/
│   ├── difficulty_page.dart        # Sélection du niveau de difficulté
│   └── quiz_page.dart              # Logique et affichage du quiz
│
└── main.dart                       # Point d’entrée de l’application
```

---

## 🧠 **Architecture logique du quiz**

```
+---------------------------------------------+
|                QuizPage                     |
|---------------------------------------------|
|  - Charge les questions selon la difficulté |
|  - Mélange les réponses                    |
|  - Gère le score et les couleurs (vert/rouge)|
|  - Passe à la question suivante             |
+---------------------------------------------+
```

---

## 🏆 **Auteur**

👤 **Franc Duxy**
Étudiant en informatique passionné par le développement mobile avec Flutter.
📍 Projet : *Application mobile Quiz Anime*
📦 GitHub : [Franc-Duxy](https://github.com/Franc-Duxy)

---

## 📸 **Aperçu (optionnel)**

Tu peux ajouter ici des captures d’écran :

```
assets/
 ├── screenshot1.png
 ├── screenshot2.png
```

Et les référencer dans le README :

```markdown
![Page de difficulté](assets/screenshot1.png)
![Page de quiz](assets/screenshot2.png)
```

---

## 🧾 **Licence**

Ce projet est libre d’utilisation à des fins éducatives.
© 2025 Franc Duxy — Tous droits réservés.
