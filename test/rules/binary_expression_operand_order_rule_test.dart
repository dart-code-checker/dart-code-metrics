import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/binary_expression_operand_order_rule.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

const _sample = '''
const c = 42;

const bad1 = 1 + c;
const bad2 = c + (1 + c);
const bad3 = c + (12.44 * c);

const good1 = c + 1;
const good2 = c + (c + 1);
const good3 = c + (c * 12.44);
''';

void main() {
  group('BinaryExpressionOperandOrderRule', () {
    test('reports', () {
      final sourceUrl = Uri.parse('/example.dart');

      final parseResult = parseString(
          content: _sample,
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = const BinaryExpressionOperandOrderRule()
          .check(parseResult.unit, sourceUrl, parseResult.content)
          .toList();

      expect(issues.length, equals(3));

      expect(
          issues.every(
              (issue) => issue.ruleId == 'binary-expression-operand-order'),
          isTrue);
      expect(issues.every((issue) => issue.severity == CodeIssueSeverity.style),
          isTrue);
      expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
          isTrue);
      expect(issues.map((issue) => issue.sourceSpan.start.offset),
          equals([28, 53, 79]));
      expect(issues.map((issue) => issue.sourceSpan.start.line),
          equals([3, 4, 5]));
      expect(issues.map((issue) => issue.sourceSpan.start.column),
          equals([14, 19, 19]));
      expect(issues.map((issue) => issue.sourceSpan.end.offset),
          equals([33, 58, 88]));
      expect(issues.map((issue) => issue.sourceSpan.text),
          equals(['1 + c', '1 + c', '12.44 * c']));
      expect(issues.map((issue) => issue.correction),
          equals(['c + 1', 'c + 1', 'c * 12.44']));
    });
  });
}
