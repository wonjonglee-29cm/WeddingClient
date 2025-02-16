import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/signin_raw.dart';
import 'package:wedding/data/raw/token_raw.dart';
import 'package:wedding/data/raw/user_info_raw.dart';
import 'package:wedding/data/remote/api.dart';

class MemberRepository {
  final SharedPreferences _prefs;
  static const String _failedAttemptsKey = 'login_failed_attempts';
  static const String _lastAttemptTimeKey = 'login_last_attempt_time';

  MemberRepository(this._prefs);

  Future<TokenRaw> signIn(SignInRaw request) async {
    final response = await Api.signIn(request);
    final signInResponse = TokenRaw.fromJson(response.data);

    await _prefs.setInt('id', signInResponse.id);
    await _prefs.setString('name', request.name);
    await _prefs.setString('accessToken', signInResponse.accessToken);
    await _prefs.setString('refreshToken', signInResponse.refreshToken);

    // 로그인 성공 시 실패 기록 초기화
    await resetFailedAttempts();

    return signInResponse;
  }

  // 로그인 실패 횟수 증가
  Future<void> incrementFailedAttempts() async {
    final currentAttempts = _prefs.getInt(_failedAttemptsKey) ?? 0;
    await _prefs.setInt(_failedAttemptsKey, currentAttempts + 1);
    await _prefs.setString(_lastAttemptTimeKey, DateTime.now().toIso8601String());
  }

  // 실패 횟수 초기화
  Future<void> resetFailedAttempts() async {
    await _prefs.remove(_failedAttemptsKey);
    await _prefs.remove(_lastAttemptTimeKey);
  }

  // 현재 실패 횟수 조회
  int getFailedAttempts() {
    return _prefs.getInt(_failedAttemptsKey) ?? 0;
  }

  // 마지막 시도 시간 조회
  DateTime? getLastAttemptTime() {
    final timeStr = _prefs.getString(_lastAttemptTimeKey);
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  // 로그인 잠금 여부 확인
  bool isLoginLocked() {
    final attempts = getFailedAttempts();
    final lastAttempt = getLastAttemptTime();

    if (attempts >= 5 && lastAttempt != null) {
      const lockoutDuration = Duration(minutes: 1);
      final now = DateTime.now();

      // 1시간이 지났다면 실패 횟수 초기화
      if (now.difference(lastAttempt) >= lockoutDuration) {
        resetFailedAttempts();
        return false;
      }

      return true;
    }
    return false;
  }

  // 남은 잠금 시간 계산 (분:초)
  String? getRemainingLockoutTime() {
    final lastAttempt = getLastAttemptTime();
    if (!isLoginLocked() || lastAttempt == null) return null;

    final lockoutEnd = lastAttempt.add(Duration(hours: 1));
    final now = DateTime.now();
    final remaining = lockoutEnd.difference(now);

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    return '$minutes분 $seconds초';
  }

  Future<UserInfoRaw> update({
    required String guestType,
    required bool isAttendance,
    required bool isCompanion,
    required int? companionCount,
    required bool isMeal,
  }) async {
    final id = _prefs.getInt('id');
    final name = _prefs.getString('name');

    if (id == null || name == null) {
      throw Exception('사용자 정보가 없습니다');
    }

    final request = UserInfoRaw(
      id: id,
      name: name,
      guestType: guestType,
      isAttendance: isAttendance,
      isCompanion: isCompanion,
      companionCount: companionCount,
      isMeal: isMeal,
    );

    final response = await Api.updateMember(request);
    final info = UserInfoRaw.fromJson(response.data);

    return info;
  }

  Future<UserInfoRaw> findMe() async {
    final id = _prefs.getInt('id');
    if (id == null) throw Exception('ID not found');

    final response = await Api.findMe(id);
    return UserInfoRaw.fromJson(response.data);
  }

  Future<TokenRaw> refreshToken() async {
    final id = _prefs.getInt('id');
    final refreshToken = _prefs.getString('refreshToken');
    if (id == null) throw Exception('ID not found');
    if (refreshToken == null) throw Exception('RefreshToken not found');
    final response = await Api.refreshToken(id, refreshToken);
    final token = TokenRaw.fromJson(response.data);

    await _prefs.setInt('id', token.id);
    await _prefs.setString('accessToken', token.accessToken);
    await _prefs.setString('refreshToken', token.refreshToken);

    return token;
  }
}
