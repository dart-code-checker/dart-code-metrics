import 'package:html/dom.dart';

import '../../../../metrics/metric_utils.dart';
import '../../../../metrics/models/metric_value.dart';
import '../../../../models/report.dart';

Element renderDetailsTooltip(Report entityReport, String entityType) {
  final tooltip = Element.tag('div')
    ..classes.add('metrics-source-code__tooltip')
    ..append(Element.tag('div')
      ..classes.add('metrics-source-code__tooltip-title')
      ..text = '$entityType&nbsp;stats:');

  final metrics = entityReport.metrics.toList()
    ..sort((a, b) => a.documentation.name.compareTo(b.documentation.name));

  for (final metric in metrics) {
    tooltip.append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-text')
      ..append(renderDetailsTooltipMetric(metric)));
  }

  return tooltip;
}

Element renderDetailsTooltipMetric(MetricValue metric) {
  final metricName = metric.documentation.name.toLowerCase();
  final violationLevel = metric.level.toString();

  return Element.tag('div')
    ..classes.add('metrics-source-code__tooltip-section')
    ..append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-text')
      ..append(Element.tag('a')
        ..classes.add('metrics-source-code__tooltip-link')
        ..attributes['href'] = documentation(metric.metricsId).toString()
        ..attributes['target'] = '_blank'
        ..attributes['rel'] = 'noopener noreferrer'
        ..attributes['title'] = metricName
        ..text = '$metricName:&nbsp;')
      ..append(Element.tag('span')
        ..text = '${metric.value.round()} ${metric.unitType ?? ''}'.trim()))
    ..append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-text')
      ..append(Element.tag('span')
        ..classes.add('metrics-source-code__tooltip-label')
        ..text = '$metricName violation level:&nbsp;')
      ..append(Element.tag('span')
        ..classes.addAll([
          'metrics-source-code__tooltip-level',
          'metrics-source-code__tooltip-level--$violationLevel',
        ])
        ..text = violationLevel));
}
