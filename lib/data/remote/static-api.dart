import 'package:dio/dio.dart';

class StaticApi {
  static const String baseUrl = 'https://static-api.leewonjong.com';

  static Future<Dio> getDio() async {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );

    final dio = Dio(options);

    dio.interceptors.addAll([
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

  static Future<Response> getHome() async {
    final dio = await getDio();
    return dio.get('/home.json');
  }

  static Future<Response> getInvite() async {
    final dio = await getDio();
    return dio.get('/invite.json');
  }

  static Future<Response> getQuizSuccessLink() async {
    final dio = await getDio();
    return dio.get('/quiz.json');
  }
}
