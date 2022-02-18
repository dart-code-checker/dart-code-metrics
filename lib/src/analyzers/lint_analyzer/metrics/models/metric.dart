import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import 'metric_computation_result.dart';
import 'metric_documentation.dart';
import 'metric_value.dart';
import 'metric_value_level.dart';

/// An interface to communicate with the metrics.
///
/// All metrics must extend this interface.
abstract class Metric<T extends num> {
  /// The id of the metric.
  final String id;

  /// The documentation associated with the metric.
  final MetricDocumentation documentation;

  /// The threshold value divides the space of a metric value into regions. The
  /// end user is informed about the measured entity based on the value region.
  final T? threshold;

  final MetricValueLevel Function(T, T?) _levelComputer;

  /// Initialize a newly created [Metric].
  const Metric({
    required this.id,
    required this.documentation,
    required this.threshold,
    required MetricValueLevel Function(T, T?) levelComputer,
  }) : _levelComputer = levelComputer;

  /// Returns true if the metric can be computed on this [node].
  bool supports(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) =>
      true;

  /// Returns the computed [MetricValue] for the given [node].
  MetricValue<T> compute(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    final result = computeImplementation(
      node,
      classDeclarations,
      functionDeclarations,
      source,
      otherMetricsValues,
    );

    final type = nodeType(node, classDeclarations, functionDeclarations) ?? '';

    return MetricValue<T>(
      metricsId: id,
      documentation: documentation,
      value: result.value,
      unitType: unitType(result.value),
      level: _levelComputer(result.value, threshold),
      comment: commentMessage(type, result.value, threshold),
      recommendation: recommendationMessage(type, result.value, threshold),
      context: result.context,
    );
  }

  /// Returns the internal metric model [MetricComputationResult] for the given [node].
  @protected
  MetricComputationResult<T> computeImplementation(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  );

  /// Returns the message for the user containing information about the computed value.
  @protected
  String commentMessage(String nodeType, T value, T? threshold);

  /// Returns the message for a user containing information about how the user
  /// can improve this value.
  @protected
  String? recommendationMessage(String nodeType, T value, T? threshold) => null;

  /// Returns human readable type of [node]
  @protected
  String? nodeType(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  );

  /// Returns the human readable unit type.
  @protected
  String? unitType(T value) => null;
}
