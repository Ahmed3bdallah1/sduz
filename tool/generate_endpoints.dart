import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final parser = _ArgumentParser();
  final config = parser.parse(args);
  if (config == null) {
    stderr.writeln(parser.usage);
    exitCode = 64;
    return;
  }

  final generator = EndpointGenerator(
    pathPrefix: config.pathPrefix,
    className: config.className,
  );

  for (final input in config.inputFiles) {
    await generator.addCollection(input);
  }

  final outputFile = File(config.outputPath);
  await outputFile.create(recursive: true);
  await outputFile.writeAsString(generator.build());

  stdout.writeln(
    'Generated ${generator.count} endpoints in ${config.outputPath}',
  );
}

class _ArgumentParser {
  GeneratorConfig? parse(List<String> args) {
    var outputPath = 'lib/core/consts/app_endpoints.dart';
    var className = 'AppEndpoints';
    var pathPrefix = '/api';
    final inputFiles = <String>[];

    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg == '--output' && i + 1 < args.length) {
        outputPath = args[++i];
      } else if (arg.startsWith('--output=')) {
        outputPath = arg.substring(arg.indexOf('=') + 1);
      } else if (arg == '--class' && i + 1 < args.length) {
        className = args[++i];
      } else if (arg.startsWith('--class=')) {
        className = arg.substring(arg.indexOf('=') + 1);
      } else if (arg == '--path-prefix' && i + 1 < args.length) {
        pathPrefix = args[++i];
      } else if (arg.startsWith('--path-prefix=')) {
        pathPrefix = arg.substring(arg.indexOf('=') + 1);
      } else if (arg == '--help' || arg == '-h') {
        return null;
      } else if (arg.startsWith('--')) {
        stderr.writeln('Unknown option: $arg');
        return null;
      } else {
        inputFiles.add(arg);
      }
    }

    if (inputFiles.isEmpty) {
      stderr.writeln('No Postman collection provided.');
      return null;
    }

    return GeneratorConfig(
      outputPath: outputPath,
      className: className,
      pathPrefix: pathPrefix,
      inputFiles: inputFiles,
    );
  }

  String get usage {
    return '''
Usage: dart run tool/generate_endpoints.dart [options] <postman_file>...

Options:
  --output=<path>        Output Dart file (default: lib/core/consts/app_endpoints.dart)
  --class=<ClassName>    Wrapper class name (default: AppEndpoints)
  --path-prefix=<path>   Prefix appended to every generated path (default: /api)
  -h, --help             Show this help text
''';
  }
}

class GeneratorConfig {
  GeneratorConfig({
    required this.outputPath,
    required this.className,
    required this.pathPrefix,
    required this.inputFiles,
  });

  final String outputPath;
  final String className;
  final String pathPrefix;
  final List<String> inputFiles;
}

class EndpointGenerator {
  EndpointGenerator({required String pathPrefix, required this.className})
    : pathPrefix = _normalizePrefix(pathPrefix);

  final String className;
  final String pathPrefix;
  final List<_Endpoint> _endpoints = <_Endpoint>[];
  final Set<String> _identifiers = <String>{};

  int get count => _endpoints.length;

