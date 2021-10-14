import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';

import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import 'metric.dart';
import 'metric_documentation.dart';
import 'metric_value_level.dart';

/// An interface for metrics that compute a value for a function node.
abstract class FunctionMetric<T extends num> extends Metric<T> {
  /// Initialize a newly created [FunctionMetric].
  const FunctionMetric({
    required String id,
    required MetricDocumentation documentation,
    required T? threshold,
    required MetricValueLevel Function(T, T?) levelComputer,
  }) : super(
          id: id,
          documentation: documentation,
          threshold: threshold,
          levelComputer: levelComputer,
        );

  @override
  String? nodeType(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  ) =>
      functionDeclarations
          .firstWhereOrNull((declaration) => declaration.declaration == node)
          ?.type
          .toString();
}
