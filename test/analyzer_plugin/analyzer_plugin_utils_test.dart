@TestOn('vm')
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class AnalysisResultMock extends Mock implements AnalysisResult {}

void main() {
  const sourcePath = '/project/source_file.dart';
  const offset = 5;
  const length = 4;
  const line = 2;
  const column = 1;

  test(
    'codeIssueToAnalysisErrorFixes constructs AnalysisErrorFixes',
    () {
      const end = offset + length;
      const ruleId = 'rule id';
      const patternDocumentationUrl = 'https://www.example.com';
      const issueMessage = 'issue message';
      const issueRecommendationMessage = 'recommendation message';

      final fixes = codeIssueToAnalysisErrorFixes(
        Issue(
          ruleId: ruleId,
          documentation: Uri.parse(patternDocumentationUrl),
          location: SourceSpanBase(
            SourceLocation(
              offset,
              sourceUrl: Uri.file(sourcePath),
              line: line,
              column: column,
            ),
            SourceLocation(end, sourceUrl: Uri.file(sourcePath)),
            'abcd',
          ),
          severity: Severity.none,
          message: issueMessage,
          verboseMessage: issueRecommendationMessage,
        ),
        null,
      );

      expect(fixes.error.severity, equals(AnalysisErrorSeverity.INFO));
      expect(fixes.error.type, equals(AnalysisErrorType.LINT));
      expect(fixes.error.location.file, equals(sourcePath));
      expect(fixes.error.location.offset, equals(offset));
      expect(fixes.error.location, hasLength(length));
      expect(fixes.error.location.startLine, equals(line));
      expect(fixes.error.location.startColumn, equals(column));
      expect(fixes.error.message, equals(issueMessage));
      expect(fixes.error.code, equals(ruleId));
      expect(fixes.error.correction, equals(issueRecommendationMessage));
      expect(fixes.error.url, equals(patternDocumentationUrl));
      expect(fixes.error.contextMessages, isNull);
      expect(fixes.error.hasFix, isFalse);
      expect(fixes.fixes, isEmpty);
    },
    testOn: 'posix',
  );

  test(
    'designIssueToAnalysisErrorFixes constructs AnalysisErrorFixes',
    () {
      const end = offset + length;
      const patternId = 'pattern id';
      const patternDocumentationUrl = 'https://www.example.com';
      const issueMessage = 'diagnostic message';
      const issueRecommendationMessage = 'diagnostic recommendation message';

      final fixes = designIssueToAnalysisErrorFixes(Issue(
        ruleId: patternId,
        documentation: Uri.parse(patternDocumentationUrl),
        location: SourceSpanBase(
          SourceLocation(
            offset,
            sourceUrl: Uri.file(sourcePath),
            line: line,
            column: column,
          ),
          SourceLocation(end, sourceUrl: Uri.file(sourcePath)),
          'abcd',
        ),
        severity: Severity.none,
        message: issueMessage,
        verboseMessage: issueRecommendationMessage,
      ));

      expect(fixes.error.severity, equals(AnalysisErrorSeverity.INFO));
      expect(fixes.error.type, equals(AnalysisErrorType.HINT));
      expect(fixes.error.location.file, equals(sourcePath));
      expect(fixes.error.location.offset, equals(offset));
      expect(fixes.error.location, hasLength(length));
      expect(fixes.error.location.startLine, equals(line));
      expect(fixes.error.location.startColumn, equals(column));
      expect(fixes.error.message, equals(issueMessage));
      expect(fixes.error.code, equals(patternId));
      expect(fixes.error.correction, equals(issueRecommendationMessage));
      expect(fixes.error.url, equals(patternDocumentationUrl));
      expect(fixes.error.contextMessages, isNull);
      expect(fixes.error.hasFix, isFalse);
      expect(fixes.fixes, isEmpty);
    },
    testOn: 'posix',
  );

  test(
    'metricReportToAnalysisErrorFixes constructs AnalysisErrorFixes from metric report',
    () {
      const metricMessage = 'diagnostic message';
      const metricId = 'metric id';

      final fixes = metricReportToAnalysisErrorFixes(
        SourceLocation(
          offset,
          sourceUrl: Uri.parse(sourcePath),
          line: line,
          column: column,
        ),
        length,
        metricMessage,
        metricId,
      );

      expect(fixes.error.severity, equals(AnalysisErrorSeverity.INFO));
      expect(fixes.error.type, equals(AnalysisErrorType.LINT));
      expect(fixes.error.location.file, equals(sourcePath));
      expect(fixes.error.location.offset, equals(5));
      expect(fixes.error.location, hasLength(length));
      expect(fixes.error.location.startLine, equals(line));
      expect(fixes.error.location.startColumn, equals(column));
      expect(fixes.error.message, equals(metricMessage));
      expect(fixes.error.code, equals(metricId));
      expect(fixes.error.correction, isNull);
      expect(fixes.error.url, isNull);
      expect(fixes.error.contextMessages, isNull);
      expect(fixes.error.hasFix, isFalse);
      expect(fixes.fixes, isEmpty);
    },
  );
}