  Future<void> addCollection(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('File not found: $filePath');
    }

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid Postman collection shape');
    }

    final info = decoded['info'];
    final collectionName = info is Map<String, dynamic>
        ? (info['name'] as String? ?? _basename(filePath))
        : _basename(filePath);
    final collectionKey = _deriveCollectionKey(filePath, collectionName);
    final items = decoded['item'];

    if (items is List<dynamic>) {
      _parseItems(
        items,
        collectionName: collectionName,
        collectionKey: collectionKey,
        parents: const <String>[],
      );
    }
  }

  String build() {
    final sorted = List<_Endpoint>.from(_endpoints)
      ..sort((a, b) => a.id.compareTo(b.id));
    final buffer = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// Generated via tool/generate_endpoints.dart')
      ..writeln()
      ..writeln('class AppEndpoint {')
      ..writeln('  final String id;')
      ..writeln('  final String name;')
      ..writeln('  final String method;')
      ..writeln('  final String path;')
      ..writeln('  final String collection;')
      ..writeln('  final List<String> groupPath;')
      ..writeln()
      ..writeln('  const AppEndpoint({')
      ..writeln('    required this.id,')
      ..writeln('    required this.name,')
      ..writeln('    required this.method,')
      ..writeln('    required this.path,')
      ..writeln('    required this.collection,')
      ..writeln('    required this.groupPath,')
      ..writeln('  });')
      ..writeln('}')
      ..writeln()
      ..writeln('class $className {')
      ..writeln('  const $className._();');

    for (final endpoint in sorted) {
      final docComment = _buildDocComment(endpoint);
      if (docComment != null) {
        buffer
          ..writeln()
          ..writeln('  /// $docComment');
      } else {
        buffer.writeln();
      }

      buffer
        ..writeln('  static const AppEndpoint ${endpoint.id} = AppEndpoint(')
        ..writeln("    id: '${endpoint.id}',")
        ..writeln("    name: '${_escape(endpoint.name)}',")
        ..writeln("    method: '${endpoint.method}',")
        ..writeln("    path: '${endpoint.path}',")
        ..writeln("    collection: '${_escape(endpoint.collectionName)}',")
        ..writeln('    groupPath: <String>[');

      for (final group in endpoint.groupPath) {
        buffer.writeln("      '${_escape(group)}',");
      }

      buffer
        ..writeln('    ],')
        ..writeln('  );');
    }

    buffer
      ..writeln()
      ..writeln('  static const List<AppEndpoint> values = <AppEndpoint>[');
    for (final endpoint in sorted) {
      buffer.writeln('    ${endpoint.id},');
    }
    buffer
      ..writeln('  ];')
      ..writeln('}');

    return buffer.toString();
  }

  void _parseItems(
    List<dynamic> items, {
    required String collectionName,
    required String collectionKey,
    required List<String> parents,
  }) {
    for (final item in items) {
      if (item is! Map<String, dynamic>) continue;
      final name = (item['name'] as String?)?.trim();
      final childItems = item['item'];
      if (childItems is List<dynamic>) {
        final newParents = List<String>.from(parents);
        if (name != null && name.isNotEmpty) {
          newParents.add(name);
        }
        _parseItems(
          childItems,
          collectionName: collectionName,
          collectionKey: collectionKey,
          parents: newParents,
        );
        continue;
      }

      final request = item['request'];
      if (request is! Map<String, dynamic>) continue;

      final method = (request['method'] as String? ?? 'GET').toUpperCase();
      final url = request['url'];
      final path = _normalizePath(url);
      if (path.isEmpty) continue;

      final displayName = name != null && name.isNotEmpty ? name : path;
      final identifier = _buildIdentifier(
        collectionKey: collectionKey,
        parents: parents,
        requestName: displayName,
      );

      _endpoints.add(
        _Endpoint(
          id: identifier,
          name: displayName,
          method: method,
          path: path,
          collectionName: collectionName,
          groupPath: List<String>.from(parents),
        ),
      );
    }
  }

  String _normalizePath(dynamic urlData) {
    String? raw;
    if (urlData is String) {
      raw = urlData;
    } else if (urlData is Map<String, dynamic>) {
      final rawValue = urlData['raw'];
      if (rawValue is String && rawValue.trim().isNotEmpty) {
        raw = rawValue;
      } else if (urlData['path'] is List<dynamic>) {
        final segments = (urlData['path'] as List<dynamic>)
            .whereType<String>()
            .where((segment) => segment.trim().isNotEmpty)
            .toList();
        if (segments.isNotEmpty) {
          raw = '/${segments.join('/')}';
        }
      }
    }

    raw ??= '/';
    raw = raw.trim();
    raw = _stripPlaceholder(raw);

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      final uri = Uri.parse(raw);
      raw = uri.path;
      if (uri.hasQuery) {
        raw = '${raw}?${uri.query}';
      }
    }

    if (raw.isEmpty) {
      raw = '/';
    }

    if (!raw.startsWith('/')) {
      raw = '/$raw';
    }

    raw = _collapseSlashes(raw);

    if (pathPrefix.isEmpty) {
      return raw;
    }

    if (_hasPrefix(raw, pathPrefix)) {
      return raw;
    }

    final combined = '$pathPrefix$raw';
    return _collapseSlashes(combined);
  }

  String _buildIdentifier({
    required String collectionKey,
    required List<String> parents,
    required String requestName,
  }) {
    final tokens = <String>[
      collectionKey,
      ...parents,
      requestName,
    ].expand(_tokenize).toList();

    if (tokens.isEmpty) {
      tokens.add('endpoint');
    }

    var identifier = _tokensToCamel(tokens);
    if (_identifiers.contains(identifier)) {
      var suffix = 2;
      final base = identifier;
      while (_identifiers.contains(identifier)) {
        identifier = '$base$suffix';
        suffix++;
      }
    }

    if (_startsWithDigit(identifier)) {
      identifier = '_$identifier';
    }

    _identifiers.add(identifier);
    return identifier;
  }

  static String _tokensToCamel(List<String> tokens) {
    if (tokens.isEmpty) {
      return 'endpoint';
    }
    final buffer = StringBuffer(tokens.first);
    for (var i = 1; i < tokens.length; i++) {
      final token = tokens[i];
      if (token.isEmpty) continue;
      buffer.write(token[0].toUpperCase());
      if (token.length > 1) {
        buffer.write(token.substring(1));
      }
    }
    return buffer.toString();
  }

  static Iterable<String> _tokenize(String input) sync* {
    final sanitized = input.replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ');
    for (final token in sanitized.split(' ')) {
      final trimmed = token.trim();
      if (trimmed.isEmpty) continue;
      yield trimmed.toLowerCase();
    }
  }

  static bool _startsWithDigit(String value) {
    return value.isNotEmpty &&
        value.codeUnitAt(0) >= 48 &&
        value.codeUnitAt(0) <= 57;
  }

  static String _stripPlaceholder(String value) {
    final placeholderPattern = RegExp(r'^\{\{[^}]+\}\}');
    return value.replaceFirst(placeholderPattern, '').trim();
  }

  static String _collapseSlashes(String value) {
    return value.replaceAll(RegExp(r'/{2,}'), '/');
  }

  static bool _hasPrefix(String value, String prefix) {
    if (value == prefix) return true;
    return value.startsWith('$prefix/');
  }

  static String _deriveCollectionKey(String filePath, String collectionName) {
    final lowerFileName = _basename(filePath).toLowerCase();
    if (lowerFileName.contains('customer')) return 'customer';
    if (lowerFileName.contains('technician')) return 'technician';
    final lowerCollection = collectionName.toLowerCase();
    if (lowerCollection.contains('customer')) return 'customer';
    if (lowerCollection.contains('technician')) return 'technician';
    return _tokenize(collectionName).join();
  }

  static String _basename(String filePath) {
    final parts = filePath.split(Platform.pathSeparator);
    final name = parts.isEmpty ? filePath : parts.last;
    final dotIndex = name.lastIndexOf('.');
    return dotIndex == -1 ? name : name.substring(0, dotIndex);
  }

  static String _normalizePrefix(String prefix) {
    if (prefix.isEmpty) {
      return '';
    }
    final trimmed = prefix.trim();
    if (trimmed == '/') {
      return '/';
    }
    return trimmed.startsWith('/') ? trimmed : '/$trimmed';
  }

  static String? _buildDocComment(_Endpoint endpoint) {
    final group = endpoint.groupPath.isEmpty
        ? ''
        : ' · ${endpoint.groupPath.join(' > ')}';
    if (group.isEmpty) {
      return '${endpoint.method} ${endpoint.path} · ${endpoint.collectionName}';
    }
    return '${endpoint.method} ${endpoint.path} · ${endpoint.collectionName}$group';
  }

  static String _escape(String value) {
    return value.replaceAll(r'$', r'\$').replaceAll("'", r"\'");
  }
}

class _Endpoint {
  _Endpoint({
    required this.id,
    required this.name,
    required this.method,
    required this.path,
    required this.collectionName,
    required this.groupPath,
  });

  final String id;
  final String name;
  final String method;
  final String path;
  final String collectionName;
  final List<String> groupPath;
}
