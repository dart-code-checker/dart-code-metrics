// ignore_for_file: long-parameter-list
import 'package:analyzer/dart/ast/ast.dart';
import 'package:source_span/source_span.dart';

import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import 'models/obsolete_pattern.dart';

Issue createIssue(
  ObsoletePattern pattern,
  String message,
  String recommendation,
  InternalResolvedUnitResult source,
  Declaration issueNode,
) {
  final offsetLocation = source.lineInfo
      .getLocation(issueNode.firstTokenAfterCommentAndMetadata.offset);
  final endLocation = source.lineInfo.getLocation(issueNode.end);

  return Issue(
    ruleId: pattern.id,
    documentation: pattern.documentationUrl,
    location: SourceSpanBase(
      SourceLocation(
        issueNode.offset,
        sourceUrl: source.sourceUri,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
      SourceLocation(
        issueNode.end,
        sourceUrl: source.sourceUri,
        line: endLocation.lineNumber,
        column: endLocation.columnNumber,
      ),
      source.content.substring(issueNode.offset, issueNode.end),
    ),
    severity: Severity.none,
    message: message,
    verboseMessage: recommendation,
  );
}

int getArgumentsCount(ScopedFunctionDeclaration dec) {
  final declaration = dec.declaration;

  int? argumentsCount;
  if (declaration is FunctionDeclaration) {
    argumentsCount =
        declaration.functionExpression.parameters?.parameters.length;
  } else if (declaration is MethodDeclaration) {
    argumentsCount = declaration.parameters?.parameters.length;
  }

  return argumentsCount ?? 0;
}
