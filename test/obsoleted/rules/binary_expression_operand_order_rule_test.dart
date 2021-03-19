@TestOn('vm')
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/binary_expression_operand_order_rule.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

const _sample = '''
const c = 42;

const bad1 = 1 + c;
const bad2 = c + (1 + c);
const bad3 = c + (12.44 * c);
const bad4 = 1 & c;
const bad5 = 2 | c;
const bad6 = 4 ^ c;

const good1 = c + 1;
const good2 = c + (c + 1);
const good3 = c + (c * 12.44);
const good4 = c & 1;
const good5 = c | 2;
const good6 = c ^ 4;

const skip1 = 100 - c;
const skip2 = 168 / c;
const skip3 = 168 / (84 - c);
''';

void main() {
  group('BinaryExpressionOperandOrderRule', () {
    test('reports', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
        content: _sample,
        // ignore: deprecated_member_use
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false,
      );

      final issues = BinaryExpressionOperandOrderRule()
          .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ))
          .toList();

      expect(issues, hasLength(6));

      expect(
        issues.every((i) => i.ruleId == 'binary-expression-operand-order'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.style),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.location.sourceUrl == sourceUrl),
        isTrue,
      );
      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([28, 53, 79, 104, 124, 144]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([3, 4, 5, 6, 7, 8]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([14, 19, 19, 14, 14, 14]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([33, 58, 88, 109, 129, 149]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals(['1 + c', '1 + c', '12.44 * c', '1 & c', '2 | c', '4 ^ c']),
      );
      expect(
        issues.map((issue) => issue.suggestion.replacement),
        equals(['c + 1', 'c + 1', 'c * 12.44', 'c & 1', 'c | 2', 'c ^ 4']),
      );
    });
  });
}
