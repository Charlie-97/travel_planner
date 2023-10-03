import 'package:travel_planner/component/enums.dart';
import 'package:tuple/tuple.dart';

abstract class OpenApiRepoInterface {
  Future<Tuple3<String?, ErrorType?, String?>> interactWithString(
    String input,
  );

  Future<Tuple3<String?, ErrorType?, String?>> interactWithLogs(
    List<String> logs,
    String input,
  );
}
