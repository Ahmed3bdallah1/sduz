import 'dart:async';

import 'package:dio/dio.dart';

import '../auth_token_provider.dart';

typedef ShouldAuthorize = bool Function(RequestOptions options);

/// Handles attaching bearer tokens and refreshing when a request fails with 401.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required AuthTokenProvider tokenProvider,
    Dio? dio,
    ShouldAuthorize? shouldAuthorize,
  })  : _tokenProvider = tokenProvider,
        _dio = dio,
        _shouldAuthorize = shouldAuthorize ?? _defaultShouldAuthorize;

  final AuthTokenProvider _tokenProvider;
  final ShouldAuthorize _shouldAuthorize;
  final Dio? _dio;

  static const String skipAuthExtraKey = 'skipAuth';
  static const String _retryFlag = 'retry_attempted';

  static bool _defaultShouldAuthorize(RequestOptions options) {
    final extra = options.extra;
    if (extra.containsKey(skipAuthExtraKey) && extra[skipAuthExtraKey] == true) {
      return false;
    }
    return true;
  }

  /// Adds a flag to the request to skip auth injection.
  static void markRequestAsPublic(RequestOptions options) {
    options.extra[skipAuthExtraKey] = true;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldAuthorize(options)) {
      final token = await _readTokenSafely();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptRefresh(err)) {
      return handler.next(err);
    }

    try {
      final refreshedToken = await _tokenProvider.refreshAccessToken();
      if (refreshedToken == null || refreshedToken.isEmpty) {
        return handler.next(err);
      }

      await _tokenProvider.saveAccessToken(refreshedToken);

      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
      requestOptions.extra[_retryFlag] = true;

      final dio = _dio ?? err.requestOptions.extra['dio_instance'] as Dio?;
      if (dio == null) {
        return handler.next(err);
      }

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      }
    } catch (_) {
      return handler.next(err);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    if (!_tokenProvider.canRefresh) return false;
    final response = err.response;
    if (response?.statusCode != 401) return false;
    final requestOptions = err.requestOptions;
    if (requestOptions.extra[_retryFlag] == true) return false;
    return _shouldAuthorize(requestOptions);
  }

  Future<String?> _readTokenSafely() async {
    try {
      return await Future.value(_tokenProvider.readAccessToken());
    } catch (_) {
      return null;
    }
  }
}
