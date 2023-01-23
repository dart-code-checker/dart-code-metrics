import 'package:dart_code_metrics/src/utils/suppression.dart';
import 'package:test/test.dart';

import '../../../helpers/file_resolver.dart';

const _examplePath = 'test/resources/suppression_example.dart';
const _exampleAllPath = 'test/resources/suppression_all_example.dart';

void main() {
  test('suppression in content', () async {
    final parseResult = await FileResolver.resolve(_examplePath);

    final suppression = Suppression(
      parseResult.content,
      parseResult.lineInfo,
      supportsTypeLintIgnore: true,
    );

    expect(suppression.isSuppressed('rule_id1'), isTrue);
    expect(suppression.isSuppressed('rule_id2'), isTrue);
    expect(suppression.isSuppressed('rule_id3'), isTrue);
    expect(suppression.isSuppressed('rule_id4'), isFalse);

    expect(suppression.isSuppressedAt('rule_id4', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id5', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id6', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id7', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id8', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id9', 9), isTrue);
  });

  test('suppression with type=lint', () async {
    final parseResult = await FileResolver.resolve(_exampleAllPath);

    final suppression = Suppression(
      parseResult.content,
      parseResult.lineInfo,
      supportsTypeLintIgnore: true,
    );

    expect(suppression.isSuppressed('rule_id1'), isTrue);
    expect(suppression.isSuppressed('rule_id2'), isTrue);
    expect(suppression.isSuppressed('rule_id3'), isTrue);
    expect(suppression.isSuppressed('rule_id4'), isTrue);

    expect(suppression.isSuppressedAt('rule_id4', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id5', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id6', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id7', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id8', 9), isTrue);
    expect(suppression.isSuppressedAt('rule_id9', 9), isTrue);
  });
}
