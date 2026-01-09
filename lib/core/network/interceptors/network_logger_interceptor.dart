import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

typedef NetworkLogWriter = void Function(String message);

class NetworkLoggerInterceptor extends Interceptor {
  NetworkLoggerInterceptor({
    this.maxBodyCharacters = 2000,
    NetworkLogWriter? logWriter,
  }) : _logWriter = logWriter ?? _defaultWriter;

  final int maxBodyCharacters;
  final NetworkLogWriter _logWriter;

  static void _defaultWriter(String message) {
    developer.log(message, name: 'network');
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final buffer = StringBuffer()
      ..writeln('--> REQUEST [${options.method}]')
      ..writeln('Base URL: ${options.baseUrl}')
      ..writeln('Path: ${options.path}')
      ..writeln('Full URL: ${options.uri}')
      ..writeln('Headers: ${_stringifyMap(options.headers)}');

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln(
        'Query: ${_stringifyMap(options.queryParameters)}',
      );
    }

    if (options.data != null) {
      buffer.writeln('Body: ${_stringifyPayload(options.data)}');
    }

    _log(buffer.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final request = response.requestOptions;
    final buffer = StringBuffer()
      ..writeln(
        '<-- RESPONSE [${response.statusCode}] '
        '${request.method} ${request.path}',
      )
      ..writeln('Base URL: ${request.baseUrl}')
      ..writeln('From: ${response.realUri}')
      ..writeln('Headers: ${_stringifyMap(response.headers.map)}');

    if (response.data != null) {
      buffer.writeln('Body: ${_stringifyPayload(response.data)}');
    }

    _log(buffer.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final request = err.requestOptions;
    final buffer = StringBuffer()
      ..writeln(
        '!! ERROR [${err.type.name}] '
        '${request.method} ${request.path}',
      )
      ..writeln('Base URL: ${request.baseUrl}')
      ..writeln('Full URL: ${request.uri}')
      ..writeln('Message: ${err.message}');

    final response = err.response;
    if (response != null) {
      buffer
        ..writeln('Status: ${response.statusCode}')
        ..writeln('Headers: ${_stringifyMap(response.headers.map)}');
      if (response.data != null) {
        buffer.writeln('Body: ${_stringifyPayload(response.data)}');
      }
    }

    _log(buffer.toString());
    super.onError(err, handler);
  }

  void _log(String message) {
    _logWriter(message);
  }

  String _stringifyMap(Map<dynamic, dynamic>? value) {
    if (value == null || value.isEmpty) return '{}';
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  String _stringifyPayload(Object? value) {
    String serialized;
    if (value == null) {
      serialized = 'null';
    } else if (value is FormData) {
      serialized = _stringifyFormData(value);
    } else {
      serialized = _encodeJson(value) ?? value.toString();
    }
    return _truncate(serialized);
  }

  String _stringifyFormData(FormData formData) {
    final fields = <String, Object?>{
      for (final entry in formData.fields) entry.key: entry.value,
    };
    final files = <String, Object?>{
      for (final entry in formData.files)
        entry.key: entry.value.filename ?? 'file',
    };
    return _encodeJson({
          'fields': fields,
          'files': files,
        }) ??
        'FormData(fields: $fields, files: $files)';
  }

  String? _encodeJson(Object? value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return null;
    }
  }

  String _truncate(String value) {
    if (value.length <= maxBodyCharacters) {
      return value;
    }
    final remaining = value.length - maxBodyCharacters;
    final truncated = value.substring(0, maxBodyCharacters);
    return '$truncated... (+$remaining chars)';
  }
}
