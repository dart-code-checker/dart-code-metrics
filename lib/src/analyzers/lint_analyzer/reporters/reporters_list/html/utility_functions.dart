import 'package:html/dom.dart';

import '../../../models/report.dart';
import 'components/icon.dart';
import 'components/report_details_tooltip.dart';
import 'models/icon_type.dart';
import 'models/report_table_record.dart';

const _violations = 'violations';

Element renderComplexityIcon(Report entityReport, String entityType) =>
    Element.tag('div')
      ..classes.addAll([
        'metrics-source-code__icon',
        'metrics-source-code__icon--complexity',
      ])
      ..append(renderIcon(IconType.complexity))
      ..append(renderDetailsTooltip(entityReport, entityType));

Element renderSummaryMetric(
  String name,
  int metricValue, {
  String? unitType,
  int violations = 0,
  bool forceViolations = false,
}) {
  final withViolation = violations > 0;
  final value = '$metricValue ${unitType ?? ''}'.trim();
  final title = withViolation ? '$name / $_violations' : name;
  final fullValue = withViolation ? '$value / $violations' : value;

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
      ..text = fullValue);
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
  final recordHaveTechDebtViolations =
      record.report.technicalDebtViolations > 0;

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
      ))
    ..append(Element.tag('td')
      ..text = '${record.report.technicalDebt}'
      ..classes.add(
        recordHaveTechDebtViolations ? 'with-violations' : '',
      ));
}
