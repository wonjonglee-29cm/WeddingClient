class QuizAnswersRaw {
  final List<QuizAnswerRaw> answers;

  QuizAnswersRaw({
    required this.answers,
  });

  factory QuizAnswersRaw.fromJson(Map<String, dynamic> json) {
    return QuizAnswersRaw(
      answers: (json['answers'] as List).map((item) => QuizAnswerRaw.fromJson(item)).toList(),
    );
  }
}

class QuizAnswerRaw {
  final int quizId;
  final int userOrder;
  final bool correct;

  QuizAnswerRaw({
    required this.quizId,
    required this.userOrder,
    required this.correct,
  });

  factory QuizAnswerRaw.fromJson(Map<String, dynamic> json) {
    return QuizAnswerRaw(
      quizId: json['quizId'] as int,
      userOrder: json['userOrder'] as int,
      correct: json['correct'] as bool,
    );
  }
}
