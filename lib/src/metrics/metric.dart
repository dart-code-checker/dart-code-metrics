import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../models/metric_documentation.dart';
import '../models/metric_value.dart';
import '../models/metric_value_level.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import 'metric_computation_result.dart';

/// Interface to communicate with the metrics.
///
/// All metric classes must extends from this interface.
abstract class Metric<T extends num> {
  /// The id of the metric.
  final String id;

  /// documentation associated with this metric.
  final MetricDocumentation documentation;

  /// A threshold value divides the space of a metric value into regions.
  /// Depending on the region a metric value is in, we can make an informed
  /// assessment about the measured entity.
  final T threshold;

  final MetricValueLevel Function(T, T) _levelComputer;

  /// Initialize a newly created [Metric].
  const Metric({
    @required this.id,
    @required this.documentation,
    @required this.threshold,
    @required MetricValueLevel Function(T, T) levelComputer,
  }) : _levelComputer = levelComputer;

  /// Returns true if the metric can be computed on this [node].
  bool supports(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) =>
      true;

  /// Returns computed [MetricValue] for given [node].
  MetricValue<T> compute(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) {
    final result = computeImplementation(
      node,
      classDeclarations,
      functionDeclarations,
      source,
    );

    final type = nodeType(node, classDeclarations, functionDeclarations) ?? '';

    return MetricValue<T>(
      metricsId: id,
      documentation: documentation,
      value: result.value,
      level: _levelComputer(result.value, threshold),
      comment: commentMessage(type, result.value, threshold),
      recommendation: recommendationMessage(type, result.value, threshold),
      context: result.context,
    );
  }

  /// Returns internal metric model [MetricComputationResult] for given [node].
  @protected
  MetricComputationResult<T> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  );

  /// Returns the message for a user containing information about computed value.
  @protected
  String commentMessage(String nodeType, T value, T threshold);

  /// Returns the message for a user containing information about how the user
  /// can improve this value.
  @protected
  String recommendationMessage(String nodeType, T value, T threshold) => null;

  /// Returns human readable type of [node]
  @protected
  String nodeType(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  );
}
