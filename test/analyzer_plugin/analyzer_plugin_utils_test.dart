@TestOn('vm')
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
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
        SourceLocation(offset,
            sourceUrl: Uri.parse(sourcePath), line: line, column: column),
        length,
        metricMessage,
        metricId);

    expect(fixes.error.severity, equals(AnalysisErrorSeverity.INFO));
    expect(fixes.error.type, equals(AnalysisErrorType.LINT));
    expect(fixes.error.location.file, equals(sourcePath));
    expect(fixes.error.location.offset, equals(5));
    expect(fixes.error.location.length, equals(length));
    expect(fixes.error.location.startLine, equals(line));
    expect(fixes.error.location.startColumn, equals(column));
    expect(fixes.error.message, equals(metricMessage));
    expect(fixes.error.code, equals(metricId));
    expect(fixes.error.correction, isNull);
    expect(fixes.error.url, isNull);
    expect(fixes.error.contextMessages, isNull);
    expect(fixes.error.hasFix, isFalse);
    expect(fixes.fixes, isEmpty);
  });
}
