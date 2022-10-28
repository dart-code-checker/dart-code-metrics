import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/unused_files_config.dart';
import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:test/test.dart';

const _options = AnalysisOptions('path', {
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['dart_code_metrics'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
});

const _defaults = UnusedFilesConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**'],
  isMonorepo: false,
  shouldPrintConfig: false,
);

const _empty = UnusedFilesConfig(
  excludePatterns: [],
  analyzerExcludePatterns: [],
  isMonorepo: false,
  shouldPrintConfig: false,
);

const _merged = UnusedFilesConfig(
  excludePatterns: ['test/resources/**'],
  analyzerExcludePatterns: ['test/**', 'examples/**'],
  isMonorepo: true,
  shouldPrintConfig: true,
);

const _overrides = UnusedFilesConfig(
  excludePatterns: [],
  analyzerExcludePatterns: ['examples/**'],
  isMonorepo: true,
  shouldPrintConfig: true,
);

void main() {
  group('UnusedCodeConfig', () {
    group('fromAnalysisOptions constructs instance from passed', () {
      test('empty options', () {
        final config = UnusedFilesConfig.fromAnalysisOptions(
          const AnalysisOptions(null, {}),
        );

        expect(config.excludePatterns, isEmpty);
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.isMonorepo, false);
        expect(config.shouldPrintConfig, false);
      });

      test('data', () {
        final config = UnusedFilesConfig.fromAnalysisOptions(_options);

        expect(config.analyzerExcludePatterns, equals(['test/resources/**']));
      });
    });

    group('fromArgs constructs instance from passed', () {
      test('data', () {
        final config = UnusedFilesConfig.fromArgs(
          ['hello'],
          isMonorepo: true,
          shouldPrintConfig: true,
        );

        expect(config.excludePatterns, equals(['hello']));
        expect(config.analyzerExcludePatterns, isEmpty);
        expect(config.isMonorepo, true);
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
        expect(result.isMonorepo, equals(_defaults.isMonorepo));
        expect(result.shouldPrintConfig, equals(_defaults.shouldPrintConfig));
      });

      test('empty and overrides configs', () {
        final result = _empty.merge(_overrides);

        expect(result.excludePatterns, equals(_overrides.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_overrides.analyzerExcludePatterns),
        );
        expect(result.isMonorepo, equals(_overrides.isMonorepo));
        expect(result.shouldPrintConfig, equals(_overrides.shouldPrintConfig));
      });

      test('defaults and overrides configs', () {
        final result = _defaults.merge(_overrides);

        expect(result.excludePatterns, equals(_merged.excludePatterns));
        expect(
          result.analyzerExcludePatterns,
          equals(_merged.analyzerExcludePatterns),
        );
        expect(result.isMonorepo, equals(_merged.isMonorepo));
        expect(result.shouldPrintConfig, equals(_merged.shouldPrintConfig));
      });
    });
  });
}
