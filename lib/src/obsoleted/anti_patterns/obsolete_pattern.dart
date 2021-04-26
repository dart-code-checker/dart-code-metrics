import 'package:analyzer/dart/analysis/results.dart';

import '../../anti_patterns/pattern.dart';
import '../../models/issue.dart';
import '../../models/pattern_documentation.dart';
import '../../models/report.dart';
import '../../models/scoped_function_declaration.dart';

abstract class ObsoletePattern extends Pattern {
  final Uri documentationUrl;

  const ObsoletePattern({
    required String id,
    required this.documentationUrl,
  }) : super(
          id: id,
          documentation: const PatternDocumentation(name: '', brief: ''),
        );

  Iterable<Issue> legacyCheck(
    ResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    Map<String, Object> metricsConfig,
  );

  @override
  Iterable<Issue> check(ResolvedUnitResult source, Report report) => [];
}
