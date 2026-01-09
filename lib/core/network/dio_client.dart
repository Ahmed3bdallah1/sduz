import 'package:dio/dio.dart';

import '../consts/app_constants.dart';
import 'api_request.dart';
import 'api_response.dart';
import 'auth_token_provider.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/network_logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_exceptions.dart';

class DioClient {
  DioClient({
    AuthTokenProvider? tokenProvider,
    BaseOptions? options,
    bool enableLogging = true,
    ShouldAuthorize? shouldAuthorize,
    List<Interceptor>? additionalInterceptors,
  })  : _tokenProvider = tokenProvider ?? const NullAuthTokenProvider(),
        _enableLogging = enableLogging,
        _shouldAuthorize = shouldAuthorize,
        _dio = Dio(
          options ??
              BaseOptions(
                baseUrl: AppConstants.baseUrl,
                connectTimeout: AppConstants.connectionTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
        ) {
    _configureInterceptors(additionalInterceptors: additionalInterceptors);
  }

  final Dio _dio;
  final bool _enableLogging;
  final ShouldAuthorize? _shouldAuthorize;
  final AuthTokenProvider _tokenProvider;

  Dio get raw => _dio;

  void _configureInterceptors({
    List<Interceptor>? additionalInterceptors,
  }) {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      AuthInterceptor(
        tokenProvider: _tokenProvider,
        dio: _dio,
        shouldAuthorize: _shouldAuthorize,
      ),
    );

    if (_enableLogging) {
      _dio.interceptors.add(
        NetworkLoggerInterceptor(),
      );
    }

    _dio.interceptors.add(const ErrorMappingInterceptor());
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
      ),
    );

    if (additionalInterceptors != null) {
      _dio.interceptors.addAll(additionalInterceptors);
    }
  }

  Options _prepareOptions(
    Options? options, {
    required bool requiresAuth,
  }) {
    final prepared = options == null ? Options() : _cloneOptions(options);
    prepared.extra ??= <String, dynamic>{};
    prepared.extra!['dio_instance'] = _dio;

    if (!requiresAuth) {
      prepared.extra![AuthInterceptor.skipAuthExtraKey] = true;
    }

    return prepared;
  }

  Options _cloneOptions(Options options) {
    final clonedHeaders = options.headers == null
        ? null
        : Map<String, Object?>.from(options.headers!);
    final clonedExtra = options.extra == null
        ? null
        : Map<String, Object?>.from(options.extra!);
    final cloned = options.copyWith(
      headers: clonedHeaders,
      extra: clonedExtra,
    );
    cloned.listFormat = options.listFormat;
    cloned.requestEncoder = options.requestEncoder;
    cloned.responseDecoder = options.responseDecoder;
    cloned.maxRedirects = options.maxRedirects;
    cloned.persistentConnection = options.persistentConnection;
    return cloned;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) {
    final prepared = _prepareOptions(
      options,
      requiresAuth: requiresAuth,
    );
    return _send(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: prepared,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) {
    final prepared = _prepareOptions(
      options,
      requiresAuth: requiresAuth,
    );
    return _send(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: prepared,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) {
    final prepared = _prepareOptions(
      options,
      requiresAuth: requiresAuth,
    );
    return _send(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: prepared,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) {
    final prepared = _prepareOptions(
      options,
      requiresAuth: requiresAuth,
    );
    return _send(
      () => _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: prepared,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) {
    final prepared = _prepareOptions(
      options,
      requiresAuth: requiresAuth,
    );
    return _send(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: prepared,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse<T>> send<T>(ApiRequest<T> request) async {
    final resolvedOptions = request.resolveOptions();
    final options = _prepareOptions(
      resolvedOptions,
      requiresAuth: request.requiresAuth,
    );
    final response = await _send<dynamic>(
      () => _dio.request<dynamic>(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: options,
        cancelToken: request.cancelToken,
        onReceiveProgress: request.onReceiveProgress,
        onSendProgress: request.onSendProgress,
      ),
    );

    final parser = request.parseResponse;
    Object? parsedData;
    if (parser != null) {
      parsedData = parser(response.data);
    } else {
      parsedData = response.data;
    }

    return ApiResponse<T>(
      data: parsedData as T?,
      raw: response,
    );
  }

  Future<Response<T>> _send<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      final mapped = error.error;
      if (mapped is AppNetworkException) {
        throw mapped;
      }
      throw UnknownNetworkException(
        statusCode: error.response?.statusCode,
        details: error,
      );
    }
  }
}
