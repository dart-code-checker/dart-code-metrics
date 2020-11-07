import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/rules/binary_expression_operand_order_rule.dart';
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
          featureSet: FeatureSet.fromEnableFlags([]),
          throwIfDiagnostics: false);

      final issues = BinaryExpressionOperandOrderRule()
          .check(Source(sourceUrl, parseResult.content, parseResult.unit))
          .toList();

      expect(issues.length, equals(6));

      expect(
          issues.every(
              (issue) => issue.ruleId == 'binary-expression-operand-order'),
          isTrue);
      expect(issues.every((issue) => issue.severity == CodeIssueSeverity.style),
          isTrue);
      expect(issues.every((issue) => issue.sourceSpan.sourceUrl == sourceUrl),
          isTrue);
      expect(issues.map((issue) => issue.sourceSpan.start.offset),
          equals([28, 53, 79, 104, 124, 144]));
      expect(issues.map((issue) => issue.sourceSpan.start.line),
          equals([3, 4, 5, 6, 7, 8]));
      expect(issues.map((issue) => issue.sourceSpan.start.column),
          equals([14, 19, 19, 14, 14, 14]));
      expect(issues.map((issue) => issue.sourceSpan.end.offset),
          equals([33, 58, 88, 109, 129, 149]));
      expect(issues.map((issue) => issue.sourceSpan.text),
          equals(['1 + c', '1 + c', '12.44 * c', '1 & c', '2 | c', '4 ^ c']));
      expect(issues.map((issue) => issue.correction),
          equals(['c + 1', 'c + 1', 'c * 12.44', 'c & 1', 'c | 2', 'c ^ 4']));
    });
  });
}
