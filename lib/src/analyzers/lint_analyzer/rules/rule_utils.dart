import 'package:analyzer/dart/ast/ast.dart';
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
      host: 'dartcodemetrics.dev',
      pathSegments: [
        'docs',
        'rules',
        rule.type.value,
        rule.id,
      ],
    );

bool isEntrypoint(String name, NodeList<Annotation> metadata) =>
    name == 'main' || _hasPragmaAnnotation(metadata);

/// See https://github.com/dart-lang/sdk/blob/master/runtime/docs/compiler/aot/entry_point_pragma.md
bool _hasPragmaAnnotation(Iterable<Annotation> metadata) =>
    metadata.where((annotation) {
      final arguments = annotation.arguments;

      return annotation.name.name == 'pragma' &&
          arguments != null &&
          arguments.arguments
              .where((argument) =>
                  argument is SimpleStringLiteral &&
                  argument.stringValue == 'vm:entry-point')
              .isNotEmpty;
    }).isNotEmpty;
