import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';

typedef RetryEvaluator = bool Function(DioException error);

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.retryEvaluator,
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 400),
  }) : _dio = dio;

  final Dio _dio;
  final RetryEvaluator? retryEvaluator;
  final int maxAttempts;
  final Duration baseDelay;

  static const String _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra[_attemptKey] as int?) ?? 0;

    if (attempt >= maxAttempts || !_shouldRetry(err)) {
      return handler.next(err);
    }

    final delay = _calculateBackoff(attempt);
    await Future<void>.delayed(delay);

    final requestOptions = err.requestOptions;
    requestOptions.extra[_attemptKey] = attempt + 1;

    try {
      final response = await _dio.fetch(requestOptions);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException error) {
    if (retryEvaluator != null) {
      return retryEvaluator!(error);
    }

    final statusCode = error.response?.statusCode ?? 0;
    final method = error.requestOptions.method.toUpperCase();

    final isGet = method == 'GET';
    final isServerError = statusCode >= 500 && statusCode < 600;
    final isTimeout = error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;

    return isGet && (isServerError || isTimeout);
  }

  Duration _calculateBackoff(int attempt) {
    final multiplier = math.pow(2, attempt).toInt();
    return Duration(milliseconds: baseDelay.inMilliseconds * multiplier);
  }
}
