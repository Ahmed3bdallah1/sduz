import 'package:dio/dio.dart';

class ApiResponse<T> {
  ApiResponse({
    required this.data,
    required this.raw,
  });

  final T? data;
  final Response<dynamic> raw;

  int? get statusCode => raw.statusCode;
  Headers get headers => raw.headers;
  Map<String, dynamic>? get extra => raw.extra;
}
