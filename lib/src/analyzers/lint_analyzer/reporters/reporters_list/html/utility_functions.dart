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
  final report = record.report;
  final recordHaveCyclomaticComplexityViolations =
      report.cyclomaticComplexityViolations > 0;
  final recordHaveSourceLinesOfCodeViolations =
      report.sourceLinesOfCodeViolations > 0;
  final recordHaveMaintainabilityIndexViolations =
      report.maintainabilityIndexViolations > 0;
  final recordHaveArgumentsCountViolations =
      report.argumentsCountViolations > 0;
  final recordHaveMaximumNestingLevelViolations =
      report.maximumNestingLevelViolations > 0;
  final recordHaveTechDebtViolations =
      record.report.technicalDebtViolations > 0;

  final averageMaintainabilityIndex =
      report.averageMaintainabilityIndex.toInt();

  return Element.tag('tr')
    ..append(Element.tag('td')
      ..append(Element.tag('a')
        ..attributes['href'] = record.link
        ..text = record.title))
    ..append(Element.tag('td')
      ..text = recordHaveCyclomaticComplexityViolations
          ? '${report.totalCyclomaticComplexity} / ${report.cyclomaticComplexityViolations}'
          : '${report.totalCyclomaticComplexity}'
      ..classes.add(
        recordHaveCyclomaticComplexityViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveSourceLinesOfCodeViolations
          ? '${report.totalSourceLinesOfCode} / ${report.sourceLinesOfCodeViolations}'
          : '${report.totalSourceLinesOfCode}'
      ..classes.add(
        recordHaveSourceLinesOfCodeViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveMaintainabilityIndexViolations
          ? '$averageMaintainabilityIndex / ${record.report.maintainabilityIndexViolations}'
          : '$averageMaintainabilityIndex'
      ..classes.add(
        recordHaveMaintainabilityIndexViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = recordHaveArgumentsCountViolations
          ? '${report.averageArgumentsCount} / ${report.argumentsCountViolations}'
          : '${report.averageArgumentsCount}'
      ..classes
          .add(recordHaveArgumentsCountViolations ? 'with-violations' : ''))
    ..append(Element.tag('td')
      ..text = recordHaveMaximumNestingLevelViolations
          ? '${report.averageMaximumNestingLevel} / ${report.maximumNestingLevelViolations}'
          : '${report.averageMaximumNestingLevel}'
      ..classes.add(
        recordHaveMaximumNestingLevelViolations ? 'with-violations' : '',
      ))
    ..append(Element.tag('td')
      ..text = '${record.report.technicalDebt}'
      ..classes.add(
        recordHaveTechDebtViolations ? 'with-violations' : '',
      ));
}
