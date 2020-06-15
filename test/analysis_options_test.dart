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

const _contentWitMetricsRules = '''
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

const _contentWitMetricsRulesAsMap = '''
analyzer:
  plugins:
    - dart_code_metrics
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

dart_code_metrics:
  rules:
    double-literal-format: false
    newline-before-return: true
    no-boolean-literal-compare: false

linter:
  rules:
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
''';

const _contentWitMetricsThresholds = '''
analyzer:
  plugins:
    - dart_code_metrics
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

dart_code_metrics:
  metrics:
    cyclomatic-complexity: 20
    number-of-arguments: 4
  rules:
    - no-boolean-literal-compare

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

      expect(options.metricsConfig, isNull);
      expect(options.rulesNames, isEmpty);
    });

    group('content with metrics', () {
      test('rules defined as list', () {
        final options = AnalysisOptions.from(_contentWitMetricsRules);

        expect(options.metricsConfig, isNull);
        expect(options.rulesNames, equals(['double-literal-format']));
      });

      test('rules defined as map', () {
        final options = AnalysisOptions.from(_contentWitMetricsRulesAsMap);

        expect(options.metricsConfig, isNull);
        expect(options.rulesNames, equals(['newline-before-return']));
      });

      test('thresholds define', () {
        final options = AnalysisOptions.from(_contentWitMetricsThresholds);

        expect(
            options.metricsConfig.cyclomaticComplexityWarningLevel, equals(20));
        expect(options.metricsConfig.numberOfArgumentsWarningLevel, equals(4));
        expect(options.rulesNames, equals(['no-boolean-literal-compare']));
      });
    });
  });
}
