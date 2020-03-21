import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

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
  static const Iterable<String> categories = ['Complexity'];
  static const int remediationPoints = 50000;

  final String checkName;
  final String description;
  final CodeClimateLocation location;
  final String fingerprint;

  const CodeClimateIssue._(
      this.checkName, this.description, this.location, this.fingerprint);

  factory CodeClimateIssue._create(
      String name, String desc, int startLine, int endLine, String fileName) {
    final locationLines = CodeClimateLocationLines(startLine, endLine);
    final location = CodeClimateLocation(fileName, locationLines);
    final fingerprint = md5
        .convert(utf8.encode('$name $desc $startLine $endLine $fileName'))
        .toString();
    return CodeClimateIssue._(name, desc, location, fingerprint);
  }

  factory CodeClimateIssue.linesOfCode(int startLine, int endLine, int value,
      String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has $value lines of code (exceeds $threshold allowed). Consider refactoring.';
    return CodeClimateIssue._create(
        'linesOfCode', desc, startLine, endLine, fileName);
  }

  factory CodeClimateIssue.cyclomaticComplexity(int startLine, int endLine,
      int value, String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has a Cyclomatic Complexity of $value (exceeds $threshold allowed). Consider refactoring.';
    return CodeClimateIssue._create(
        'cyclomaticComplexity', desc, startLine, endLine, fileName);
  }

  factory CodeClimateIssue.maintainabilityIndex(int startLine, int endLine,
      int value, String fileName, String functionName) {
    final desc =
        'Function `$functionName` has a Maintainability Index of $value (min 40 allowed). Consider refactoring.';
    return CodeClimateIssue._create(
        'maintainabilityIndex', desc, startLine, endLine, fileName);
  }

  factory CodeClimateIssue.numberOfArguments(int startLine, int endLine,
      int value, String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has $value number of arguments (exceeds $threshold allowed). Consider refactoring.';
    return CodeClimateIssue._create(
        'numberOfArguments', desc, startLine, endLine, fileName);
  }

  Map<String, Object> toJson() => {
        'type': type,
        'check_name': checkName,
        'description': description,
        'categories': categories,
        'location': location.toJson(),
        'remediation_points': remediationPoints,
        'fingerprint': fingerprint,
      };
}
