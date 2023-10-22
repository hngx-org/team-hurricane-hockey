class BaseResponse {
  dynamic message;
  dynamic success;
  dynamic status;
  dynamic data;

  BaseResponse({
    this.message,
    this.success,
    this.status,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        message: json["message"],
        success: json["success"],
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "status": status,
        "data": data?.toJson(),
      };
}
