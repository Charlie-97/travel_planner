import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:travel_planner/data/api/api_interceptor.dart';
import 'package:travel_planner/services/open_api_service/open_api_service.dart';

abstract class ApiImp {
  final BaseOptions _options = BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
    followRedirects: true,
  );

  Dio _instance() {
    final dio = Dio(_options)
      ..interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printResponseData: true,
            printRequestData: true,
            printResponseMessage: true,
            printRequestHeaders: false,
            printResponseHeaders: false,
          ),
        ),
      );
    return dio;
  }

  Dio _getDioWith({required List<Interceptor> interceptors}) {
    return _instance()..interceptors.addAll(interceptors);
  }

  OpenApiService openApiService() {
    return OpenApiService(_getDioWith(interceptors: [ApiInterceptor()]));
  }
}
