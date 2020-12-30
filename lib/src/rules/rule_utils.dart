import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/rules.dart';

Issue createIssue(
  Rule rule,
  String message,
  String correction,
  String correctionComment,
  Uri sourceUrl,
  String sourceContent,
  CompilationUnit parsedContent,
  AstNode issueNode,
) =>
    Issue(
      ruleId: rule.id,
      documentation: rule.documentation,
      severity: rule.severity,
      location: nodeLocation(
        issueNode,
        ProcessedFile(sourceUrl, sourceContent, parsedContent),
      ),
      message: message,
      suggestion: correction != null && correctionComment != null
          ? Replacement(comment: correctionComment, replacement: correction)
          : null,
    );
