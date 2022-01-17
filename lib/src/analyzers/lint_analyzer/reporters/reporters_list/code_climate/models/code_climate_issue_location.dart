import 'package:source_span/source_span.dart';

/// Represents a Code Climate issue location.
class CodeClimateIssueLocation {
  final String path;
  final SourceSpan location;

  const CodeClimateIssueLocation(this.path, this.location);

  /// Converts the location to JSON format.
  Map<String, Object> toJson() => {
        'path': path,
        'positions': {
          'begin': {
            'line': location.start.line,
            'column': location.start.column,
          },
          'end': {
            'line': location.end.line,
            'column': location.end.column,
          },
        },
      };
}
