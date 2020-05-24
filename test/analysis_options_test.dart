@TestOn('vm')
import 'package:dart_code_metrics/src/analysis_options.dart';
import 'package:test/test.dart';

const _contentWithoutMetrics = '''
analyzer:
  plugins:
    - dart_code_metrics
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
''';

const _contentWitMetrics = '''
analyzer:
  plugins:
    - dart_code_metrics
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

dart_code_metrics:
  rules:
    - double-literal-format

linter:
  rules:
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
''';

void main() {
  group('AnalysisOptions from', () {
    test('empty content', () {
      expect(AnalysisOptions.from(null).rulesNames, isEmpty);
      expect(AnalysisOptions.from('').rulesNames, isEmpty);
    });

    test('content without metrics', () {
      final options = AnalysisOptions.from(_contentWithoutMetrics);

      expect(options.rulesNames, isEmpty);
    });

    test('content with metrics', () {
      final options = AnalysisOptions.from(_contentWitMetrics);

      expect(options.rulesNames, equals(['double-literal-format']));
    });
  });
}
