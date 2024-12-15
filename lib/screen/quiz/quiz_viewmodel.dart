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
  final int count;
  final List<QuizRaw> items;
  final int currentPage;

  const Success({
    required this.count,
    required this.items,
    this.currentPage = 0,
  });

  Success copyWith({
    int? count,
    List<int?>? answers,
    int? currentPage,
  }) {
    return Success(
      count: count ?? this.count,
      items: items,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class QuizViewModel extends StateNotifier<QuizState> {
  final QuizRepository _repository;

  QuizViewModel(this._repository) : super(const Loading()) {
    loadItems();
  }

  Future<void> loadItems() async {
    state = const Loading();
    try {
      final raw = await _repository.getQuizzes();
      state = Success(count: raw.count, items: raw.items, currentPage: raw.items.indexWhere((quiz) => !quiz.isDone));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateCurrentPage(int page) {
    if (state case Success s) {
      state = s.copyWith(currentPage: page);
    }
  }
}
