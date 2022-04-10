import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/unused_code_config.dart';
import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:test/test.dart';

const _options = AnalysisOptions('path', {
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['dart_code_metrics'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
});

const _defaults = UnusedCodeConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**'],
  isMonorepo: false,
);

const _empty = UnusedCodeConfig(
  excludePatterns: [],
  analyzerExcludePatterns: [],
  isMonorepo: false,
);

const _merged = UnusedCodeConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**', 'examples/**'],
  isMonorepo: true,
);

const _overrides = UnusedCodeConfig(
  excludePatterns: [],
  analyzerExcludePatterns: ['examples/**'],
  isMonorepo: true,
);

void main() {
  group('UnusedCodeConfig', () {
    group('fromAnalysisOptions constructs instance from passed', () {
      test('empty options', () {
        final config = UnusedCodeConfig.fromAnalysisOptions(
          const AnalysisOptions(null, {}),
        );

        expect(config.excludePatterns, isEmpty);
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.isMonorepo, false);
      });

      test('data', () {
        final config = UnusedCodeConfig.fromAnalysisOptions(_options);

        expect(config.analyzerExcludePatterns, equals(['test/resources/**']));
      });
    });

    group('fromArgs constructs instance from passed', () {
      test('data', () {
        final config = UnusedCodeConfig.fromArgs(['hello'], isMonorepo: true);

        expect(config.excludePatterns, equals(['hello']));
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.isMonorepo, true);
      });
    });

    group('merge constructs instance with data from', () {
      test('defaults and empty configs', () {
        final result = _defaults.merge(_empty);

        expect(result.excludePatterns, equals(_defaults.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_defaults.analyzerExcludePatterns),
        );
        expect(result.isMonorepo, equals(_defaults.isMonorepo));
      });

      test('empty and overrides configs', () {
        final result = _empty.merge(_overrides);

        expect(result.excludePatterns, equals(_overrides.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_overrides.analyzerExcludePatterns),
        );
        expect(result.isMonorepo, equals(_overrides.isMonorepo));
      });

      test('defaults and overrides configs', () {
        final result = _defaults.merge(_overrides);

        expect(result.excludePatterns, equals(_merged.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_merged.analyzerExcludePatterns),
        );
        expect(result.isMonorepo, equals(_merged.isMonorepo));
      });
    });
  });
}
