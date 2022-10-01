import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';

import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import 'metric.dart';

/// An interface for metrics that compute a value for a class node.
abstract class ClassMetric<T extends num> extends Metric<T> {
  /// Initialize a newly created [ClassMetric].
  const ClassMetric({
    required super.id,
    required super.documentation,
    required super.threshold,
    required super.levelComputer,
  });

  @override
  String? nodeType(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
  ) =>
      classDeclarations
          .firstWhereOrNull((declaration) => declaration.declaration == node)
          ?.type
          .toString();
}
