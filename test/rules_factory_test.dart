@TestOn('vm')
import 'package:dart_code_metrics/src/rules_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getRulesById returns only required rules', () {
    expect(getRulesById({}), isEmpty);
    expect(
        getRulesById({
          'double-literal-format': <String, Object>{},
          'avoid-preserve-whitespace-false': <String, Object>{},
          'unknown-rule': <String, Object>{},
        }).map((rule) => rule.id),
        equals(['avoid-preserve-whitespace-false', 'double-literal-format']));
  });
}
