class AuthBaseResponse {
  AuthBaseResponse({
    this.data,
    this.error,
    this.message,
  });

  dynamic data;
  dynamic error;
  String? message;

  factory AuthBaseResponse.fromJson(Map<String, dynamic> json) {
    return AuthBaseResponse(
      data: json["data"],
      error: json["error"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "error": error,
        "message": message,
      };
}
