@TestOn('vm')
import 'package:dart_code_metrics/src/rules_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getRulesById returns only required rules', () {
    expect(getRulesById({}), isEmpty);
    expect(
        getRulesById({
          'binary-expression-operand-order': <String, Object>{},
          'double-literal-format': <String, Object>{},
          'avoid-preserve-whitespace-false': <String, Object>{},
          'member-ordering': <String, Object>{},
          'unknown-rule': <String, Object>{},
          'component-annotation-arguments-ordering': <String, Object>{},
          'newline-before-return': <String, Object>{},
          'no-boolean-literal-compare': <String, Object>{},
        }).map((rule) => rule.id),
        equals([
          'avoid-preserve-whitespace-false',
          'binary-expression-operand-order',
          'component-annotation-arguments-ordering',
          'double-literal-format',
          'member-ordering',
          'newline-before-return',
          'no-boolean-literal-compare',
        ]));
  });
}
