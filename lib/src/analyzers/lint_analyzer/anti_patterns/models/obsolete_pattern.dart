import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import 'pattern.dart';
import 'pattern_documentation.dart';

abstract class ObsoletePattern extends Pattern {
  const ObsoletePattern({
    required String id,
    required PatternDocumentation documentation,
    required Severity severity,
  }) : super(
          id: id,
          documentation: documentation,
          severity: severity,
        );

  Iterable<Issue> legacyCheck(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
  );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source, Report report) => [];
}
