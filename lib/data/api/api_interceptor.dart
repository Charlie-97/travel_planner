import 'package:dio/dio.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_in.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/services/local_storage/shared_prefs.dart';

class Dummy extends Interceptor {}

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    var token = AppStorage.instance.getToken();
    options.headers['Cookie'] = token.toString();
    return handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.cancel ||
        err.type == DioExceptionType.connectionError) {
      handler.reject(err);
    } else if (err.response?.statusCode == 500 || (err.response?.statusCode ?? 501) > 500) {
      // Server error
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
    } else if (err.response?.statusCode == 402) {
      // Payment Required
      handler.resolve(
        Response<dynamic>(
          requestOptions: err.requestOptions,
          data: err.response?.data == null
              ? <String, dynamic>{}
              : (err.response?.data).runtimeType == String
                  ? <String, dynamic>{}
                  : err.response?.data,
          statusMessage: "Payment Error",
        ),
      );
    } else if (err.response?.statusCode == 401) {
      // Expired Token
      AppStorage.instance.clearToken();
      BaseNavigator.pushNamedAndclear(SignInScreen.routeName);
    } else if (err.response?.statusCode == 406) {
      handler.resolve(
        Response<dynamic>(
          requestOptions: err.requestOptions,
          data: err.response?.data == null
              ? <String, dynamic>{}
              : (err.response?.data).runtimeType == String
                  ? <String, dynamic>{}
                  : err.response?.data,
        ),
      );
    } else if (err.response?.statusCode == 400 || (err.response?.statusCode ?? 400) > 399) {
      // Generic error code
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
