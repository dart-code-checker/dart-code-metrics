import 'package:analyzer/dart/analysis/results.dart';

import '../../metrics/source_lines_of_code/source_code_visitor.dart';
import '../../models/function_type.dart';
import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../../utils/metric_utils.dart';
import '../constants.dart';
import 'obsolete_pattern.dart';
import 'pattern_utils.dart' as utils;

class LongMethod extends ObsoletePattern {
  static const String patternId = 'long-method';
  static const _documentationUrl = 'https://git.io/JUIP7';

  LongMethod()
      : super(id: patternId, documentationUrl: Uri.parse(_documentationUrl));

  @override
  Iterable<Issue> legacyCheck(
    ResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    Map<String, Object> metricsConfig,
  ) {
    final threshold = readThreshold<int>(
      metricsConfig,
      linesOfExecutableCodeKey,
      linesOfExecutableCodeDefaultWarningLevel,
    );

    final issues = <Issue>[];

    for (final function in functions) {
      final visitor = SourceCodeVisitor(source.unit!.lineInfo!);
      function.declaration.visitChildren(visitor);

      if (visitor.linesWithCode.length > threshold) {
        issues.add(utils.createIssue(
          this,
          _compileMessage(
            lines: visitor.linesWithCode.length,
            functionType: function.type,
          ),
          _compileRecommendationMessage(
            maximumLines: threshold,
            functionType: function.type,
          ),
          source,
          function.declaration,
        ));
      }
    }

    return issues;
  }

  String _compileMessage({required int lines, FunctionType? functionType}) =>
      'Long $functionType. This ${functionType.toString().toLowerCase()} contains $lines lines with executable code.';

  String _compileRecommendationMessage({
    required int maximumLines,
    FunctionType? functionType,
  }) =>
      "Based on configuration of this package, we don't recommend write a ${functionType.toString().toLowerCase()} longer than $maximumLines lines with executable code.";
}
