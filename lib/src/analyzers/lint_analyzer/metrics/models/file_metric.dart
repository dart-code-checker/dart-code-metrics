import 'package:analyzer/dart/ast/ast.dart';

import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import 'metric.dart';
import 'metric_value.dart';

/// An interface for metrics that compute a value for a file aka compilation unit node.
abstract class FileMetric<T extends num> extends Metric<T> {
  /// Initialize a newly created [FileMetric].
  const FileMetric({
    required super.id,
    required super.documentation,
    required super.threshold,
    required super.levelComputer,
  });

  @override
  bool supports(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) =>
      node is CompilationUnit;

  @override
  String? nodeType(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  ) =>
      'compilation unit';
}
