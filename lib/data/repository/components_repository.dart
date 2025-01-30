import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/component_raw.dart';
import 'package:wedding/data/remote/static-api.dart';

class ComponentsRepository {
  final SharedPreferences _prefs;

  ComponentsRepository(this._prefs);

  Future<List<ComponentRaw>> getHomeItems() async {
    try {
      // StaticApi 호출
      final response = await StaticApi.getHome();
      final jsonString = jsonEncode(response.data);

      await _prefs.setString('home', jsonString);
      return _parseJsonToComponentRaw(jsonString);
    } catch (e) {
      // 에러 발생시 캐시된 데이터 사용
      final cachedJson = _prefs.getString('home');
      if (cachedJson != null) {
        return _parseJsonToComponentRaw(cachedJson);
      }
      rethrow;
    }
  }

  Future<List<ComponentRaw>> getInviteItems() async {
    try {
      // StaticApi 호출
      final response = await StaticApi.getInvite();
      final jsonString = jsonEncode(response.data);

      await _prefs.setString('invite', jsonString);
      return _parseJsonToComponentRaw(jsonString);
    } catch (e) {
      // 에러 발생시 캐시된 데이터 사용
      final cachedJson = _prefs.getString('invite');
      if (cachedJson != null) {
        return _parseJsonToComponentRaw(cachedJson);
      }
      rethrow;
    }
  }

  List<ComponentRaw> _parseJsonToComponentRaw(String jsonString) {
    final json = jsonDecode(jsonString);
    final items = json['items'] as List;

    return items
        .map((item) {
          switch (item['type']) {
            case 'banner':
              return BannerRaw.fromJson(item);
            case 'gate':
              return GateRaw.fromJson(item);
            case 'text':
              return TextRaw.fromJson(item);
            case 'couple-info':
              return CoupleInfoRaw.fromJson(item);
            case 'image':
              return ImageRaw.fromJson(item);
            case 'button':
              return ButtonRaw.fromJson(item);
            case 'account':
              return AccountRaw.fromJson(item);
            case 'line':
              return LineRaw.fromJson(item);
            case 'space':
              return SpaceRaw.fromJson(item);
            case 'color':
              return ColorRaw.fromJson(item);
            default:
              return null;
          }
        })
        .whereType<ComponentRaw>()
        .toList();
  }
}
