class ResponseModel {
  final String status;
  final String message;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? errors;

  ResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.errors,
  });

  // Factory constructor untuk membuat objek dari JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] ?? {},
      errors: json['errors'] ?? {},
    );
  }
}
