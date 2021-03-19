@TestOn('vm')
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:glob/glob.dart';
import 'package:mockito/mockito.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class AnalysisResultMock extends Mock implements AnalysisResult {}

void main() {
  group('isSupported returns', () {
    AnalysisResultMock analysisResultMock;

    setUp(() {
      analysisResultMock = AnalysisResultMock();
    });

    test('false on analysis result without path', () {
      expect(isSupported(analysisResultMock), isFalse);
    });
    test('true on dart files', () {
      when(analysisResultMock.path).thenReturn('lib/src/example.dart');

      expect(isSupported(analysisResultMock), isTrue);
    });
    test('false on generated dart files', () {
      when(analysisResultMock.path).thenReturn('lib/src/example.g.dart');

      expect(isSupported(analysisResultMock), isFalse);
    });
  });

  test('prepareExcludes returns exclude pattern ', () {
    expect(prepareExcludes(null, null), isEmpty);
    expect(
      prepareExcludes(
        ['example/**', 'test/resources/**'],
        '/home/developer/devs/my-project',
      ).map((glob) => glob.pattern),
      equals([
        '/home/developer/devs/my-project/example/**',
        '/home/developer/devs/my-project/test/resources/**',
      ]),
    );
  });

  test(
    'isExcluded returns true only for file path those matches with any exclude pattern',
    () {
      final analysisResultMock = AnalysisResultMock();
      when(analysisResultMock.path).thenReturn('lib/src/example.dart');

      expect(
        isExcluded(
          analysisResultMock,
          [Glob('test/**.dart'), Glob('lib/src/**.dart')],
        ),
        isTrue,
      );
      expect(
        isExcluded(
          analysisResultMock,
          [Glob('test/**.dart'), Glob('bin/**.dart')],
        ),
        isFalse,
      );
    },
  );

  test('designIssueToAnalysisErrorFixes constructs AnalysisErrorFixes', () {
    const sourcePath = 'source_file.dart';
    const offset = 5;
    const length = 4;
    const end = offset + length;
    const line = 2;
    const column = 1;
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
          sourceUrl: Uri.parse(sourcePath),
          line: line,
          column: column,
        ),
        SourceLocation(end, sourceUrl: Uri.parse(sourcePath)),
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
  });

  test(
    'metricReportToAnalysisErrorFixes constructs AnalysisErrorFixes from metric report',
    () {
      const sourcePath = 'source_file.dart';
      const offset = 5;
      const length = 4;
      const line = 2;
      const column = 1;
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
