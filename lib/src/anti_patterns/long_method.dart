import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import '../lines_of_code/lines_with_code_ast_visitor.dart';
import '../models/config.dart';
import '../models/design_issue.dart';
import '../models/source.dart';
import '../scope_ast_visitor.dart';
import 'base_pattern.dart';

class LongMethod extends BasePattern {
  static const String patternId = 'long-method';
  static const _documentationUrl = 'https://git.io/JUIP7';

  LongMethod()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<DesignIssue> check(Source source, Config config) {
    final issues = <DesignIssue>[];

    final visitor = ScopeAstVisitor();
    source.compilationUnit.visitChildren(visitor);

    for (final function in visitor.functions) {
      final linesWithCodeAstVisitor =
          LinesWithCodeAstVisitor(source.compilationUnit.lineInfo);
      function.declaration.visitChildren(linesWithCodeAstVisitor);

      if (linesWithCodeAstVisitor.linesWithCode.length >
          config.linesOfExecutableCodeWarningLevel) {
        final offsetLocation = source.compilationUnit.lineInfo.getLocation(
            function.declaration.firstTokenAfterCommentAndMetadata.offset);
        final endLocation = source.compilationUnit.lineInfo
            .getLocation(function.declaration.end);

        issues.add(DesignIssue(
          patternId: id,
          patternDocumentation: documentation,
          sourceSpan: SourceSpanBase(
              SourceLocation(function.declaration.offset,
                  sourceUrl: source.url,
                  line: offsetLocation.lineNumber,
                  column: offsetLocation.columnNumber),
              SourceLocation(function.declaration.end,
                  sourceUrl: source.url,
                  line: endLocation.lineNumber,
                  column: endLocation.columnNumber),
              source.content.substring(
                  function.declaration.offset, function.declaration.end)),
          message: _compileMessage(
              lines: linesWithCodeAstVisitor.linesWithCode.length),
          recommendation: _compileRecomendationMessage(
              maximumLines: config.linesOfExecutableCodeWarningLevel),
        ));
      }
    }

    return issues;
  }

  String _compileMessage({@required int lines}) =>
      'Long Method. This method contains $lines lines with executable code.';

  String _compileRecomendationMessage({@required int maximumLines}) =>
      "Based on configuration of this package, we don't recommend write a method longer than $maximumLines lines with executable code.";
}
