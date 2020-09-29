import 'package:html/dom.dart';

import '../../models/report_metric.dart';

Element renderSummaryMetric(String name, String value,
        {bool withViolation = false}) =>
    Element.tag('div')
      ..classes.addAll(
          ['metrics-total', if (withViolation) 'metrics-total--violations'])
      ..append(Element.tag('span')
        ..classes.add('metrics-total__label')
        ..text = '$name : ')
      ..append(Element.tag('span')
        ..classes.add('metrics-total__count')
        ..text = value);

Element renderFunctionMetric(String name, ReportMetric<num> metric) {
  final metricName = name.toLowerCase();
  final violationLevel = metric.violationLevel.toString().toLowerCase();

  return Element.tag('div')
    ..classes.add('metrics-source-code__tooltip-section')
    ..append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-text')
      ..append(Element.tag('span')
        ..classes.add('metrics-source-code__tooltip-label')
        ..text = '$metricName:&nbsp;')
      ..append(Element.tag('span')..text = metric.value.round().toString()))
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
