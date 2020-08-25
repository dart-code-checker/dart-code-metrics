@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analysis_options.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/utils/yaml_utils.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

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
    - no-magic-number : {allowed-numbers: [1, 2, 3]}

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
    no-magic-number : {allowed-numbers: [1, 2, 3]}

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
    number-of-methods: 8
  rules:
    - no-boolean-literal-compare

linter:
  rules:
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
''';

const _contentWitMetricsThresholdsAndExcludes = '''
analyzer:
  exclude:
    - test/aggregated_vm_test.dart
    - lib/**/**.g.dart
    - lib/intl/**
    - test/**/**.g.dart
    - .git/**
    - .idea/**
  plugins:
    - dart_code_metrics
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

dart_code_metrics:
  metrics:
    cyclomatic-complexity: 20
    lines-of-code: 42
  metrics-exclude:
    - test/**
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
      final configFromNull = AnalysisOptions.fromMap(null);
      final configFromEmptyMap = AnalysisOptions.fromMap({});

      expect(configFromNull.metricsConfig, isNull);
      expect(configFromNull.metricsExcludePatterns, isEmpty);
      expect(configFromNull.rules, isEmpty);

      expect(configFromEmptyMap.metricsConfig, isNull);
      expect(configFromEmptyMap.metricsExcludePatterns, isEmpty);
      expect(configFromEmptyMap.rules, isEmpty);
    });

    test('content without metrics', () {
      final options =
          AnalysisOptions.fromMap(_yamlToDartMap(_contentWithoutMetrics));

      expect(options.metricsConfig, isNull);
      expect(options.metricsExcludePatterns, isEmpty);
      expect(options.rules, isEmpty);
    });

    group('content with metrics', () {
      test('rules defined as list', () {
        final options =
            AnalysisOptions.fromMap(_yamlToDartMap(_contentWitMetricsRules));

        expect(options.metricsConfig, isNull);
        expect(options.metricsExcludePatterns, isEmpty);
        expect(
            options.rules,
            equals({
              'double-literal-format': <String, Object>{},
              'no-magic-number': {
                'allowed-numbers': [1, 2, 3],
              },
            }));
      });

      test('rules defined as map', () {
        final options = AnalysisOptions.fromMap(
            _yamlToDartMap(_contentWitMetricsRulesAsMap));

        expect(options.metricsConfig, isNull);
        expect(options.metricsExcludePatterns, isEmpty);
        expect(
            options.rules,
            equals({
              'newline-before-return': <String, Object>{},
              'no-magic-number': {
                'allowed-numbers': [1, 2, 3],
              },
            }));
      });

      test('thresholds define', () {
        final options = AnalysisOptions.fromMap(
            _yamlToDartMap(_contentWitMetricsThresholds));

        expect(
            options.metricsConfig.cyclomaticComplexityWarningLevel, equals(20));
        expect(options.metricsConfig.numberOfArgumentsWarningLevel, equals(4));
        expect(options.metricsConfig.numberOfMethodsWarningLevel, equals(8));
        expect(options.metricsExcludePatterns, isEmpty);
        expect(options.rules,
            equals({'no-boolean-literal-compare': <String, Object>{}}));
      });

      test('exclude define', () {
        final options = AnalysisOptions.fromMap(
            _yamlToDartMap(_contentWitMetricsThresholdsAndExcludes));

        expect(
            options.metricsConfig.cyclomaticComplexityWarningLevel, equals(20));
        expect(options.metricsConfig.linesOfCodeWarningLevel, equals(42));
        expect(
            options.excludePatterns,
            equals([
              'test/aggregated_vm_test.dart',
              'lib/**/**.g.dart',
              'lib/intl/**',
              'test/**/**.g.dart',
              '.git/**',
              '.idea/**',
            ]));
        expect(options.metricsExcludePatterns, equals(['test/**']));
        expect(options.rules,
            equals({'no-boolean-literal-compare': <String, Object>{}}));
      });
    });

    test('file', () async {
      final options = await analysisOptionsFromFile(
          File('./test/resources/analysis_options_pkg.yaml'));

      expect(
          options.metricsConfig.cyclomaticComplexityWarningLevel, equals(20));
      expect(options.metricsConfig.linesOfCodeWarningLevel,
          equals(linesOfCodeDefaultWarningLevel));
      expect(options.metricsConfig.numberOfArgumentsWarningLevel, equals(4));
      expect(options.metricsConfig.numberOfMethodsWarningLevel,
          equals(numberOfMethodsDefaultWarningLevel));

      expect(options.excludePatterns, equals(['example/**']));
      expect(options.metricsExcludePatterns,
          equals(['test/**', 'documentation/**']));

      expect(options.rules.keys.length, equals(4));
      expect(
          options.rules.keys,
          containsAll(<String>[
            'no-empty-block',
            'no-boolean-literal-compare',
            'prefer-trailing-comma-for-collection',
            'member-ordering',
          ]));
    });
  });
}

Map<String, Object> _yamlToDartMap(String yaml) =>
    yamlMapToDartMap(loadYamlNode(yaml) as YamlMap);
