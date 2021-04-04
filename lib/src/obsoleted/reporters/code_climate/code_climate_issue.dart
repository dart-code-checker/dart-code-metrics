import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../../../models/issue.dart';
import '../../../models/report.dart';
import '../../../models/severity.dart';

@immutable
class CodeClimateLocationLines {
  final int begin;
  final int end;

  const CodeClimateLocationLines(this.begin, this.end);

  Map<String, int> toJson() => {
        'begin': begin,
        'end': end,
      };
}

@immutable
class CodeClimateLocation {
  final String path;
  final CodeClimateLocationLines lines;

  const CodeClimateLocation(this.path, this.lines);

  Map<String, Object> toJson() => {
        'path': path,
        'lines': lines.toJson(),
      };
}

@immutable
class CodeClimateIssue {
  static const String type = 'issue';
  static const int remediationPoints = 50000;

  final String checkName;
  final String description;
  final Iterable<String> categories;
  final CodeClimateLocation location;
  final String severity;
  final String fingerprint;

  const CodeClimateIssue._(
    this.checkName,
    this.description,
    this.categories,
    this.location,
    this.severity,
    this.fingerprint,
  );

  factory CodeClimateIssue._create(
    String name,
    String desc,
    int startLine,
    int endLine,
    String fileName, {
    Iterable<String> categories = const ['Complexity'],
    String severity = 'info',
  }) {
    final locationLines = CodeClimateLocationLines(startLine, endLine);
    final location = CodeClimateLocation(fileName, locationLines);
    final fingerprint = md5
        .convert(utf8.encode('$name $desc $startLine $endLine $fileName'))
        .toString();

    return CodeClimateIssue._(
      name,
      desc,
      categories,
      location,
      severity,
      fingerprint,
    );
  }

  factory CodeClimateIssue.cyclomaticComplexity(
    Report function,
    int value,
    String fileName,
    String functionName,
    int threshold,
  ) =>
      CodeClimateIssue._create(
        'cyclomaticComplexity',
        'Function `$functionName` has a Cyclomatic Complexity of $value (exceeds $threshold allowed). Consider refactoring.',
        function.location.start.line,
        function.location.end.line,
        fileName,
      );

  factory CodeClimateIssue.maintainabilityIndex(
    Report function,
    int value,
    String fileName,
    String functionName,
  ) =>
      CodeClimateIssue._create(
        'maintainabilityIndex',
        'Function `$functionName` has a Maintainability Index of $value (min 40 allowed). Consider refactoring.',
        function.location.start.line,
        function.location.end.line,
        fileName,
      );

  factory CodeClimateIssue.maximumNestingLevel(
    Report function,
    int value,
    String fileName,
    String functionName,
    int threshold,
  ) =>
      CodeClimateIssue._create(
        'nestingLevel',
        'Function `$functionName` has a Nesting Level of $value (exceeds $threshold allowed). Consider refactoring.',
        function.location.start.line,
        function.location.end.line,
        fileName,
      );

  factory CodeClimateIssue.numberOfMethods(
    int startLine,
    int endLine,
    int value,
    String fileName,
    String componentName,
    int threshold,
  ) =>
      CodeClimateIssue._create(
        'numberOfMethods',
        'Component `$componentName` has $value number of methods (exceeds $threshold allowed). Consider refactoring.',
        startLine,
        endLine,
        fileName,
      );

  factory CodeClimateIssue.fromCodeIssue(Issue issue, String fileName) {
    const categoryHumanReadable = {
      Severity.error: ['Bug Risk'],
      Severity.warning: ['Bug Risk'],
      Severity.style: ['Style'],
      Severity.performance: ['Performance'],
      Severity.none: <String>[],
    };

    const severityHumanReadable = {
      Severity.error: 'critical',
      Severity.warning: 'major',
      Severity.style: 'minor',
      Severity.performance: 'minor',
      Severity.none: 'info',
    };

    return CodeClimateIssue._create(
      issue.ruleId,
      issue.message,
      issue.location.start.line,
      issue.location.start.line,
      fileName,
      categories: categoryHumanReadable[issue.severity]!,
      severity: severityHumanReadable[issue.severity]!,
    );
  }

  factory CodeClimateIssue.fromDesignIssue(Issue issue, String fileName) =>
      CodeClimateIssue._create(
        issue.ruleId,
        issue.message,
        issue.location.start.line,
        issue.location.start.line,
        fileName,
        categories: const ['Complexity'],
      );

  Map<String, Object> toJson() => {
        'type': type,
        'check_name': checkName,
        'description': description,
        'categories': categories,
        'location': location.toJson(),
        'remediation_points': remediationPoints,
        'severity': severity,
        'fingerprint': fingerprint,
      };
}
