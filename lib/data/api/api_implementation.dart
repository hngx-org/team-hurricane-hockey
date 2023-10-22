import 'package:dio/dio.dart';
import 'package:team_hurricane_hockey/data/api/api_interceptor.dart';
import 'package:team_hurricane_hockey/services/game_dio_service/game_dio_service.dart';

abstract class ApiImplementation {
  final BaseOptions _options = BaseOptions(
    connectTimeout: const Duration(minutes: 1),
  );

  Dio _instance() {
    final dio = Dio(_options);

    return dio;
  }

  Dio _getDioWith({required List<Interceptor> interceptors}) {
    return _instance()..interceptors.addAll(interceptors);
  }

  GameDioService gameDioService() {
    return GameDioService(_getDioWith(interceptors: [ApiInterceptors()]));
  }
}
