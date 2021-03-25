@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/config/analysis_options.dart';
import 'package:test/test.dart';

const _options = {
  'include': 'package:pedantic/analysis_options.yaml',
  'analyzer': {
    'exclude': ['test/resources/**'],
    'plugins': ['code_checker'],
    'strong-mode': {'implicit-casts': false, 'implicit-dynamic': false},
  },
  'code_checker': {
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
  group('analysisOptionsFromFile constructs AnalysisOptions from', () {
    test('null', () async {
      final options = await analysisOptionsFromFile(null);

      expect(options.options, isEmpty);
    });

    test('invalid file', () async {
      final options = await analysisOptionsFromFile(File('unavailable.yaml'));

      expect(options.options, isEmpty);
    });

    test('yaml file', () async {
      const yamlFilePath = './test/resources/analysis_options_pkg.yaml';

      final options = await analysisOptionsFromFile(File(yamlFilePath));

      expect(options.options, contains('linter'));
      expect(options.options['linter'], contains('rules'));
      expect(
        (options.options['linter'] as Map<String, Object>)['rules'],
        containsAll(
          <String>['always_declare_return_types', 'type_init_formals'],
        ),
      );

      expect(options.options, contains('analyzer'));
      expect(options.options['analyzer'], contains('exclude'));
      expect(
        (options.options['analyzer'] as Map<String, Object>)['exclude'],
        containsAll(<String>['example/**']),
      );

      expect(options.options, contains('code_checker'));
      expect(options.options['code_checker'], contains('metrics'));
      expect(
        (options.options['code_checker'] as Map<String, Object>)['metrics'],
        allOf(
          containsPair('metric-id1', 10),
          containsPair('metric-id2', 30),
          containsPair('metric-id3', 4),
        ),
      );

      expect(options.options, contains('code_checker'));
      expect(options.options['code_checker'], contains('metrics-exclude'));
      expect(
        (options.options['code_checker']
            as Map<String, Object>)['metrics-exclude'],
        containsAll(<String>['test/**', 'documentation/**']),
      );

      expect(options.options['code_checker'], contains('rules'));
      expect(
        (options.options['code_checker'] as Map<String, Object>)['rules'],
        allOf(
          containsPair('rule-id1', true),
          containsPair('rule-id2', true),
          containsPair('rule-id3', {
            'alphabetize': true,
            'order': ['first', 'third', 'second'],
          }),
          containsPair('rule-id4', true),
          containsPair('rule-id5', false),
        ),
      );
    });
  });

  group('AnalysisOptions', () {
    test('readIterableOfString returns iterables with data or not', () {
      const options = AnalysisOptions(_options);

      expect(options.readIterableOfString([]), isEmpty);
      expect(options.readIterableOfString(['key']), isEmpty);
      expect(
        options.readIterableOfString(['code_checker', 'anti-patterns']),
        isEmpty,
      );
      expect(
        options.readIterableOfString(['analyzer', 'exclude']),
        equals(['test/resources/**']),
      );
      expect(
        options.readIterableOfString(['code_checker', 'metrics-exclude']),
        equals(['test/**', 'examples/**']),
      );
    });

    test('readMap returns map with data or not', () {
      const options = AnalysisOptions(_options);

      expect(options.readMap([]), equals(_options));
      expect(options.readMap(['include']), isEmpty);
      expect(
        options.readMap(['code_checker', 'metrics-exclude']),
        isEmpty,
      );
      expect(
        options.readMap(['code_checker', 'rules']),
        allOf(
          containsPair('rule-id1', false),
          containsPair('rule-id2', true),
          containsPair('rule-id3', true),
        ),
      );
    });

    test('readMapOfMap returns map with data or not', () async {
      const options = AnalysisOptions({
        'code_checker': {
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
        },
      });

      expect(options.readMapOfMap(['key']), isEmpty);

      expect(
        options.readMapOfMap(['code_checker', 'rules1']),
        allOf(
          containsPair('rule-id1', <String, Object>{}),
          containsPair('rule-id2', <String, Object>{}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(
        options.readMapOfMap(['code_checker', 'rules2']),
        allOf(
          containsPair('rule-id2', <String, Object>{}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(
        options.readMapOfMap(['code_checker', 'rules3']),
        allOf(
          containsPair('rule-id1', <String, Object>{}),
          containsPair('rule-id2', {'severity': 'info'}),
          containsPair('rule-id3', <String, Object>{}),
        ),
      );

      expect(options.readMapOfMap(['code_checker', 'rules4']), isEmpty);
    });
  });
}
