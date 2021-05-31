import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_function_declaration.dart';
import 'pattern.dart';
import 'pattern_documentation.dart';

abstract class ObsoletePattern extends Pattern {
  const ObsoletePattern({
    required String id,
    required PatternDocumentation documentation,
  }) : super(
          id: id,
          documentation: documentation,
        );

  Iterable<Issue> legacyCheck(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    Map<String, Object> metricsConfig,
  );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source, Report report) => [];
}
