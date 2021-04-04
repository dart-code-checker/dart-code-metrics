import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../models/internal_resolved_unit_result.dart';

abstract class BasePattern {
  final String id;
  final Uri documentation;

  const BasePattern({
    required this.id,
    required this.documentation,
  });

  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    Map<String, Object> metricsConfig,
  );
}
