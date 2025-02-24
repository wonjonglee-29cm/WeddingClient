import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/signin_raw.dart';
import 'package:wedding/data/repository/config_repository.dart';
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

class NetworkError extends IntroState {
  const NetworkError();
}

class IntroViewModel extends StateNotifier<IntroState> {
  final MemberRepository _memberRepository;
  final ConfigRepository _configRepository;

  IntroViewModel(this._memberRepository, this._configRepository) : super(const RequiredLogin());

  Future<void> checkLoginState() async {
    try {
      final userInfo = await _memberRepository.findMe();
      if (!userInfo.isUpdatedInfo()) {
        state = const RequiredUserInfo();
      } else {
        state = const Pass();
      }
    } catch (e) {
      try {
        final deployConfig = await _configRepository.getDeployConfig();
        if (kIsWeb) {
          state = const RequiredLogin();
        } else if (deployConfig.isDeploy) {
          await _memberRepository.signIn(SignInRaw(name: deployConfig.testName, phoneNumber: deployConfig.testPhoneNumber));
          state = const Pass();
        } else {
          state = const RequiredLogin();
        }
      } on DioException {
        state = const NetworkError();
      }
    }
  }
}
