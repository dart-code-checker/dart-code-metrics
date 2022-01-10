import 'package:dart_code_metrics/src/reporters/github_workflow_commands.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  const absolutePath = '/home/developer/project/source.dart';

  final location = SourceSpan(
    SourceLocation(
      1,
      sourceUrl: Uri.parse('file://$absolutePath'),
      line: 1,
      column: 2,
    ),
    SourceLocation(
      1,
      sourceUrl: Uri.parse('file://$absolutePath'),
      line: 3,
      column: 4,
    ),
    '',
  );

  group('GitHubWorkflowCommands', () {
    test('warning returns github error workflow command', () {
      final command = GitHubWorkflowCommands().error(
        'error message',
        absolutePath: absolutePath,
        sourceSpan: location,
      );

      expect(
        command,
        equals(
          '::error file=/home/developer/project/source.dart,line=1,col=2::error message',
        ),
      );
    });

    test('warning returns github warning workflow command', () {
      final command = GitHubWorkflowCommands().warning(
        'warning message',
        absolutePath: absolutePath,
        sourceSpan: location,
      );

      expect(
        command,
        equals(
          '::warning file=/home/developer/project/source.dart,line=1,col=2::warning message',
        ),
      );
    });
  });
}
