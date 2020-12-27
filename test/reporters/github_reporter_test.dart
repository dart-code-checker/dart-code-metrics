@TestOn('vm')
import 'package:code_checker/analysis.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/design_issue.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/github/github_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('GitHubReporter.report report about', () {
    const fullPath = '/home/developer/work/project/example.dart';

    test('files without any records', () {
      expect(GitHubReporter().report([]), isEmpty);
    });

    test('with design issues', () {
      final records = [
        FileRecord(
          fullPath: fullPath,
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{}),
          issues: const [],
          designIssues: [
            DesignIssue(
              patternId: 'patternId1',
              patternDocumentation:
                  Uri.parse('https://docu.edu/patternId1.html'),
              sourceSpan: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: 'first issue message',
              recommendation: 'recomendation',
            ),
          ],
        ),
      ];

      expect(
        GitHubReporter().report(records),
        equals([
          '::warning file=/home/developer/work/project/example.dart,line=2,col=3::first issue message',
        ]),
      );
    });

    test('with style severity issues', () {
      final records = [
        FileRecord(
          fullPath: fullPath,
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{}),
          issues: [
            CodeIssue(
              ruleId: 'ruleId1',
              ruleDocumentation: Uri.parse('https://docu.edu/ruleId1.html'),
              severity: Severity.style,
              sourceSpan: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: 'first issue message',
              correction: 'correction',
              correctionComment: 'correction comment',
            ),
            CodeIssue(
              ruleId: 'ruleId2',
              ruleDocumentation: Uri.parse('https://docu.edu/ruleId2.html'),
              severity: Severity.error,
              sourceSpan: SourceSpanBase(
                SourceLocation(
                  11,
                  sourceUrl: Uri.parse(fullPath),
                  line: 4,
                  column: 3,
                ),
                SourceLocation(17, sourceUrl: Uri.parse(fullPath)),
                'issue2',
              ),
              message: 'second issue message',
              correction: 'correction',
              correctionComment: 'correction comment',
            ),
          ],
          designIssues: const [],
        ),
      ];

      expect(
        GitHubReporter().report(records),
        equals([
          '::warning file=/home/developer/work/project/example.dart,line=2,col=3::first issue message',
          '::error file=/home/developer/work/project/example.dart,line=4,col=3::second issue message',
        ]),
      );
    });
  });
}
