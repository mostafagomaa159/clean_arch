import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkLoggerService {
  const NetworkLoggerService({
    this.enabled = kDebugMode,
    this.redactSecrets = true,
    this.maxBodyChars = 8000,
    this.maxStringChars = 300,
  });

  final bool enabled;

  final bool redactSecrets;

  final int? maxBodyChars;

  final int? maxStringChars;

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static const int _maxLineBytes = 700;

  static final RegExp _operationPattern = RegExp(
    r'\b(?:query|mutation)\s+(\w+)',
  );

  static String? operationName(String document) =>
      _operationPattern.firstMatch(document)?.group(1);

  void open(String title) => _emit('┌── $title');

  void line(String text) => _emit(text, '│ ');

  void close() => _emit('└${'─' * 40}');

  void section(String label, Object? body) {
    if (!enabled) return;

    line('$label:');

    for (final String bodyLine in _stringify(body).split('\n')) {
      line('  $bodyLine');
    }
  }

  void keyValue(String key, Object? value) {
    if (!enabled) return;

    line('  $key: ${_maskIfSecret(key, value)}');
  }

  String _maskIfSecret(String key, Object? value) {
    if (!redactSecrets) return '$value';

    final String lowerKey = key.toLowerCase();
    final bool isSecret =
        lowerKey.contains('authorization') ||
        lowerKey.contains('cookie') ||
        lowerKey.contains('token');

    if (!isSecret) return '$value';

    return '*** (${'$value'.length} chars)';
  }

  String _stringify(Object? body) {
    if (body is FormData) {
      final Map<String, Object?> fields = <String, Object?>{
        for (final MapEntry<String, String> entry in body.fields)
          entry.key: entry.value,
        for (final MapEntry<String, MultipartFile> entry in body.files)
          entry.key: '<file ${entry.value.filename ?? 'unnamed'}>',
      };

      return _truncate(_encode(_elide(fields)));
    }

    if (body is String) {
      try {
        return _truncate(_encode(_elide(jsonDecode(body))));
      } catch (_) {
        return _truncate(body);
      }
    }

    return _truncate(_encode(_elide(body)));
  }

  Object? _elide(Object? value) {
    final int? limit = maxStringChars;

    if (limit == null) return value;

    if (value is String) {
      final List<int> runes = value.runes.toList();

      if (runes.length <= limit) return value;

      return '${String.fromCharCodes(runes.take(limit))}'
          '… (+${runes.length - limit} more)';
    }

    if (value is Map) {
      return <String, Object?>{
        for (final MapEntry<Object?, Object?> entry in value.entries)
          '${entry.key}': _elide(entry.value),
      };
    }

    if (value is List) {
      return value.map(_elide).toList();
    }

    return value;
  }

  String _encode(Object? body) {
    try {
      return _encoder.convert(body);
    } catch (_) {
      return '$body';
    }
  }

  String _truncate(String text) {
    final int? limit = maxBodyChars;

    if (limit == null) return text;

    final List<int> runes = text.runes.toList();

    if (runes.length <= limit) return text;

    return '${String.fromCharCodes(runes.take(limit))}\n'
        '... truncated ${runes.length - limit} chars';
  }

  void _emit(String text, [String prefix = '']) {
    if (!enabled) return;

    for (final String chunk in _splitToLineBytes(text)) {
      debugPrint('$prefix$chunk');
    }
  }

  List<String> _splitToLineBytes(String text) {
    final List<String> chunks = <String>[];
    final StringBuffer buffer = StringBuffer();
    int bytes = 0;

    for (final int rune in text.runes) {
      final int size = _byteSizeOf(rune);

      if (bytes > 0 && bytes + size > _maxLineBytes) {
        chunks.add(buffer.toString());
        buffer.clear();
        bytes = 0;
      }

      buffer.writeCharCode(rune);
      bytes += size;
    }

    chunks.add(buffer.toString());

    return chunks;
  }

  int _byteSizeOf(int rune) {
    if (rune < 0x80) return 1;
    if (rune < 0x800) return 2;
    if (rune < 0x10000) return 3;

    return 4;
  }
}
