import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/components/report_details_tooltip.dart';
import 'package:test/test.dart';

import '../../../../../../../stubs_builders.dart';

void main() {
  group('Report details tooltip:', () {
    test(
      'renderDetailsTooltip returns tooltip dom element with details data',
      () {
        expect(
          renderDetailsTooltip(
            buildReportStub(
              metrics: [
                buildMetricValueStub(
                  id: 'metric',
                  value: 10,
                  level: MetricValueLevel.warning,
                ),
                buildMetricValueStub(
                  id: 'metric 2',
                  value: 2,
                  level: MetricValueLevel.noted,
                ),
              ],
            ),
            'Entity',
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip"><div class="metrics-source-code__tooltip-title">Entity&amp;nbsp;stats:</div><p class="metrics-source-code__tooltip-text"><div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/metric" target="_blank" rel="noopener noreferrer" title="metric">metric:&amp;nbsp;</a><span>10</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--warning">warning</span></p></div></p><p class="metrics-source-code__tooltip-text"><div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/metric%202" target="_blank" rel="noopener noreferrer" title="metric 2">metric 2:&amp;nbsp;</a><span>2</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric 2 violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--noted">noted</span></p></div></p><p class="metrics-source-code__tooltip-text"><div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/number-of-methods" target="_blank" rel="noopener noreferrer" title="metric1">metric1:&amp;nbsp;</a><span>0</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric1 violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--none">none</span></p></div></p><p class="metrics-source-code__tooltip-text"><div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/weight-of-class" target="_blank" rel="noopener noreferrer" title="metric2">metric2:&amp;nbsp;</a><span>1</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric2 violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--none">none</span></p></div></p></div>',
          ),
        );
      },
    );

    test(
      'renderDetailsTooltipMetric returns metric dom element for tooltip',
      () {
        expect(
          renderDetailsTooltipMetric(
            buildMetricValueStub(
              id: 'metric',
              value: 10,
              level: MetricValueLevel.warning,
            ),
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/metric" target="_blank" rel="noopener noreferrer" title="metric">metric:&amp;nbsp;</a><span>10</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--warning">warning</span></p></div>',
          ),
        );

        expect(
          renderDetailsTooltipMetric(
            buildMetricValueStub(
              id: 'metric',
              value: 10,
              unitType: 'units',
              level: MetricValueLevel.warning,
            ),
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><a class="metrics-source-code__tooltip-link" href="https://dcm.dev/docs/metrics/metric" target="_blank" rel="noopener noreferrer" title="metric">metric:&amp;nbsp;</a><span>10 units</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metric violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--warning">warning</span></p></div>',
          ),
        );
      },
    );
  });
}
