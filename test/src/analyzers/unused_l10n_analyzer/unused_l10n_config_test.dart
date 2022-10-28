import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/unused_l10n_config.dart';
import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:test/test.dart';

const _options = AnalysisOptions('path', {
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['dart_code_metrics'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
});

const _defaults = UnusedL10nConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**'],
  classPattern: 'pattern1',
  shouldPrintConfig: false,
);

const _empty = UnusedL10nConfig(
  excludePatterns: [],
  analyzerExcludePatterns: [],
  classPattern: null,
  shouldPrintConfig: false,
);

const _merged = UnusedL10nConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**', 'examples/**'],
  classPattern: 'pattern2',
  shouldPrintConfig: true,
);

const _overrides = UnusedL10nConfig(
  excludePatterns: [],
  analyzerExcludePatterns: ['examples/**'],
  classPattern: 'pattern2',
  shouldPrintConfig: true,
);

void main() {
  group('UnusedCodeConfig', () {
    group('fromAnalysisOptions constructs instance from passed', () {
      test('empty options', () {
        final config = UnusedL10nConfig.fromAnalysisOptions(
          const AnalysisOptions(null, {}),
        );

        expect(config.excludePatterns, isEmpty);
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.classPattern, isNull);
        expect(config.shouldPrintConfig, false);
      });

      test('data', () {
        final config = UnusedL10nConfig.fromAnalysisOptions(_options);

        expect(config.analyzerExcludePatterns, equals(['test/resources/**']));
      });
    });

    group('fromArgs constructs instance from passed', () {
      test('data', () {
        final config = UnusedL10nConfig.fromArgs(
          ['hello'],
          'pattern1',
          shouldPrintConfig: true,
        );

        expect(config.excludePatterns, equals(['hello']));
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.classPattern, equals('pattern1'));
        expect(config.shouldPrintConfig, true);
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
        expect(result.classPattern, equals(_defaults.classPattern));
        expect(result.shouldPrintConfig, equals(_defaults.shouldPrintConfig));
      });

      test('empty and overrides configs', () {
        final result = _empty.merge(_overrides);

        expect(result.excludePatterns, equals(_overrides.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_overrides.analyzerExcludePatterns),
        );
        expect(result.classPattern, equals(_overrides.classPattern));
        expect(result.shouldPrintConfig, equals(_overrides.shouldPrintConfig));
      });

      test('defaults and overrides configs', () {
        final result = _defaults.merge(_overrides);

        expect(result.excludePatterns, equals(_merged.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_merged.analyzerExcludePatterns),
        );
        expect(result.classPattern, equals(_merged.classPattern));
        expect(result.shouldPrintConfig, equals(_merged.shouldPrintConfig));
      });
    });
  });
}
