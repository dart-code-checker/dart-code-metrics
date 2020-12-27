@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/ignore_info.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  var a = 5;

  var b = a + 5;
}

''';

const _contentWithIgnores = '''
// ignore_for_file: rule_id1

void main() {
  // ignore: rule_id4
  var a = 5; // ignore: rule_id5

  // ignore: rule_id6, rule_id7
  var b = a + 5; // ignore: rule_id8, rule_id9
}

// ignore_for_file: rule_id2, rule_id3
''';

const _contentWithCamelCaseIgnores = '''
// ignore_for_file: ruleId1

void main() {
  // ignore: ruleId4
  var a = 5; // ignore: ruleId5

  // ignore: ruleId6, ruleId7
  var b = a + 5; // ignore: ruleId8, ruleId9
}

// ignore_for_file: ruleId2, ruleId3
''';

void main() {
  group('IgnoreInfo from', () {
    test('content without ignores', () {
      final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final ignoreInfo = IgnoreInfo.calculateIgnores(
          parseResult.content, parseResult.lineInfo);

      expect(ignoreInfo.hasIgnoreInfo, isFalse);
    });

    test('content with ignores', () {
      final parseResult = parseString(
        content: _contentWithIgnores,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final ignoreInfo = IgnoreInfo.calculateIgnores(
          parseResult.content, parseResult.lineInfo);

      expect(ignoreInfo.hasIgnoreInfo, isTrue);

      expect(ignoreInfo.ignoreRule('rule_id1'), isTrue);
      expect(ignoreInfo.ignoreRule('rule_id2'), isTrue);
      expect(ignoreInfo.ignoreRule('rule_id3'), isTrue);
      expect(ignoreInfo.ignoreRule('rule_id4'), isFalse);

      expect(ignoreInfo.ignoredAt('rule_id1', 5), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id2', 8), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id3', 2), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id4', 5), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id5', 5), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id6', 8), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id7', 8), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id8', 8), isTrue);
      expect(ignoreInfo.ignoredAt('rule_id9', 8), isTrue);
    });

    test('content with camelcase ignores', () {
      final parseResult = parseString(
        content: _contentWithCamelCaseIgnores,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final ignoreInfo = IgnoreInfo.calculateIgnores(
          parseResult.content, parseResult.lineInfo);

      expect(ignoreInfo.hasIgnoreInfo, isTrue);

      expect(ignoreInfo.ignoreRule('ruleId1'), isTrue);
      expect(ignoreInfo.ignoreRule('ruleId2'), isTrue);
      expect(ignoreInfo.ignoreRule('ruleId3'), isTrue);
      expect(ignoreInfo.ignoreRule('ruleId4'), isFalse);

      expect(ignoreInfo.ignoredAt('ruleId1', 5), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId2', 8), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId3', 2), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId4', 5), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId5', 5), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId6', 8), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId7', 8), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId8', 8), isTrue);
      expect(ignoreInfo.ignoredAt('ruleId9', 8), isTrue);
    });
  });
}
