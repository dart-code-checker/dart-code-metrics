import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import '../models/config.dart';
import '../models/design_issue.dart';
import '../models/source.dart';
import '../scope_ast_visitor.dart';
import '../utils/metrics_analyzer_utils.dart';
import 'base_pattern.dart';

class LongParameterList extends BasePattern {
  static const String patternId = 'long-parameter-list';
  static const _documentationUrl = 'https://git.io/JUGrU';

  LongParameterList()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<DesignIssue> check(Source source, Config config) {
    final issues = <DesignIssue>[];

    final visitor = ScopeAstVisitor();
    source.compilationUnit.visitChildren(visitor);

    for (final function in visitor.functions) {
      final argumentsCount = getArgumentsCount(function);

      if (argumentsCount > config.numberOfArgumentsWarningLevel) {
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
          message: _compileMessage(args: argumentsCount),
          recommendation: _compileRecomendationMessage(
              maximumArguments: config.numberOfArgumentsWarningLevel),
        ));
      }
    }

    return issues;
  }

  String _compileMessage({@required int args}) =>
      'Long Parameter List. This method require $args arguments.';

  String _compileRecomendationMessage({@required int maximumArguments}) =>
      "Based on configuration of this package, we don't recommend writing a method with argument count more than $maximumArguments.";
}
