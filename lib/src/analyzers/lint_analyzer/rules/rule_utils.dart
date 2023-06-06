import 'package:source_span/source_span.dart';

import '../models/issue.dart';
import '../models/replacement.dart';
import 'models/rule.dart';

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
      documentation: documentation(rule),
      location: location,
      severity: rule.severity,
      message: message,
      verboseMessage: verboseMessage,
      suggestion: replacement,
    );

/// Returns a url of a page containing documentation associated with [rule]
Uri documentation(Rule rule) => Uri(
      scheme: 'https',
      host: 'dcm.dev',
      pathSegments: [
        'docs',
        'rules',
        rule.type.value,
        rule.id,
      ],
    );
