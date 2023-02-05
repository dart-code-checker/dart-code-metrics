import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class ResolvedUnitResultMock extends Mock implements ResolvedUnitResult {}

void main() {
  const sourcePath = '/project/source_file.dart';
  const offset = 5;
  const length = 4;
  const line = 2;
  const column = 1;
  const end = offset + length;

  const documentationUrl = 'https://www.example.com';

  group('codeIssueToAnalysisErrorFixes constructs AnalysisErrorFixes', () {
    test(
      'with suggestions',
      () {
        const ruleId = 'rule id';
        const issueMessage = 'issue message';
        const issueRecommendationMessage = 'recommendation message';
        const suggestionMessage = 'suggestion message';
        const suggestionCode = '12345';

        final resolvedUnitResult = ResolvedUnitResultMock();

        when(() => resolvedUnitResult.exists).thenReturn(true);

        final fixes = codeIssueToAnalysisErrorFixes(
          Issue(
            ruleId: ruleId,
            documentation: Uri.parse(documentationUrl),
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
            suggestion: const Replacement(
              comment: suggestionMessage,
              replacement: suggestionCode,
            ),
          ),
          resolvedUnitResult,
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
        expect(fixes.error.correction, equals('recommendation message 12345'));
        expect(fixes.error.url, equals(documentationUrl));
        expect(fixes.error.contextMessages, isNull);
        expect(fixes.error.hasFix, isTrue);
        expect(fixes.fixes.single.priority, equals(1));
        expect(fixes.fixes.single.change.message, equals(suggestionMessage));
        expect(fixes.fixes.single.change.edits.single.file, equals(sourcePath));
        expect(fixes.fixes.single.change.edits.single.fileStamp, equals(0));
        expect(
          fixes.fixes.single.change.edits.single.edits.single.offset,
          equals(offset),
        );
        expect(
          fixes.fixes.single.change.edits.single.edits.single.length,
          equals(length),
        );
        expect(
          fixes.fixes.single.change.edits.single.edits.single.replacement,
          equals(suggestionCode),
        );
      },
      testOn: 'posix',
    );

    test(
      'without suggestions',
      () {
        const patternId = 'pattern id';
        const issueMessage = 'diagnostic message';
        const issueRecommendationMessage = 'diagnostic recommendation message';

        final fixes = codeIssueToAnalysisErrorFixes(
          Issue(
            ruleId: patternId,
            documentation: Uri.parse(documentationUrl),
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
        expect(fixes.error.code, equals(patternId));
        expect(fixes.error.correction, equals(issueRecommendationMessage));
        expect(fixes.error.url, equals(documentationUrl));
        expect(fixes.error.contextMessages, isNull);
        expect(fixes.error.hasFix, isFalse);
        expect(fixes.fixes, isEmpty);
      },
      testOn: 'posix',
    );
  });
}
