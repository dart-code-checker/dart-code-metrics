import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/models/internal_resolved_unit_result.dart';
import 'package:meta/meta.dart';

import '../config/config.dart' as metrics;

abstract class BasePattern {
  final String id;
  final Uri documentation;

  const BasePattern({
    @required this.id,
    @required this.documentation,
  });

  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    metrics.Config config,
  );
}
