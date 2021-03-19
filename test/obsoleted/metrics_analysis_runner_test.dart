@TestOn('vm')
import 'package:dart_code_metrics/src/obsoleted/metrics_analysis_runner.dart';
import 'package:dart_code_metrics/src/obsoleted/metrics_analyzer.dart';
import 'package:dart_code_metrics/src/obsoleted/metrics_records_store.dart';
import 'package:dart_code_metrics/src/obsoleted/models/file_record.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MetricsRecordsStoreMock extends Mock implements MetricsRecordsStore {}

class MetricsAnalyzerMock extends Mock implements MetricsAnalyzer {}

void main() {
  group('MetricsAnalysisRunner', () {
    test('results() returns array of FileRecords', () {
      const stubRecords = [
        FileRecord(
          fullPath: 'lib/foo.dart',
          relativePath: 'foo.dart',
          components: {},
          functions: {},
          issues: [],
          designIssues: [],
        ),
        FileRecord(
          fullPath: 'lib/bar.dart',
          relativePath: 'bar.dart',
          components: {},
          functions: {},
          issues: [],
          designIssues: [],
        ),
      ];

      final store = MetricsRecordsStoreMock();
      when(store.records()).thenReturn(stubRecords);

      final runner =
          MetricsAnalysisRunner(MetricsAnalyzerMock(), store, const [], '');

      expect(runner.results(), equals(stubRecords));
    });

    test('run() calls MetricsAnalyzer.runAnalysis for every file paths', () {
      const folders = ['lib', 'test'];
      const root = '/home/developer/project/';

      final analyzer = MetricsAnalyzerMock();

      MetricsAnalysisRunner(analyzer, MetricsRecordsStoreMock(), folders, root)
          .run();

      verify(analyzer.runAnalysis(folders, root));
      verifyNoMoreInteractions(analyzer);
    });
  });
}
