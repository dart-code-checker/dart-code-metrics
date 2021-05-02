import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';

/// An object that can be used to build a reports on classes and functions.
///
/// Clients may extend this class.
abstract class ReportsBuilder {
  /// Records [report] for class [declaration]
  void recordClass(ScopedClassDeclaration declaration, Report report);

  /// Records [report] for function [declaration]
  void recordFunction(ScopedFunctionDeclaration declaration, Report report);

  /// Records anti-pattern [issues]
  void recordAntiPatternCases(Iterable<Issue> issues);

  /// Records [issues]
  void recordIssues(Iterable<Issue> issues);
}
