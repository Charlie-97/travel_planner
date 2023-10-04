import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:travel_planner/data/model/base_response.dart';

part 'open_api_service.g.dart';

@RestApi(baseUrl: "https://spitfire-interractions.onrender.com/api")
abstract class OpenApiService {
  factory OpenApiService(Dio dio, {String baseUrl}) = _OpenApiService;

  @POST("/chat")
  Future<BaseResponse> chatInteractionWithString(
    @Body() Map<String, dynamic> input,
  );

  @POST("/chat/completions")
  Future<BaseResponse> chatInteractionWithLogs(
    @Body() Map<String, dynamic> input,
  );
}
