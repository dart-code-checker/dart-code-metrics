import 'package:analyzer/dart/ast/ast.dart';
import 'package:source_span/source_span.dart';

import '../../../base_visitors/source_code_visitor.dart';
import '../../../models/context_message.dart';
import '../../../models/entity_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/scoped_class_declaration.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metric_utils.dart';
import '../../models/function_metric.dart';
import '../../models/metric_computation_result.dart';
import '../../models/metric_documentation.dart';
import '../../models/metric_value.dart';

const _documentation = MetricDocumentation(
  name: 'Source lines of Code',
  shortName: 'SLOC',
  measuredType: EntityType.methodEntity,
  recommendedThreshold: 50,
);

/// Source lines of Code (SLOC)
///
/// This metric used to measure the size of a computer program by counting the
/// number of lines in the text of the program's source code. SLOC is typically
/// used to predict the amount of effort that will be required to develop a
/// program, as well as to estimate programming productivity or maintainability
/// once the software is produced.
class SourceLinesOfCodeMetric extends FunctionMetric<int> {
  static const String metricId = 'source-lines-of-code';

  SourceLinesOfCodeMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<int>(config, metricId),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    final visitor = SourceCodeVisitor(source.lineInfo);
    node.visitChildren(visitor);

    return MetricComputationResult(
      value: visitor.linesWithCode.length,
      context: _context(visitor.linesWithCode, source),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', exceeds the maximum of $threshold allowed'
        : '';
    final lines = '$value source ${value == 1 ? 'line' : 'lines'} of code';

    return 'This $nodeType has $lines$exceeds.';
  }

  @override
  String? recommendationMessage(String nodeType, int value, int? threshold) =>
      (threshold != null && value > threshold)
          ? 'Consider breaking this $nodeType up into smaller parts.'
          : null;

  @override
  String? unitType(int value) => value == 1 ? 'line' : 'lines';

  Iterable<ContextMessage> _context(
    Iterable<int> linesWithCode,
    InternalResolvedUnitResult source,
  ) =>
      linesWithCode.map((lineIndex) {
        final lineStartLocation = SourceLocation(
          source.lineInfo.getOffsetOfLine(lineIndex - 1),
          sourceUrl: source.path,
          line: lineIndex,
          column: 0,
        );

        return ContextMessage(
          message: 'line contains source code',
          location: SourceSpan(lineStartLocation, lineStartLocation, ''),
        );
      }).toList()
        ..sort((a, b) => a.location.start.compareTo(b.location.start));
}
