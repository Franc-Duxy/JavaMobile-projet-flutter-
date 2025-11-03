class Question {
  int? id;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String reponseCorrecte;
  String? image;
  String? difficulte; // niveau de difficulté

  Question({
    this.id,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.reponseCorrecte,
    this.image,
    this.difficulte,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'reponseCorrecte': reponseCorrecte,
      'image': image,
      'difficulte': difficulte,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      option1: map['option1'],
      option2: map['option2'],
      option3: map['option3'],
      option4: map['option4'],
      reponseCorrecte: map['reponseCorrecte'],
      image: map['image'],
      difficulte: map['difficulte'],
    );
  }

  bool isValid() {
    return question.isNotEmpty &&
        option1.isNotEmpty &&
        option2.isNotEmpty &&
        reponseCorrecte.isNotEmpty;
  }
}
