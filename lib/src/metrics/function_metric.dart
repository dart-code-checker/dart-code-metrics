import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../models/metric_documentation.dart';
import '../models/metric_value_level.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import 'metric.dart';

/// Interface for metrics whose compute value for function node.
abstract class FunctionMetric<T extends num> extends Metric<T> {
  /// Initialize a newly created [FunctionMetric].
  const FunctionMetric({
    @required String id,
    @required MetricDocumentation documentation,
    @required T threshold,
    @required MetricValueLevel Function(T, T) levelComputer,
  }) : super(
          id: id,
          documentation: documentation,
          threshold: threshold,
          levelComputer: levelComputer,
        );

  @override
  String nodeType(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  ) =>
      functionDeclarations
          .firstWhere(
            (declaration) => declaration.declaration == node,
            orElse: () => null,
          )
          ?.type
          ?.toString();
}
