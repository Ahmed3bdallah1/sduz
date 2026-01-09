import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, patch, delete }

typedef ResponseParser<T> = T Function(dynamic data);

class ApiRequest<T> {
  ApiRequest({
    required this.path,
    required this.method,
    this.queryParameters,
    this.data,
    this.headers,
    this.options,
    this.requiresAuth = true,
    this.cancelToken,
    this.onReceiveProgress,
    this.onSendProgress,
    this.parseResponse,
  });

  final String path;
  final HttpMethod method;
  final Map<String, dynamic>? queryParameters;
  final Object? data;
  final Map<String, dynamic>? headers;
  final Options? options;
  final bool requiresAuth;
  final CancelToken? cancelToken;
  final ProgressCallback? onReceiveProgress;
  final ProgressCallback? onSendProgress;
  final ResponseParser<T>? parseResponse;

  Options resolveOptions() {
    final baseOptions = _cloneOptions(options);
    baseOptions.method = method.name.toUpperCase();
    final mergedHeaders = <String, dynamic>{};
    if (baseOptions.headers != null) {
      mergedHeaders.addAll(baseOptions.headers!);
    }
    if (headers != null) {
      mergedHeaders.addAll(headers!);
    }
    baseOptions.headers = mergedHeaders.isEmpty ? null : mergedHeaders;
    return baseOptions;
  }

  Options _cloneOptions(Options? options) {
    if (options == null) return Options();
    final newHeaders = options.headers == null
        ? null
        : Map<String, Object?>.from(options.headers!);
    final newExtra = options.extra == null
        ? null
        : Map<String, Object?>.from(options.extra!);
    final clone = options.copyWith(
      headers: newHeaders,
      extra: newExtra,
    );
    clone.listFormat = options.listFormat;
    clone.requestEncoder = options.requestEncoder;
    clone.responseDecoder = options.responseDecoder;
    clone.maxRedirects = options.maxRedirects;
    clone.persistentConnection = options.persistentConnection;
    return clone;
  }
}
