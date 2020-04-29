@TestOn('vm')
import 'package:analyzer/dart/analysis/results.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:mockito/mockito.dart';
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
}
