import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/data/raw/user_info_raw.dart';
import 'package:wedding/data/repository/member_repository.dart';

class UserInfoState {
  final bool isLoading;
  final String? error;
  final UserInfoRaw? userInfo;

  UserInfoState({
    this.isLoading = false,
    this.error,
    this.userInfo,
  });

  UserInfoState copyWith({
    bool? isLoading,
    String? error,
    UserInfoRaw? userInfo,
  }) {
    return UserInfoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

class UserInfoViewModel extends StateNotifier<UserInfoState> {
  final MemberRepository _memberRepository;

  UserInfoViewModel(this._memberRepository) : super(UserInfoState());

  Future<bool> updateUserInfo({
    required String guestType,
    required bool isAttendance,
    required bool isCompanion,
    required int? companionCount,
    required bool isMeal,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _memberRepository.update(
          guestType: guestType,
          isAttendance: isAttendance,
          isCompanion: isCompanion,
          companionCount: companionCount,
          isMeal: isMeal);
      state = state.copyWith(userInfo: response, isLoading: false);

      return response.isUpdatedInfo();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }
}
