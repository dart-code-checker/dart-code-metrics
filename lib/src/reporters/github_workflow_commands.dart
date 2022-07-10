// ignore_for_file: public_member_api_docs

import 'package:source_span/source_span.dart';

// https://docs.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-a-warning-message

class GitHubWorkflowCommands {
  String warning(
    String message, {
    required String absolutePath,
    required SourceSpan sourceSpan,
  }) =>
      _construct(
        'warning',
        message,
        _params(
          absolutePath,
          sourceSpan.start.line,
          sourceSpan.start.column,
        ),
      );

  String error(
    String message, {
    required String absolutePath,
    required SourceSpan sourceSpan,
  }) =>
      _construct(
        'error',
        message,
        _params(
          absolutePath,
          sourceSpan.start.line,
          sourceSpan.start.column,
        ),
      );

  String _construct(
    String command,
    String message,
    Map<String, Object> parameters,
  ) {
    final buffer = StringBuffer('::$command');
    final params =
        parameters.entries.map((e) => '${e.key}=${e.value}').join(',').trim();
    if (params.isNotEmpty) {
      buffer.write(' $params');
    }

    buffer
      ..write('::')
      ..write(message);

    return buffer.toString();
  }

  Map<String, Object> _params(String file, int line, int column) => {
        'file': file,
        'line': line,
        'col': column,
      };
}
