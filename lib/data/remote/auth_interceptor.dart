import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;

  AuthInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString('accessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.path.contains('api/member/refresh-token')) {
        return handler.next(err);
      }
      try {
        final id = prefs.getInt('id');
        final refreshToken = prefs.getString('refreshToken');

        if (id == null || refreshToken == null) {
          return handler.next(err);
        }

        // 토큰 갱신 요청
        final response = await Api.refreshToken(id, refreshToken);
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        await prefs.setString('accessToken', newAccessToken);
        await prefs.setString('refreshToken', newRefreshToken);

        // 실패했던 요청 재시도
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        final dio = await Api.getDio();
        final newResponse = await dio.fetch(options);
        return handler.resolve(newResponse);
      } catch (e) {
        // 토큰 갱신 실패시 로그아웃
        await prefs.clear();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}