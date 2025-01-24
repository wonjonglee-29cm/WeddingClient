import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/repository/greeting_repository.dart';

class GreetingViewModel extends StateNotifier<AsyncValue<void>> {
  final GreetingRepository _repository;

  GreetingViewModel(this._repository) : super(const AsyncValue.loading()) {
    getInitialData();
  }

  Future<void> getInitialData() async {
    state = await AsyncValue.guard(() => _repository.get());
  }

  Future<void> submitGreeting(String message) async {
    state = const AsyncValue.loading();
    try {
      await _repository.post(message);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
