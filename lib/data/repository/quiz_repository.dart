import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/quiz_answers_raw.dart';
import 'package:wedding/data/raw/quiz_raw.dart';
import 'package:wedding/data/remote/api.dart';

class QuizRepository {
  final SharedPreferences _prefs;

  QuizRepository(this._prefs);

  Future<QuizzesRaw> getQuizzes() async {
    final userId = _prefs.getInt('id');
    assert(userId != null, 'User ID is null');

    final quizResponse = await Api.getQuizzes();
    final answersResponse = await Api.getAnswers(userId ?? 0);

    final answers = QuizAnswersRaw.fromJson(answersResponse.data);
    final quizzes = QuizzesRaw.fromJson(quizResponse.data, answers.answers.map((item) => item.quizId).toList());

    return quizzes;
  }

  Future<void> submitQuizAnswer(int quizId, int answerOrder) async {
    final userId = _prefs.getInt('id');
    assert(userId != null, 'User ID is null');

    await Api.postAnswer(QuizAnswerRequestRaw(quizId: quizId, userId: userId!, answerOrder: answerOrder));
  }
}
