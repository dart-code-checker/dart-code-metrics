@TestOn('vm')
import 'package:dart_code_metrics/src/rules_factory.dart';
import 'package:test/test.dart';

void main() {
  test('getRulesById returns only required rules', () {
    expect(getRulesById([]), isEmpty);
    expect(getRulesById(['double-literal-format']).length, 1);
  });
}
