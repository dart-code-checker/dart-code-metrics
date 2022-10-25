import 'dart:io';

import 'package:dart_code_metrics/src/config_builder/models/analysis_options.dart';
import 'package:dart_code_metrics/src/utils/analyzer_utils.dart';
import 'package:test/test.dart';

const _options = {
  'include': 'package:pedantic/analysis_options.yaml',
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['dart_code_metrics'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
  'dart_code_metrics': {
    'extends': ['package:test_lint/presets.yaml'],
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
};

void main() {
  final collection = createAnalysisContextCollection(
    ['test'],
    Directory.current.path,
    null,
  );

  group('analysisOptionsFromFile constructs AnalysisOptions from', () {
    test('null', () {
      final options = analysisOptionsFromFile(null, collection.contexts.first);

      expect(options.options, isEmpty);
    });

    test('invalid file', () {
      final options = analysisOptionsFromFile(
        File('unavailable.yaml'),
        collection.contexts.first,
      );

      expect(options.options, isEmpty);
    });

    test('yaml file', () {
      const yamlFilePath = './test/resources/analysis_options_pkg.yaml';

      final options = analysisOptionsFromFile(
        File(yamlFilePath),
        collection.contexts.first,
      );

      expect(options.options, contains('linter'));
      expect(options.options['linter'], contains('rules'));
      expect(
        (options.options['linter'] as Map<String, Object>)['rules'],
        containsAll(
          <String>['avoid_empty_else', 'type_init_formals'],
        ),
      );

      expect(options.options, contains('analyzer'));
      expect(options.options['analyzer'], contains('exclude'));
      expect(
        (options.options['analyzer'] as Map<String, Object>)['exclude'],
        containsAll(<String>['example/**']),
      );

      expect(options.options, contains('dart_code_metrics'));
      expect(options.options['dart_code_metrics'], contains('metrics'));
      expect(
        (options.options['dart_code_metrics']
            as Map<String, Object>)['metrics'],
        allOf(
          containsPair('metric-id1', 10),
          containsPair('metric-id2', 30),
          containsPair('metric-id3', 4),
        ),
      );

      expect(options.options, contains('dart_code_metrics'));
      expect(options.options['dart_code_metrics'], contains('metrics-exclude'));
      expect(
        (options.options['dart_code_metrics']
            as Map<String, Object>)['metrics-exclude'],
        containsAll(<String>['test/**', 'documentation/**']),
      );

      expect(options.options['dart_code_metrics'], contains('rules'));
      expect(
        (options.options['dart_code_metrics'] as Map<String, Object>)['rules'],
        allOf(
          containsPair('rule-id1', true),
          containsPair('rule-id2', false),
          containsPair('rule-id3', {
            'alphabetize': true,
            'order': ['first', 'third', 'second'],
          }),
          containsPair('rule-id4', true),
          containsPair('rule-id5', true),
        ),
      );
    });

    test('valid file with single import', () {
      const yamlFilePath = './test/resources/analysis_options_with_import.yaml';

      final options = analysisOptionsFromFile(
        File(yamlFilePath),
        collection.contexts.first,
      );

      expect(options.options['analyzer'], isNotEmpty);
      expect(
        (options.options['analyzer'] as Map<String, Object>)['plugins'],
        equals(['dart_code_metrics']),
      );
    });

    test('extends config', () {
      const yamlFilePath =
          './test/resources/analysis_options_with_extends.yaml';

      final options = analysisOptionsFromFile(
        File(yamlFilePath),
        collection.contexts.first,
      );

      expect(options.options['dart_code_metrics'], contains('rules'));
      expect(
        (options.options['dart_code_metrics'] as Map<String, Object>)['rules'],
        allOf(contains('rule-id10')),
      );
      expect(
        options.readMapOfMap(['rules'], packageRelated: true)['rule-id4'],
        containsPair('exclude', ['test/**']),
      );
    });
  });

  group('AnalysisOptions', () {
    test('readIterableOfString returns iterables with data or not', () {
      const options = AnalysisOptions(null, _options);

      expect(options.readIterableOfString([]), isEmpty);
      expect(options.readIterableOfString(['key']), isEmpty);
      expect(
        options.readIterableOfString(['anti-patterns'], packageRelated: true),
        isEmpty,
      );
      expect(
        options.readIterableOfString(['analyzer', 'exclude']),
        equals(['test/resources/**']),
      );
      expect(
        options.readIterableOfString(['metrics-exclude'], packageRelated: true),
        equals(['test/**', 'examples/**']),
      );
    });

    test('readMap returns map with data or not', () {
      const options = AnalysisOptions(null, _options);

      expect(options.readMap([]), equals(_options));
      expect(options.readMap(['include']), isEmpty);
      expect(options.readMap(['extends'], packageRelated: true), isEmpty);
      expect(
        options.readMap(['metrics-exclude'], packageRelated: true),
        isEmpty,
      );
      expect(
        options.readMap(['rules'], packageRelated: true),
        allOf(
          containsPair('rule-id1', false),
          containsPair('rule-id2', true),
          containsPair('rule-id3', true),
        ),
      );
    });

    test('readMapOfMap returns map with data or not', () async {
      const options = AnalysisOptions(null, {
        'dart_code_metrics': {
          'metrics': {'metric-id1': 10},
          'metrics-exclude': ['documentation/**'],
          'rules1': ['rule-id1', 'rule-id2', 'rule-id3'],
          'rules2': {'rule-id1': false, 'rule-id2': true, 'rule-id3': true},
          'rules3': [
            'rule-id1',
            {
              'rule-id2': {'severity': 'info'},
            },
            'rule-id3',
          ],
          'rules4': null,
          'rules5': [
            'rule-id1',
            'rule-id2',
            'rule-id3',
            {'rule-id1': false},
          ],
        },
      });

      expect(options.readMapOfMap(['key']), isEmpty);

      expect(
        options.readMapOfMap(['rules1'], packageRelated: true),
        allOf(
          containsPair('rule-id1', <String, Object>{}),
          containsPair('rule-id2', <String, Object>{}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(
        options.readMapOfMap(['rules2'], packageRelated: true),
        allOf(
          containsPair('rule-id2', <String, Object>{}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(
        options.readMapOfMap(['rules3'], packageRelated: true),
        allOf(
          containsPair('rule-id1', <String, Object>{}),
          containsPair('rule-id2', {'severity': 'info'}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(options.readMapOfMap(['rules4'], packageRelated: true), isEmpty);

      expect(
        options.readMapOfMap(['rules5'], packageRelated: true),
        allOf(
          containsPair('rule-id2', <String, Object>{}),
          containsPair('rule-id3', <String, Object>{}),
          hasLength(2),
        ),
      );
    });

    test(
      'returns correct "folderPath" on posix platforms',
      () {
        const options =
            AnalysisOptions('./unix/folder/analysis_options.yaml', {});

        expect(options.folderPath, './unix/folder');
      },
      testOn: 'posix',
    );

    test(
      'returns correct "folderPath" on windows platforms',
      () {
        const options =
            AnalysisOptions(r'C:\windows\folder\analysis_options.yaml', {});

        expect(options.folderPath, r'C:\windows\folder');
      },
      testOn: 'windows',
    );
  });
}
