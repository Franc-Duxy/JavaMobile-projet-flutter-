import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/question.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  /// 🔧 Initialisation de la base
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // ⚠️ version 2 = permet l’upgrade automatique
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// 🏗️ Création de la base
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT,
        option4 TEXT,
        reponseCorrecte TEXT NOT NULL,
        image TEXT,
        difficulte TEXT
      )
    ''');
  }

  /// 🆙 Gestion des mises à jour de la base
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Si tu veux ajouter de nouvelles colonnes à l’avenir :
    if (oldVersion < 2) {
      // Vérifie si la colonne "difficulte" existe déjà avant de l’ajouter
      final columns = await db.rawQuery('PRAGMA table_info(questions)');
      final hasDifficulte = columns.any((c) => c['name'] == 'difficulte');

      if (!hasDifficulte) {
        await db.execute("ALTER TABLE questions ADD COLUMN difficulte TEXT;");
        print("✅ Colonne 'difficulte' ajoutée !");
      }
    }
  }

  /// 🔹 Insère une question
  Future<int> insertQuestion(Question question) async {
    final db = await instance.database;
    return await db.insert('questions', question.toMap());
  }

  /// 🔹 Récupère toutes les questions
  Future<List<Question>> getQuestions() async {
    final db = await instance.database;
    final maps = await db.query('questions');
    return maps.map((q) => Question.fromMap(q)).toList();
  }

  /// 🔹 Récupère les questions selon la difficulté
  Future<List<Question>> getQuestionsByDifficulty(String difficulte) async {
    final db = await instance.database;
    final maps = await db.query(
      'questions',
      where: 'difficulte = ?',
      whereArgs: [difficulte],
    );
    return maps.map((q) => Question.fromMap(q)).toList();
  }

  /// 🔹 Met à jour une question
  Future<int> updateQuestion(Question q) async {
    final db = await instance.database;
    return await db.update(
      'questions',
      q.toMap(),
      where: 'id = ?',
      whereArgs: [q.id],
    );
  }

  /// 🔹 Supprime une question
  Future<int> deleteQuestion(int id) async {
    final db = await instance.database;
    return await db.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  /// 🔹 Ferme la base proprement
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  /// 🌱 Initialise des données de base si la base est vide
  Future<void> seedData() async {
    final questions = await getQuestions();
    if (questions.isEmpty) {
      print("⚙️ Insertion des questions de base...");

      // ========== Facile (6 questions) ==========
      await insertQuestion(
        Question(
          question: "Qui est le frère de Sasuke ?",
          option1: "Itachi",
          option2: "Naruto",
          option3: "Kakashi",
          option4: "Gaara",
          reponseCorrecte: "Itachi",
          difficulte: "Facile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le rêve de Naruto ?",
          option1: "Devenir Hokage",
          option2: "Devenir pirate",
          option3: "Devenir roi des démons",
          option4: "Être ninja",
          reponseCorrecte: "Devenir Hokage",
          difficulte: "Facile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Comment s'appelle le chat de Happy dans Fairy Tail ?",
          option1: "Caramel",
          option2: "Happy",
          option3: "Natsu",
          option4: "Gray",
          reponseCorrecte: "Happy",
          difficulte: "Facile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Qui est le capitaine de l'équipe 7 dans Naruto ?",
          option1: "Itachi",
          option2: "Kakashi",
          option3: "Naruto",
          option4: "Sasuke",
          reponseCorrecte: "Kakashi",
          difficulte: "Facile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le fruit du démon de Luffy ?",
          option1: "Gomu Gomu",
          option2: "Mera Mera",
          option3: "Hito Hito",
          option4: "Pika Pika",
          reponseCorrecte: "Gomu Gomu",
          difficulte: "Facile",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Quel est l’animal de compagnie de Gon dans Hunter x Hunter ?",
          option1: "Kurapika",
          option2: "Killua",
          option3: "None",
          option4: "Ne se sépare jamais de son chien",
          reponseCorrecte: "None",
          difficulte: "Facile",
        ),
      );

      // ========== Moyen (10 questions) ==========
      await insertQuestion(
        Question(
          question: "Quel est le rêve de Luffy ?",
          option1: "Devenir Hokage",
          option2: "Devenir pirate",
          option3: "Devenir Roi des pirates",
          option4: "Être ninja",
          reponseCorrecte: "Devenir Roi des pirates",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Comment s'appelle la sœur adoptive de Edward Elric dans Fullmetal Alchemist ?",
          option1: "Winry",
          option2: "Alphonse",
          option3: "Riza",
          option4: "Trisha",
          reponseCorrecte: "Trisha",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Qui a créé le Death Note original ?",
          option1: "Ryuk",
          option2: "L",
          option3: "Light",
          option4: "Near",
          reponseCorrecte: "Ryuk",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le nom du titan colossal dans Attack on Titan ?",
          option1: "Eren",
          option2: "Bertolt",
          option3: "Reiner",
          option4: "Armin",
          reponseCorrecte: "Bertolt",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le pouvoir de Killua dans Hunter x Hunter ?",
          option1: "Électricité",
          option2: "Eau",
          option3: "Feu",
          option4: "Foudre",
          reponseCorrecte: "Électricité",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Quel est le nom du dragon que Natsu cherche dans Fairy Tail ?",
          option1: "Igneel",
          option2: "Falkor",
          option3: "Shenron",
          option4: "Dragneel",
          reponseCorrecte: "Igneel",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Qui est le rival de Gon dans Hunter x Hunter ?",
          option1: "Kurapika",
          option2: "Leorio",
          option3: "Killua",
          option4: "Hisoka",
          reponseCorrecte: "Hisoka",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Comment s'appelle la mère de Luffy ?",
          option1: "Boa Hancock",
          option2: "Sabo",
          option3: "Monkey D. Luffy n’a pas de mère connue",
          option4: "Nami",
          reponseCorrecte: "Monkey D. Luffy n’a pas de mère connue",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Qui a créé l’Akatsuki dans Naruto ?",
          option1: "Pain",
          option2: "Itachi",
          option3: "Madara Uchiha",
          option4: "Kakashi",
          reponseCorrecte: "Madara Uchiha",
          difficulte: "Moyen",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le vrai nom de L dans Death Note ?",
          option1: "Luffy",
          option2: "L Lawliet",
          option3: "Light Yagami",
          option4: "Ryuk",
          reponseCorrecte: "L Lawliet",
          difficulte: "Moyen",
        ),
      );

      // ========== Difficile (10 questions) ==========
      await insertQuestion(
        Question(
          question: "Quel est le vrai nom de Light dans Death Note ?",
          option1: "L",
          option2: "Yagami Light",
          option3: "Ryuuk",
          option4: "Kira",
          reponseCorrecte: "Yagami Light",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le nom du village caché des nuages dans Naruto ?",
          option1: "Konoha",
          option2: "Kumogakure",
          option3: "Sunagakure",
          option4: "Kirigakure",
          reponseCorrecte: "Kumogakure",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Quel est le nom de l’attaque ultime de Erza Scarlet dans Fairy Tail ?",
          option1: "Heaven’s Wheel",
          option2: "Dragon Slayer",
          option3: "Red Hawk",
          option4: "Bankai",
          reponseCorrecte: "Heaven’s Wheel",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Quel est le nom de l’alter de Shoto Todoroki dans My Hero Academia ?",
          option1: "Ice & Fire",
          option2: "Half-Cold Half-Hot",
          option3: "Flame Ice",
          option4: "Explosion",
          reponseCorrecte: "Half-Cold Half-Hot",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Qui a tué Jiraiya dans Naruto ?",
          option1: "Pain",
          option2: "Sasuke",
          option3: "Kakashi",
          option4: "Orochimaru",
          reponseCorrecte: "Pain",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le nom complet de Mikasa dans Attack on Titan ?",
          option1: "Mikasa Ackerman",
          option2: "Mikasa Yeager",
          option3: "Mikasa Smith",
          option4: "Mikasa Arlert",
          reponseCorrecte: "Mikasa Ackerman",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le vrai nom de Sanji dans One Piece ?",
          option1: "Vinsmoke Sanji",
          option2: "Sanji Luffy",
          option3: "Sanji Zoro",
          option4: "Sanji Ace",
          reponseCorrecte: "Vinsmoke Sanji",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le nom du créateur de Hunter x Hunter ?",
          option1: "Yoshihiro Togashi",
          option2: "Eiichiro Oda",
          option3: "Masashi Kishimoto",
          option4: "Tite Kubo",
          reponseCorrecte: "Yoshihiro Togashi",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question:
              "Quel est le nom de l’attaque de Naruto qui combine le Rasengan et le Vent ?",
          option1: "Chidori",
          option2: "Rasenshuriken",
          option3: "Amaterasu",
          option4: "Katon",
          reponseCorrecte: "Rasenshuriken",
          difficulte: "Difficile",
        ),
      );
      await insertQuestion(
        Question(
          question: "Quel est le nom du Fullbring de Ichigo dans Bleach ?",
          option1: "Zangetsu",
          option2: "Bankai",
          option3: "Getsuga Tensho",
          option4: "Ichigo n’a pas de Fullbring",
          reponseCorrecte: "Ichigo n’a pas de Fullbring",
          difficulte: "Difficile",
        ),
      );

      print("✅ Données initiales insérées avec succès !");
    }
  }
}
