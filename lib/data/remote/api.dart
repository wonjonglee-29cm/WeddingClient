import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/raw/signin_raw.dart';
import 'package:wedding/data/raw/user_info_raw.dart';
import 'package:wedding/data/remote/auth_interceptor.dart';

class Api {
  static const String baseUrl = 'http://localhost:8080';

  static Future<Dio> getDio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final dio = Dio(options);

    dio.interceptors.addAll([
      AuthInterceptor(prefs),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);

    return dio;
  }

  static Future<Response> signIn(SignInRaw request) async {
    final dio = await getDio();
    return dio.post('/api/member/sign-in', data: request.toJson());
  }

  static Future<Response> findMe(int id) async {
    final dio = await getDio();
    return dio.get('/api/member/find-me', queryParameters: {'id': id});
  }

  static Future<Response> updateMember(UserInfoRaw request) async {
    final dio = await getDio();
    return dio.patch('/api/member/update', data: request.toJson());
  }

  static Future<Response> refreshToken(int id, String refreshToken) async {
    final dio = await getDio();
    return dio.post('/api/member/refresh-token', data: {
      'id': id,
      'refreshToken': refreshToken,
    });
  }
}
