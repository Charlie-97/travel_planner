class BaseResponse {
  BaseResponse({
    this.error,
    this.message,
  });

  dynamic error;
  String? message;

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      error: json["error"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
