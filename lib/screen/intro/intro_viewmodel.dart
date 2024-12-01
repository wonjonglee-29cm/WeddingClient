import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/repository/member_repository.dart';

sealed class IntroState {
  const IntroState();
}

class RequiredLogin extends IntroState {
  const RequiredLogin();
}

class RequiredUserInfo extends IntroState {
  const RequiredUserInfo();
}

class Pass extends IntroState {
  const Pass();
}

class IntroViewModel extends StateNotifier<IntroState> {
  final MemberRepository _repository;

  IntroViewModel(this._repository) : super(const RequiredLogin());

  Future<void> checkLoginState() async {
    try {
      final userInfo = await _repository.findMe();
      if (!userInfo.isUpdatedInfo()) {
        state = const RequiredUserInfo();
      } else {
        state = const Pass();
      }
    } catch (e) {
      state = const RequiredLogin();
    }
  }
}
