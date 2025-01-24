import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/greeting_raw.dart';
import 'package:wedding/data/remote/api.dart';

class GreetingRepository {
  final SharedPreferences _prefs;

  GreetingRepository(this._prefs);

  Future<String?> get() async {
    final userId = _prefs.getInt('id');
    assert(userId != null, 'User ID is null');
    final response = await Api.getGreeting(userId ?? 0);
    if (response.statusCode == 204) {
      return null;
    }
    return response.data['message'] as String;
  }

  Future<bool> post(String message) async {
    final userId = _prefs.getInt('id');
    assert(userId != null, 'User ID is null');

    final response = await Api.postGreeting(GreetingRaw(id: userId!, message: message));
    return response.statusCode == 200;
  }
}
