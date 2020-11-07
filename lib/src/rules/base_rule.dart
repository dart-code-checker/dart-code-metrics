import 'package:meta/meta.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';

abstract class BaseRule {
  final String id;
  final Uri documentation;
  final CodeIssueSeverity severity;

  const BaseRule({
    @required this.id,
    @required this.documentation,
    @required this.severity,
  });

  Iterable<CodeIssue> check(Source source);
}
