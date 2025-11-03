import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/question.dart';

class QuizPage extends StatefulWidget {
  final String difficulte;

  const QuizPage({super.key, required this.difficulte});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  List<Question> _questions = [];
  List<String> _currentOptions = []; // 🔹 options actuelles mélangées
  int _currentIndex = 0;
  int _score = 0;

  String? _selectedAnswer;
  bool _isAnswered = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadQuestions();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🔹 Charge les questions et initialise les options mélangées
  void _loadQuestions() async {
    final questions =
        await DatabaseHelper.instance.getQuestionsByDifficulty(widget.difficulte);
    questions.shuffle();

    setState(() {
      _questions = questions;
      _prepareOptions(); // prépare les premières réponses mélangées
    });

    _animationController.forward();
  }

  /// 🔹 Mélange les options de la question actuelle une seule fois
  void _prepareOptions() {
    final q = _questions[_currentIndex];
    _currentOptions = [
      q.option1,
      q.option2,
      q.option3,
      q.option4,
    ]..shuffle();
  }

  /// 🔹 Gère la réponse
  void _answer(String selected) {
    if (_isAnswered) return; // empêche le double-clic

    setState(() {
      _selectedAnswer = selected;
      _isAnswered = true;
    });

    if (selected == _questions[_currentIndex].reponseCorrecte) {
      _score++;
    }

    // ⏳ Attendre un peu avant de passer à la suivante
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentIndex < _questions.length - 1) {
        _animationController.reverse().then((_) {
          setState(() {
            _currentIndex++;
            _isAnswered = false;
            _selectedAnswer = null;
            _prepareOptions(); // 🔁 mélange les réponses de la nouvelle question
          });
          _animationController.forward();
        });
      } else {
        _showScore();
      }
    });
  }

  /// 🔹 Affiche le score final
  void _showScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Terminé 🎉"),
        content: Text("Votre score est $_score/${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // retour à la page de difficulté
            },
            child: const Text("Retour"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _isAnswered = false;
                _selectedAnswer = null;
                _prepareOptions();
              });
              _animationController.forward();
            },
            child: const Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz Anime")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final q = _questions[_currentIndex];

    Color getButtonColor(String option) {
      if (!_isAnswered) return Colors.orange.shade400;

      if (option == q.reponseCorrecte) {
        return Colors.green; // ✅ bonne réponse
      } else if (option == _selectedAnswer) {
        return Colors.red; // ❌ mauvaise réponse
      } else {
        return Colors.orange.shade400;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz ${widget.difficulte}"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
                backgroundColor: Colors.orange.shade100,
                color: Colors.orange,
                minHeight: 8,
              ),
              const SizedBox(height: 20),

              Text(
                "Question ${_currentIndex + 1}/${_questions.length}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              if (q.image != null)
                Image.asset(q.image!, height: 200, fit: BoxFit.cover),

              const SizedBox(height: 20),

              Text(
                q.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: _currentOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getButtonColor(option),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _answer(option),
                        child:
                            Text(option, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
