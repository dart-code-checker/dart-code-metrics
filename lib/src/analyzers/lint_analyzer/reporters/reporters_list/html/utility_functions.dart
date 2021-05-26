import 'package:html/dom.dart';

import '../../../metrics/models/metric_value.dart';
import 'lint_html_reporter.dart';

const _violations = 'violations';

Element renderSummaryMetric(
  String name,
  int metricValue, {
  int violations = 0,
  bool forceViolations = false,
}) {
  final withViolation = violations > 0;
  final title = withViolation ? '$name / $_violations' : name;
  final value = withViolation ? '$metricValue / $violations' : '$metricValue';

  return Element.tag('div')
    ..classes.addAll([
      'metrics-total',
      if (forceViolations || withViolation) 'metrics-total--violations',
    ])
    ..append(Element.tag('span')
      ..classes.add('metrics-total__label')
      ..text = '$title : ')
    ..append(Element.tag('span')
      ..classes.add('metrics-total__count')
      ..text = value);
}

Element renderFunctionMetric(String name, MetricValue<num> metric) {
  final metricName = name.toLowerCase();
  final violationLevel = metric.level.toString();

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

Element renderTableRecord(ReportTableRecord record) {
  final recordHaveCyclomaticComplexityViolations =
      record.report.cyclomaticComplexityViolations > 0;
  final recordHaveSourceLinesOfCodeViolations =
      record.report.sourceLinesOfCodeViolations > 0;
  final recordHaveMaintainabilityIndexViolations =
      record.report.maintainabilityIndexViolations > 0;
  final recordHaveArgumentsCountViolations =
      record.report.argumentsCountViolations > 0;
  final recordHaveMaximumNestingLevelViolations =
      record.report.maximumNestingLevelViolations > 0;

  return Element.tag('tr')
    ..append(Element.tag('td')
      ..append(Element.tag('a')
        ..attributes['href'] = record.link
        ..text = record.title))
    ..append(Element.tag('td')
      ..text = recordHaveCyclomaticComplexityViolations
          ? '${record.report.totalCyclomaticComplexity} / ${record.report.cyclomaticComplexityViolations}'
          : '${record.report.totalCyclomaticComplexity}'
      ..classes.add(
        recordHaveCyclomaticComplexityViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveSourceLinesOfCodeViolations
          ? '${record.report.totalSourceLinesOfCode} / ${record.report.sourceLinesOfCodeViolations}'
          : '${record.report.totalSourceLinesOfCode}'
      ..classes.add(
        recordHaveSourceLinesOfCodeViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveMaintainabilityIndexViolations
          ? '${record.report.averageMaintainabilityIndex.toInt()} / ${record.report.maintainabilityIndexViolations}'
          : '${record.report.averageMaintainabilityIndex.toInt()}'
      ..classes.add(
        recordHaveMaintainabilityIndexViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveArgumentsCountViolations
          ? '${record.report.averageArgumentsCount} / ${record.report.argumentsCountViolations}'
          : '${record.report.averageArgumentsCount}'
      ..classes
          .add(recordHaveArgumentsCountViolations ? 'with-violations' : ''))
    ..append(Element.tag('td')
      ..text = recordHaveMaximumNestingLevelViolations
          ? '${record.report.averageMaximumNestingLevel} / ${record.report.maximumNestingLevelViolations}'
          : '${record.report.averageMaximumNestingLevel}'
      ..classes.add(
        recordHaveMaximumNestingLevelViolations ? 'with-violations' : '',
      ));
}
