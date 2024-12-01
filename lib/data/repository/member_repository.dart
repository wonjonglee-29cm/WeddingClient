import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/signin_raw.dart';
import 'package:wedding/data/raw/token_raw.dart';
import 'package:wedding/data/raw/user_info_raw.dart';
import 'package:wedding/data/remote/api.dart';

class MemberRepository {
  final SharedPreferences _prefs;

  MemberRepository(this._prefs);

  Future<TokenRaw> signIn(SignInRaw request) async {
    final response = await Api.signIn(request);
    final signInResponse = TokenRaw.fromJson(response.data);

    await _prefs.setInt('id', signInResponse.id);
    await _prefs.setString('name', request.name);
    await _prefs.setString('phoneNumber', request.phoneNumber);
    await _prefs.setString('accessToken', signInResponse.accessToken);
    await _prefs.setString('refreshToken', signInResponse.refreshToken);

    return signInResponse;
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
    final phoneNumber = _prefs.getString('phoneNumber');

    if (id == null || name == null || phoneNumber == null) {
      throw Exception('사용자 정보가 없습니다');
    }

    final request = UserInfoRaw(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
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
