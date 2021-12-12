import 'package:dart_code_metrics/src/config_builder/analysis_options_utils.dart';
import 'package:test/test.dart';

const _defaults = {
  'code_checker': {
    'anti-patterns': {'anti-pattern-id1': true, 'anti-pattern-id2': false},
    'metrics': {
      'metric-id1': '15',
      'metric-id2': '10',
      'metric-id3': '5',
    },
    'metrics-exclude': ['test/**'],
    'rules': ['rule-id1', 'rule-id2'],
  },
};

const _overrides = {
  'code_checker': {
    'anti-patterns': ['anti-pattern-id3'],
    'metrics': {
      'metric-id1': '5',
      'metric-id4': '0',
    },
    'metrics-exclude': ['examples/**'],
    'rules': {'rule-id1': false, 'rule-id3': true},
  },
};

const _merged = {
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
  group('', () {
    test('isIterableOfStrings checks type of provided object', () {
      expect(isIterableOfStrings(null), isFalse);
      expect(isIterableOfStrings(Object()), isFalse);
      expect(isIterableOfStrings(<String, Object>{}), isFalse);
      expect(isIterableOfStrings(<String>{}), isTrue);
      expect(isIterableOfStrings(<String>[]), isTrue);
      expect(isIterableOfStrings([1, 2, 3, 4, 5]), isFalse);
      expect(isIterableOfStrings(['1', '2', '3', '4', '5']), isTrue);
    });
    test('mergeMaps returns map contains information from both of maps', () {
      expect(mergeMaps(defaults: _defaults, overrides: {}), equals(_defaults));
      expect(
        mergeMaps(defaults: {}, overrides: _overrides),
        equals(_overrides),
      );
      expect(
        mergeMaps(defaults: _defaults, overrides: _overrides),
        equals(_merged),
      );
    });
  });
}
