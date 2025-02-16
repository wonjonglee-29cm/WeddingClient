import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/signin_raw.dart';
import 'package:wedding/data/raw/user_info_raw.dart';
import 'package:wedding/data/repository/member_repository.dart';

class SignInState {
  final bool isLoading;
  final String? error;
  final bool isSignedIn;
  final bool hasInfo;

  SignInState({
    this.isLoading = false,
    this.error,
    this.isSignedIn = false,
    this.hasInfo = false,
  });

  SignInState copyWith({
    bool? isLoading,
    String? error,
    bool? isSignedIn,
    bool? hasInfo,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      hasInfo: hasInfo ?? this.hasInfo,
    );
  }
}

class SignInViewModel extends StateNotifier<SignInState> {
  final MemberRepository _repository;

  SignInViewModel(this._repository) : super(SignInState());

  Future<void> signIn(String name, String phoneNumber) async {
    // 로그인 잠금 상태 확인
    if (_repository.isLoginLocked()) {
      state = state.copyWith(
        error: '로그인 시도가 5회 실패하여 1시간 동안 로그인이 제한됩니다.\n남은 시간: ${_repository.getRemainingLockoutTime()}',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.signIn(
        SignInRaw(name: name, phoneNumber: phoneNumber),
      );
      UserInfoRaw info = await _repository.findMe();
      state = state.copyWith(
        isLoading: false,
        isSignedIn: true,
        hasInfo: info.isUpdatedInfo(),
      );
    } catch (e) {
      // 로그인 실패 횟수 증가
      await _repository.incrementFailedAttempts();

      // 현재 실패 횟수 확인
      final failedAttempts = _repository.getFailedAttempts();

      String errorMessage = '하객 정보가 없습니다. 신랑 혹은 신부에게 연락해주세요.';
      if (failedAttempts >= 5) {
        errorMessage = '로그인 시도가 5회 실패하여 1시간 동안 로그인이 제한됩니다.\n남은 시간: ${_repository.getRemainingLockoutTime()}';
      } else {
        errorMessage += '\n남은 시도 횟수: ${5 - failedAttempts}회';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        isSignedIn: false,
      );
    }
  }
}