import 'package:travel_planner/component/enums.dart';
import 'package:travel_planner/data/api/api_implementation.dart';
import 'package:travel_planner/data/repositories/open_api/open_api_interface.dart';
import 'package:tuple/tuple.dart';

class OpenApiRepo extends ApiImp implements OpenApiRepoInterface {
  OpenApiRepo._();
  static final OpenApiRepo instance = OpenApiRepo._();
  @override
  Future<Tuple3<String?, ErrorType?, String?>> interactWithLogs(
    List<String> logs,
    String input,
  ) async {
    try {
      final result = await openApiService().chatInteractionWithLogs(
        {"history": logs, "user_input": input},
      );
      if (result.error == null) {
        return Tuple3(result.message, null, null);
      } else {
        if (result.error.toString().toLowerCase().contains("subscription required")) {
          return Tuple3(null, ErrorType.payment, result.message);
        }
        return Tuple3(null, null, result.message);
      }
    } catch (e) {
      return Tuple3(null, null, e.toString());
    }
  }

  @override
  Future<Tuple3<String?, ErrorType?, String?>> interactWithString(
    String input,
  ) async {
    try {
      final result = await openApiService().chatInteractionWithString(
        {"user_input": input},
      );
      if (result.error == null) {
        return Tuple3(result.message, null, null);
      } else {
        if (result.error.toString().contains("subscription required")) {
          return Tuple3(null, ErrorType.payment, result.message);
        }
        return Tuple3(null, null, result.message);
      }
    } catch (e) {
      return Tuple3(null, null, e.toString());
    }
  }
}
