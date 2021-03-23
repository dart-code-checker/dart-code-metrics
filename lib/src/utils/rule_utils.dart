import '../models/severity.dart';

/// Returns a [Severity] from [Map] based [config] otherwise [defaultValue]
Severity readSeverity(Map<String, Object> config, Severity defaultValue) =>
    Severity.fromString(config['severity'] as String) ?? defaultValue;

/// Returns the url of a page containing documentation associated with [ruleId]
Uri documentation(String ruleId) => Uri(
      scheme: 'https',
      host: 'dart-code-checker.github.io',
      pathSegments: ['dart-code-metrics', 'rules', '$ruleId.html'],
    );
