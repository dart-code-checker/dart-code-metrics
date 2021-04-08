import 'package:source_span/source_span.dart';

import '../models/issue.dart';
import '../models/replacement.dart';
import '../models/severity.dart';
import '../rules/rule.dart';

// ignore_for_file: long-parameter-list

/// Creates a new [Issue] found by [rule] in the [location] with [message] or
/// with [verboseMessage] describing the problem and with information how to fix
/// this one ([replacement]).
Issue createIssue({
  required Rule rule,
  required SourceSpan location,
  required String message,
  String? verboseMessage,
  Replacement? replacement,
}) =>
    Issue(
      ruleId: rule.id,
      documentation: documentation(rule.id),
      location: location,
      severity: rule.severity,
      message: message,
      verboseMessage: verboseMessage,
      suggestion: replacement,
    );

/// Returns a url of a page containing documentation associated with [ruleId]
Uri documentation(String ruleId) => Uri(
      scheme: 'https',
      host: 'dart-code-checker.github.io',
      pathSegments: ['dart-code-metrics', 'rules', '$ruleId.html'],
    );

/// Returns a [Severity] from map based [config] otherwise [defaultValue]
Severity readSeverity(Map<String, Object?> config, Severity defaultValue) =>
    Severity.fromString(config['severity'] as String?) ?? defaultValue;

/// Return a list of excludes from the given [config]
Iterable<String> readExcludes(Map<String, Object> config) {
  final data = config['exclude'];

  return _isIterableOfStrings(data)
      ? (data as Iterable).cast<String>()
      : const <String>[];
}

bool _isIterableOfStrings(Object? object) =>
    object is Iterable<Object> && object.every((node) => node is String);
