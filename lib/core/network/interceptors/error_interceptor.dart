import 'package:dio/dio.dart';

import '../network_exceptions.dart';

class ErrorMappingInterceptor extends Interceptor {
  const ErrorMappingInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapError(err);
    final mappedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: mapped,
      stackTrace: err.stackTrace,
      message: err.message,
    );
    handler.next(mappedError);
  }

  AppNetworkException _mapError(DioException err) {
    final response = err.response;
    final statusCode = response?.statusCode;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkTimeoutException(details: err);
      case DioExceptionType.connectionError:
        return NoConnectionException(details: err);
      case DioExceptionType.badResponse:
        return _mapStatusCode(statusCode, response?.data);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return UnknownNetworkException(details: err, statusCode: statusCode);
    }
  }

  AppNetworkException _mapStatusCode(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return ServerException(statusCode: statusCode, details: data);
      case 401:
        return UnauthorizedException(details: data);
      case 403:
        return ForbiddenException(details: data);
      case 404:
        return NotFoundException(details: data);
      case 422:
        return ValidationException(
          fieldErrors: _extractFieldErrors(data),
          details: data,
        );
      case 429:
        return RateLimitException(details: data);
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(statusCode: statusCode, details: data);
        }
        return UnknownNetworkException(statusCode: statusCode, details: data);
    }
  }

  Map<String, List<String>> _extractFieldErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map(
          (key, value) => MapEntry(
            key,
            value is List
                ? value.map((e) => e.toString()).toList()
                : [value.toString()],
          ),
        );
      }
    }
    return {};
  }
}
