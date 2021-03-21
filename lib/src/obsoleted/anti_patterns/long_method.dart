// ignore_for_file: public_member_api_docs
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:meta/meta.dart';

import '../config/config.dart' as metrics;
import '../metrics/lines_of_executable_code/lines_of_executable_code_visitor.dart';
import '../models/internal_resolved_unit_result.dart';
import 'base_pattern.dart';
import 'pattern_utils.dart' as utils;

class LongMethod extends BasePattern {
  static const String patternId = 'long-method';
  static const _documentationUrl = 'https://git.io/JUIP7';

  LongMethod()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    metrics.Config config,
  ) {
    final issues = <Issue>[];

    for (final function in functions) {
      final visitor = LinesOfExecutableCodeVisitor(source.unit.lineInfo);
      function.declaration.visitChildren(visitor);

      if (visitor.linesWithCode.length >
          config.linesOfExecutableCodeWarningLevel) {
        issues.add(utils.createIssue(
          this,
          _compileMessage(
            lines: visitor.linesWithCode.length,
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
