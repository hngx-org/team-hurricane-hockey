import 'package:dio/dio.dart';

class Dummy extends Interceptor {}

class ApiInterceptors extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.cancel ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.badCertificate ||
        err.type == DioExceptionType.unknown) {
      handler.reject(err);
    } else if (err.response?.statusCode == 400 || err.response?.statusCode == 500 || (err.response?.statusCode ?? 400) > 399) {
      handler.resolve(
        Response<dynamic>(
          requestOptions: err.requestOptions,
          data: err.response?.data == null
              ? <String, dynamic>{}
              : (err.response?.data).runtimeType == String
                  ? <String, dynamic>{}
                  : err.response?.data,
          statusCode: err.response?.statusCode,
          statusMessage: err.response?.statusMessage,
        ),
      );
    }
  }
}
