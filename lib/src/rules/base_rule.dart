import 'package:code_checker/analysis.dart';
import 'package:meta/meta.dart';

import '../models/code_issue.dart';
import '../models/source.dart';

abstract class BaseRule {
  final String id;
  final Uri documentation;
  final Severity severity;

  const BaseRule({
    @required this.id,
    @required this.documentation,
    @required this.severity,
  });

  Iterable<CodeIssue> check(Source source);
}
