import 'package:meta/meta.dart';

import '../config/config.dart';
import '../lines_of_code/lines_with_code_ast_visitor.dart';
import '../models/design_issue.dart';
import '../models/function_type.dart';
import '../models/scoped_function_declaration.dart';
import '../models/source.dart';
import 'base_pattern.dart';
import 'pattern_utils.dart';

class LongMethod extends BasePattern {
  static const String patternId = 'long-method';
  static const _documentationUrl = 'https://git.io/JUIP7';

  LongMethod()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<DesignIssue> check(
    Source source,
    Iterable<ScopedFunctionDeclaration> functions,
    Config config,
  ) {
    final issues = <DesignIssue>[];

    for (final function in functions) {
      final linesWithCodeAstVisitor =
          LinesWithCodeAstVisitor(source.compilationUnit.lineInfo);
      function.declaration.visitChildren(linesWithCodeAstVisitor);

      if (linesWithCodeAstVisitor.linesWithCode.length >
          config.linesOfExecutableCodeWarningLevel) {
        issues.add(createIssue(
          this,
          _compileMessage(
            lines: linesWithCodeAstVisitor.linesWithCode.length,
            functionType: function.type,
          ),
          _compileRecommendationMessage(
            maximumLines: config.linesOfExecutableCodeWarningLevel,
            functionType: function.type,
          ),
          source,
          function.declaration,
        ));
      }
    }

    return issues;
  }

  String _compileMessage({@required int lines, FunctionType functionType}) =>
      'Long $functionType. This ${functionType.toString().toLowerCase()} contains $lines lines with executable code.';

  String _compileRecommendationMessage({
    @required int maximumLines,
    FunctionType functionType,
  }) =>
      "Based on configuration of this package, we don't recommend write a ${functionType.toString().toLowerCase()} longer than $maximumLines lines with executable code.";
}
