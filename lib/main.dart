import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'pages/difficulty_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseHelper.instance;
  await db.seedData(); // insère les questions de base si la base est vide

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Anime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DifficultyPage(), // page d’accueil du choix de difficulté
    );
  }
}
