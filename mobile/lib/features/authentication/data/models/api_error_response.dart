class ApiErrorResponse {
  final String title;
  final int status;
  final String detail;
  final String instance;
  final String timestamp;
  final Map<String, dynamic>? invalidParams;

  const ApiErrorResponse({
    required this.title,
    required this.status,
    required this.detail,
    required this.instance,
    required this.timestamp,
    this.invalidParams,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      title: json["title"] ?? "",
      status: json["status"] ?? 0,
      detail: json["detail"] ?? "",
      instance: json["instance"] ?? "",
      timestamp: json["timestamp"] ?? "",
      invalidParams: json["invalidParams"],
    );
  }
}