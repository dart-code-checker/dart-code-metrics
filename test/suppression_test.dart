@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/suppression.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const examplePath = 'test/resources/suppression_example.dart';

void main() {
  test('suppression in content', () async {
    final parseResult =
        await resolveFile(path: p.normalize(p.absolute(examplePath)));

    final suppression = Suppression(parseResult.content, parseResult.lineInfo);

    expect(suppression.isSuppressed('rule_id1'), isTrue);
    expect(suppression.isSuppressed('rule_id2'), isTrue);
    expect(suppression.isSuppressed('rule_id3'), isTrue);
    expect(suppression.isSuppressed('rule_id4'), isFalse);

    expect(suppression.isSuppressedAt('rule_id1', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id2', 8), isTrue);
    expect(suppression.isSuppressedAt('rule_id3', 2), isTrue);
    expect(suppression.isSuppressedAt('rule_id4', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id5', 5), isTrue);
    expect(suppression.isSuppressedAt('rule_id6', 8), isTrue);
    expect(suppression.isSuppressedAt('rule_id7', 8), isTrue);
    expect(suppression.isSuppressedAt('rule_id8', 8), isTrue);
    expect(suppression.isSuppressedAt('rule_id9', 8), isTrue);
  });
}
