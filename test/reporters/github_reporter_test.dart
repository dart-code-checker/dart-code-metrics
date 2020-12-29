@TestOn('vm')
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
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
            Issue(
              ruleId: 'patternId1',
              documentation: Uri.parse('https://docu.edu/patternId1.html'),
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              severity: Severity.none,
              message: 'first issue message',
              verboseMessage: 'recommendation',
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
            Issue(
              ruleId: 'ruleId1',
              documentation: Uri.parse('https://docu.edu/ruleId1.html'),
              severity: Severity.style,
              location: SourceSpanBase(
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
              suggestion: 'correction',
              suggestionComment: 'correction comment',
            ),
            Issue(
              ruleId: 'ruleId2',
              documentation: Uri.parse('https://docu.edu/ruleId2.html'),
              severity: Severity.error,
              location: SourceSpanBase(
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
              suggestion: 'correction',
              suggestionComment: 'correction comment',
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
