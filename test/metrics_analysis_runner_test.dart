@TestOn('vm')
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/metrics_analysis_runner.dart';
import 'package:dart_code_metrics/src/metrics_analyzer.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MetricsAnalysisRecorderMock extends Mock
    implements MetricsAnalysisRecorder {}

class MetricsAnalyzerMock extends Mock implements MetricsAnalyzer {}

void main() {
  group('MetricsAnalysisRunner', () {
    test('results() returns MetricsAnalysisRecorder.runAnalysis', () {
      const stubRecords = [
        ComponentRecord(
            fullPath: 'lib/foo.dart',
            relativePath: 'foo.dart',
            functions: {},
            issues: []),
        ComponentRecord(
            fullPath: 'lib/bar.dart',
            relativePath: 'bar.dart',
            functions: {},
            issues: []),
      ];

      final recorder = MetricsAnalysisRecorderMock();
      when(recorder.records()).thenReturn(stubRecords);

      final runner = MetricsAnalysisRunner(recorder, MetricsAnalyzerMock(), []);

      expect(runner.results(), equals(stubRecords));
    });

    test('run() calls MetricsAnalyzer.runAnalysis for every file paths', () {
      const files = ['lib/foo.dart', 'lib/bar.dart'];
      const root = '/home/developer/project/';

      final analyzer = MetricsAnalyzerMock();

      final runner = MetricsAnalysisRunner(
          MetricsAnalysisRecorderMock(), analyzer, files,
          rootFolder: root);

      runner.run();

      verifyInOrder(
          [for (final path in files) analyzer.runAnalysis(path, root)]);
      verifyNoMoreInteractions(analyzer);
    });
  });
}
