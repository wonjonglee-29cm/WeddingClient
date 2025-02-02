import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/repository/config_repository.dart';
import 'package:wedding/data/repository/greeting_repository.dart';

class MainState {
  final int currentIndex;
  final bool isWriteGreeting;
  final bool isDeploy;

  MainState({
    this.currentIndex = 0,
    this.isWriteGreeting = true,
    this.isDeploy = false,
  });

  MainState copyWith({
    int? currentIndex,
    bool? isWriteGreeting,
    bool? isDeploy,
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
      isWriteGreeting: isWriteGreeting ?? this.isWriteGreeting,
      isDeploy: isDeploy ?? this.isDeploy,
    );
  }
}

class MainViewModel extends StateNotifier<MainState> {
  final GreetingRepository _greetingRepository;
  final ConfigRepository _configRepository;

  MainViewModel(this._greetingRepository, this._configRepository) : super(MainState()) {
    _initGreetingState();
    _initDeployState();
  }

  Future<void> _initGreetingState() async {
    final greeting = await _greetingRepository.get();
    state = state.copyWith(isWriteGreeting: greeting != null);
  }

  Future<void> _initDeployState() async {
    final deployConfig = await _configRepository.getDeployConfig();
    state = state.copyWith(isDeploy: deployConfig.isDeploy);
  }

  void updateIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
