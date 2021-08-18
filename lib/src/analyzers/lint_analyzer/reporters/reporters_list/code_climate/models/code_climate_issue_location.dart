import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

@immutable
class CodeClimateIssueLocation {
  final String path;
  final SourceSpan location;

  const CodeClimateIssueLocation(this.path, this.location);

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
