import 'package:dart_code_metrics/src/analyzers/lint_analyzer/lint_config.dart';
import 'package:dart_code_metrics/src/cli/models/parsed_arguments.dart';
import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:test/test.dart';

const _options = AnalysisOptions('path', {
  'include': 'package:pedantic/analysis_options.yaml',
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['dart_code_metrics'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
  'dart_code_metrics': {
    'anti-patterns': {
      'anti-pattern-id1': true,
      'anti-pattern-id2': false,
      'anti-pattern-id3': true,
    },
    'metrics': {
      'metric-id1': '5',
      'metric-id2': '10',
      'metric-id3': '5',
      'metric-id4': '0',
    },
    'metrics-exclude': ['test/**', 'examples/**'],
    'rules': {'rule-id1': false, 'rule-id2': true, 'rule-id3': true},
    'rules-exclude': ['test/**', 'examples/**'],
  },
});

const _defaults = LintConfig(
  excludePatterns: ['test/resources/**'],
  excludeForMetricsPatterns: ['test/**'],
  metrics: {
    'metric-id1': '15',
    'metric-id2': '10',
    'metric-id3': '5',
  },
  excludeForRulesPatterns: ['test/**'],
  rules: {
    'rule-id1': {},
    'rule-id2': {'severity': 'info'},
  },
  antiPatterns: {
    'anti-patterns-id1': {},
  },
  shouldPrintConfig: false,
  analysisOptionsPath: '',
);

const _empty = LintConfig(
  excludePatterns: [],
  excludeForMetricsPatterns: [],
  metrics: {},
  excludeForRulesPatterns: [],
  rules: {},
  antiPatterns: {},
  shouldPrintConfig: false,
  analysisOptionsPath: '',
);

const _merged = LintConfig(
  excludePatterns: ['test/resources/**'],
  excludeForMetricsPatterns: ['test/**', 'examples/**'],
  metrics: {
    'metric-id1': '5',
    'metric-id2': '10',
    'metric-id3': '5',
    'metric-id4': '0',
  },
  excludeForRulesPatterns: ['test/**', 'examples/**'],
  rules: {
    'rule-id1': {},
    'rule-id2': {'severity': 'warning'},
  },
  antiPatterns: {
    'anti-patterns-id1': {},
    'anti-patterns-id2': {'severity': 'error'},
  },
  shouldPrintConfig: true,
  analysisOptionsPath: '',
);

const _overrides = LintConfig(
  excludePatterns: [],
  excludeForMetricsPatterns: ['examples/**'],
  metrics: {
    'metric-id1': '5',
    'metric-id4': '0',
  },
  excludeForRulesPatterns: ['examples/**'],
  rules: {
    'rule-id2': {'severity': 'warning'},
  },
  antiPatterns: {
    'anti-patterns-id2': {'severity': 'error'},
  },
  shouldPrintConfig: true,
  analysisOptionsPath: '',
);

void main() {
  group('LintConfig', () {
    group('fromAnalysisOptions constructs instance from passed', () {
      test('empty options', () {
        final config =
            LintConfig.fromAnalysisOptions(const AnalysisOptions(null, {}));

        expect(config.excludePatterns, isEmpty);
        expect(config.excludeForMetricsPatterns, isEmpty);
        expect(config.metrics, isEmpty);
        expect(config.excludeForRulesPatterns, isEmpty);
        expect(config.rules, isEmpty);
      });

      test('data', () {
        final config = LintConfig.fromAnalysisOptions(_options);

        expect(config.excludePatterns, equals(['test/resources/**']));
        expect(
          config.excludeForMetricsPatterns,
          equals(['test/**', 'examples/**']),
        );
        expect(
          config.metrics,
          equals({
            'metric-id1': '5',
            'metric-id2': '10',
            'metric-id3': '5',
            'metric-id4': '0',
          }),
        );
        expect(
          config.excludeForRulesPatterns,
          equals(['test/**', 'examples/**']),
        );
        expect(
          config.rules,
          equals({
            'rule-id2': <String, Object>{},
            'rule-id3': <String, Object>{},
          }),
        );
      });
    });

    group('fromArgs constructs instance from passed', () {
      test('empty arguments', () {
        final config = LintConfig.fromArgs(
          const ParsedArguments(
            excludePath: '',
            metricsConfig: {},
            rootFolder: '',
            shouldPrintConfig: false,
          ),
        );

        expect(config.excludePatterns, isEmpty);
        expect(config.excludeForMetricsPatterns, isEmpty);
        expect(config.metrics, isEmpty);
        expect(config.excludeForRulesPatterns, isEmpty);
        expect(config.rules, isEmpty);
        expect(config.shouldPrintConfig, false);
      });

      test('data', () {
        final config = LintConfig.fromArgs(
          const ParsedArguments(
            excludePath: 'test/resources/**',
            metricsConfig: {
              'cyclomatic-complexity': '5',
              'halstead-volume': '10',
              'maximum-nesting-level': '5',
              'metric-id4': '0',
            },
            rootFolder: '',
            shouldPrintConfig: true,
          ),
        );

        expect(config.excludePatterns, equals(['test/resources/**']));
        expect(config.excludeForMetricsPatterns, isEmpty);
        expect(
          config.metrics,
          equals({
            'cyclomatic-complexity': '5',
            'halstead-volume': '10',
            'maximum-nesting-level': '5',
          }),
        );
        expect(config.excludeForRulesPatterns, isEmpty);
        expect(config.rules, isEmpty);
        expect(config.shouldPrintConfig, true);
      });
    });

    group('merge constructs instance with data from', () {
      test('defaults and empty configs', () {
        final result = _defaults.merge(_empty);

        expect(result.excludePatterns, equals(_defaults.excludePatterns));
        expect(
          result.excludeForMetricsPatterns,
          equals(_defaults.excludeForMetricsPatterns),
        );
        expect(result.metrics, equals(_defaults.metrics));
        expect(
          result.excludeForRulesPatterns,
          equals(_defaults.excludeForRulesPatterns),
        );
        expect(result.rules, equals(_defaults.rules));
        expect(result.shouldPrintConfig, equals(_defaults.shouldPrintConfig));
      });

      test('empty and overrides configs', () {
        final result = _empty.merge(_overrides);

        expect(result.excludePatterns, equals(_overrides.excludePatterns));
        expect(
          result.excludeForMetricsPatterns,
          equals(_overrides.excludeForMetricsPatterns),
        );
        expect(result.metrics, equals(_overrides.metrics));
        expect(
          result.excludeForRulesPatterns,
          equals(_overrides.excludeForRulesPatterns),
        );
        expect(result.rules, equals(_overrides.rules));
        expect(result.shouldPrintConfig, equals(_overrides.shouldPrintConfig));
      });

      test('defaults and overrides configs', () {
        final result = _defaults.merge(_overrides);

        expect(result.excludePatterns, equals(_merged.excludePatterns));
        expect(
          result.excludeForMetricsPatterns,
          equals(_merged.excludeForMetricsPatterns),
        );
        expect(result.metrics, equals(_merged.metrics));
        expect(
          result.excludeForRulesPatterns,
          equals(_merged.excludeForRulesPatterns),
        );
        expect(result.rules, equals(_merged.rules));
        expect(result.shouldPrintConfig, equals(_merged.shouldPrintConfig));
      });
    });
  });
}
