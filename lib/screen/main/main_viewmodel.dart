import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/repository/greeting_repository.dart';

class MainState {
  final int currentIndex;
  final bool isWriteGreeting;

  MainState({
    this.currentIndex = 0,
    this.isWriteGreeting = true,
  });

  MainState copyWith({
    int? currentIndex,
    bool? isWriteGreeting,
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
      isWriteGreeting: isWriteGreeting ?? this.isWriteGreeting,
    );
  }
}

class MainViewModel extends StateNotifier<MainState> {
  final GreetingRepository _repository;

  MainViewModel(this._repository) : super(MainState()) {
    _initGreetingState();
  }

  Future<void> _initGreetingState() async {
    final greeting = await _repository.get();
    state = state.copyWith(isWriteGreeting: greeting != null);
  }

  void updateIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
