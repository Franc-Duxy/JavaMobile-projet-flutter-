# simple_quiz_anime

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

voila mon structure :
lib/
 ├─ db/
 │    └─ database_helper.dart   ← gestion SQLite (CRUD)
 ├─ models/
 │    └─ question.dart          ← définition de la classe Question
 ├─ pages/
 │    └─ quiz_page.dart         ← écran principal du quiz
 ├─ main.dart                   ← point d’entrée de l’application
assets/
 └─ images/                     ← images pour les questions (optionnel)
pubspec.yaml                     ← configuration du projet
