import 'package:meta/meta.dart';

@immutable
class CodeClimateLineColumnPosition {
  final int line;

  const CodeClimateLineColumnPosition(this.line);

  Map<String, int> toJson() => {
        'line': line,
        'column': 1,
      };
}

@immutable
class CodeClimatePosition {
  final CodeClimateLineColumnPosition begin;
  final CodeClimateLineColumnPosition end;

  const CodeClimatePosition(this.begin, this.end);

  Map<String, Object> toJson() => {
        'begin': begin.toJson(),
        'end': end.toJson(),
      };
}

@immutable
class CodeClimateLocation {
  final String path;
  final CodeClimatePosition positions;

  const CodeClimateLocation(this.path, this.positions);

  Map<String, Object> toJson() => {
        'path': path,
        'positions': positions.toJson(),
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

  const CodeClimateIssue._(this.checkName, this.description, this.location);

  factory CodeClimateIssue._create(
      String name, String desc, int startLine, int endLine, String fileName) {
    final position = CodeClimatePosition(
        CodeClimateLineColumnPosition(startLine),
        CodeClimateLineColumnPosition(endLine));
    final location = CodeClimateLocation(fileName, position);
    return CodeClimateIssue._(name, desc, location);
  }

  factory CodeClimateIssue.linesOfCode(int startLine, int endLine,
      String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has ${endLine - startLine} lines of code (exceeds $threshold allowed). Consider refactoring.';
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
      double value, String fileName, String functionName) {
    final desc =
        'Function `$functionName` has a Maintainability Index of $value (min 40 allowed). Consider refactoring.';
    return CodeClimateIssue._create(
        'maintainabilityIndex', desc, startLine, endLine, fileName);
  }

  Map<String, Object> toJson() => {
        'type': type,
        'check_name': checkName,
        'categories': categories,
        'remediation_points': remediationPoints,
        'description': description,
        'location': location.toJson(),
      };
}
