import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/components/issue_details_tooltip.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('Issue details tooltip:', () {
    test(
      'renderIssueDetailsTooltip returns tooltip dom element with details data',
      () {
        expect(
          renderIssueDetailsTooltip(
            Issue(
              ruleId: 'ruleId',
              documentation: Uri.parse('https://documentation.com/rule.html'),
              location: SourceSpan(SourceLocation(0), SourceLocation(0), ''),
              severity: Severity.warning,
              message: 'Issue message',
              verboseMessage: 'Issue verbose message',
            ),
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip"><div class="metrics-source-code__tooltip-title">Warning: ruleId</div><p class="metrics-source-code__tooltip-section">Issue message</p><p class="metrics-source-code__tooltip-section">Issue verbose message</p><p class="metrics-source-code__tooltip-section"><a class="metrics-source-code__tooltip-link" href="https://documentation.com/rule.html" target="_blank" rel="noopener noreferrer" title="Open documentation">Open documentation</a></p></div>',
          ),
        );
        expect(
          renderIssueDetailsTooltip(
            Issue(
              ruleId: 'ruleId',
              documentation: Uri.parse('https://documentation.com/rule.html'),
              location: SourceSpan(SourceLocation(0), SourceLocation(0), ''),
              severity: Severity.none,
              message: 'Issue message',
            ),
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip"><div class="metrics-source-code__tooltip-title">ruleId</div><p class="metrics-source-code__tooltip-section">Issue message</p><p class="metrics-source-code__tooltip-section"><a class="metrics-source-code__tooltip-link" href="https://documentation.com/rule.html" target="_blank" rel="noopener noreferrer" title="Open documentation">Open documentation</a></p></div>',
          ),
        );
      },
    );
  });
}
