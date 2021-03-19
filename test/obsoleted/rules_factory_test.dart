@TestOn('vm')
import 'package:dart_code_metrics/src/obsoleted/rules_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getRulesById returns only required rules', () {
    expect(getRulesById({}), isEmpty);
    expect(
      getRulesById({
        'provide-correct-intl-args': <String, Object>{},
        'prefer-trailing-comma-for-collection': <String, Object>{},
        'no-empty-block': <String, Object>{},
        'binary-expression-operand-order': <String, Object>{},
        'no-magic-number': <String, Object>{},
        'double-literal-format': <String, Object>{},
        'avoid-preserve-whitespace-false': <String, Object>{},
        'no-equal-arguments': <String, Object>{},
        'member-ordering': <String, Object>{},
        'prefer-conditional-expressions': <String, Object>{},
        'unknown-rule': <String, Object>{},
        'no-object-declaration': <String, Object>{},
        'component-annotation-arguments-ordering': <String, Object>{},
        'no-equal-then-else': <String, Object>{},
        'prefer-intl-name': <String, Object>{},
        'newline-before-return': <String, Object>{},
        'no-boolean-literal-compare': <String, Object>{},
        'potential-null-dereference': <String, Object>{},
        'prefer-on-push-cd-strategy': <String, Object>{},
        'prefer-trailing-comma': <String, Object>{},
      }).map((rule) => rule.id),
      equals([
        'avoid-preserve-whitespace-false',
        'binary-expression-operand-order',
        'component-annotation-arguments-ordering',
        'double-literal-format',
        'member-ordering',
        'newline-before-return',
        'no-boolean-literal-compare',
        'no-empty-block',
        'no-equal-arguments',
        'no-equal-then-else',
        'no-magic-number',
        'no-object-declaration',
        'potential-null-dereference',
        'prefer-conditional-expressions',
        'prefer-intl-name',
        'prefer-on-push-cd-strategy',
        'prefer-trailing-comma',
        'prefer-trailing-comma-for-collection',
        'provide-correct-intl-args',
      ]),
    );
  });
}
