import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/quiz_raw.dart';
import 'package:wedding/data/repository/quiz_repository.dart';

sealed class QuizState {
  const QuizState();
}

class Loading extends QuizState {
  const Loading();
}

class Success extends QuizState {
  final List<QuizRaw> items;
  final int currentPage;

  const Success({
    required this.items,
    this.currentPage = 0,
  });

  Success copyWith({
    List<int?>? answers,
    int? currentPage,
  }) {
    return Success(
      items: items,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class Done extends QuizState {
  const Done();
}

class QuizViewModel extends StateNotifier<QuizState> {
  final QuizRepository _repository;
  bool _isSubmitting = false; // API 통신 상태 추적 변수 추가
  bool get isSubmitting => _isSubmitting; // getter 추가

  QuizViewModel(this._repository) : super(const Loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = const Loading();
    try {
      final raw = await _repository.getQuizzes();
      if (raw.isAllDone) {
        state = const Done();
      } else {
        state = Success(items: raw.items, currentPage: raw.items.indexWhere((quiz) => !quiz.isDone));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void moveToNextPage() {
    if (state case Success s) {
      if (s.currentPage < s.items.length - 1) {
        state = s.copyWith(currentPage: s.currentPage + 1);
      }
    }
  }

  Future<bool> postQuizAnswer(int quizId, int answerOrder) async {
    if (_isSubmitting) return false;

    try {
      _isSubmitting = true;
      await _repository.submitQuizAnswer(quizId, answerOrder);

      if (state case Success s) {
        final updatedItems = s.items.map((quiz) {
          return quiz.id == quizId
              ? QuizRaw(
              id: quiz.id,
              question: quiz.question,
              options: quiz.options,
              isDone: true
          )
              : quiz;
        }).toList();

        if (updatedItems.every((quiz) => quiz.isDone)) {
          state = const Done();
          return true;
        }

        state = Success(
            items: updatedItems,
            currentPage: s.currentPage + 1
        );

        return false;
      }
      return false;
    } finally {
      _isSubmitting = false;
    }
  }
}
