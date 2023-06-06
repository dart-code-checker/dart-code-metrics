import 'package:source_span/source_span.dart';

import '../models/issue.dart';
import 'models/pattern.dart';

Issue createIssue({
  required Pattern pattern,
  required SourceSpan location,
  required String message,
  String? verboseMessage,
}) =>
    Issue(
      ruleId: pattern.id,
      documentation: documentation(pattern),
      location: location,
      severity: pattern.severity,
      message: message,
      verboseMessage: verboseMessage,
    );

/// Returns a url of a page containing documentation associated with [pattern]
Uri documentation(Pattern pattern) => Uri(
      scheme: 'https',
      host: 'dcm.dev',
      pathSegments: [
        'docs',
        'anti-patterns',
        pattern.id,
      ],
    );
