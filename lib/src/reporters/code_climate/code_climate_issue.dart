class CodeClimateIssue {
  static const String type = 'issue';
  static const Iterable<String> categories = ['Complexity'];
  static const int remediation_points = 50000;

  final String check_name;
  final String description;
  final CodeClimateLocation location;

  CodeClimateIssue._(this.check_name, this.description, this.location);

  factory CodeClimateIssue._create(String name, String desc, int startLine, int endLine, String fileName) {
    final position =
        CodeClimatePosition(CodeClimateLineColumnPosition(startLine), CodeClimateLineColumnPosition(endLine));
    final location = CodeClimateLocation(fileName, position);
    return CodeClimateIssue._(name, desc, location);
  }

  factory CodeClimateIssue.linesOfCode(
      int startLine, int endLine, String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has ${endLine - startLine} lines of code (exceeds $threshold allowed). Consider refactoring.';
    return CodeClimateIssue._create('linesOfCode', desc, startLine, endLine, fileName);
  }

  factory CodeClimateIssue.cyclomaticComplexity(
      int startLine, int endLine, int value, String fileName, String functionName, int threshold) {
    final desc =
        'Function `$functionName` has a Cyclomatic Complexity of $value (exceeds $threshold allowed). Consider refactoring.';
    return CodeClimateIssue._create('cyclomaticComplexity', desc, startLine, endLine, fileName);
  }

  factory CodeClimateIssue.maintainabilityIndex(
      int startLine, int endLine, double value, String fileName, String functionName) {
    final desc =
        'Function `$functionName` has a Maintainability Index of $value (min 40 allowed). Consider refactoring.';
    return CodeClimateIssue._create('maintainabilityIndex', desc, startLine, endLine, fileName);
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'type': type,
      'check_name': check_name,
      'categories': categories,
      'remediation_points': remediation_points,
      'description': description,
      'location': location.toJson(),
    };
  }
}

class CodeClimateIssueContent {
  final String body;

  CodeClimateIssueContent(this.body);

  Map<String, Object> toJson() {
    return <String, Object>{
      'body': body,
    };
  }
}

class CodeClimateLocation {
  final String path;
  final CodeClimatePosition positions;

  CodeClimateLocation(this.path, this.positions);

  Map<String, Object> toJson() {
    return <String, Object>{
      'path': path,
      'positions': positions.toJson(),
    };
  }
}

class CodeClimatePosition {
  final CodeClimateLineColumnPosition begin;
  final CodeClimateLineColumnPosition end;

  CodeClimatePosition(this.begin, this.end);

  Map<String, Object> toJson() {
    return <String, Object>{
      'begin': begin.toJson(),
      'end': end.toJson(),
    };
  }
}

class CodeClimateLineColumnPosition {
  final num line;

  CodeClimateLineColumnPosition(this.line);

  Map<String, Object> toJson() {
    return <String, Object>{
      'line': line,
      'column': 1,
    };
  }
}
