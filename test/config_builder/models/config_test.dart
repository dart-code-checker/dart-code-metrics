@TestOn('vm')
import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:dart_code_metrics/src/config_builder/models/config.dart';
import 'package:test/test.dart';

const _options = AnalysisOptions({
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
  },
});

const _defaults = Config(
  excludePatterns: ['test/resources/**'],
  excludeForMetricsPatterns: ['test/**'],
  metrics: {
    'metric-id1': '15',
    'metric-id2': '10',
    'metric-id3': '5',
  },
  rules: {
    'rule-id1': {},
    'rule-id2': {'severity': 'info'},
  },
  antiPatterns: {
    'anti-patterns-id1': {},
  },
);

const _empty = Config(
  excludePatterns: [],
  excludeForMetricsPatterns: [],
  metrics: {},
  rules: {},
  antiPatterns: {},
);

const _merged = Config(
  excludePatterns: ['test/resources/**'],
  excludeForMetricsPatterns: ['test/**', 'examples/**'],
  metrics: {
    'metric-id1': '5',
    'metric-id2': '10',
    'metric-id3': '5',
    'metric-id4': '0',
  },
  rules: {
    'rule-id1': {},
    'rule-id2': {'severity': 'warning'},
  },
  antiPatterns: {
    'anti-patterns-id1': {},
    'anti-patterns-id2': {'severity': 'error'},
  },
);

const _overrides = Config(
  excludePatterns: [],
  excludeForMetricsPatterns: ['examples/**'],
  metrics: {
    'metric-id1': '5',
    'metric-id4': '0',
  },
  rules: {
    'rule-id2': {'severity': 'warning'},
  },
  antiPatterns: {
    'anti-patterns-id2': {'severity': 'error'},
  },
);

void main() {
  group('Config', () {
    group('fromAnalysisOptions constructs instance from passed', () {
      test('empty options', () {
        final config = Config.fromAnalysisOptions(const AnalysisOptions({}));

        expect(config.excludePatterns, isEmpty);
        expect(config.excludeForMetricsPatterns, isEmpty);
        expect(config.metrics, isEmpty);
        expect(config.rules, isEmpty);
      });

      test('data', () {
        final config = Config.fromAnalysisOptions(_options);

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
          config.rules,
          equals({
            'rule-id2': <String, Object>{},
            'rule-id3': <String, Object>{},
          }),
        );
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
        expect(result.rules, equals(_defaults.rules));
      });
      test('empty and overrides configs', () {
        final result = _empty.merge(_overrides);

        expect(result.excludePatterns, equals(_overrides.excludePatterns));
        expect(
          result.excludeForMetricsPatterns,
          equals(_overrides.excludeForMetricsPatterns),
        );
        expect(result.metrics, equals(_overrides.metrics));
        expect(result.rules, equals(_overrides.rules));
      });
      test('defaults and overrides configs', () {
        final result = _defaults.merge(_overrides);

        expect(result.excludePatterns, equals(_merged.excludePatterns));
        expect(
          result.excludeForMetricsPatterns,
          equals(_merged.excludeForMetricsPatterns),
        );
        expect(result.metrics, equals(_merged.metrics));
        expect(result.rules, equals(_merged.rules));
      });
    });
  });
}
