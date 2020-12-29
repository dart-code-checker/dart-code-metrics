import 'package:code_checker/analysis.dart';
import 'package:meta/meta.dart';

abstract class BaseRule {
  final String id;
  final Uri documentation;
  final Severity severity;

  const BaseRule({
    @required this.id,
    @required this.documentation,
    @required this.severity,
  });

  Iterable<Issue> check(ProcessedFile source);
}
