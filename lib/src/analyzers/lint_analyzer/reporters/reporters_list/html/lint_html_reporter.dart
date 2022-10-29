import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:path/path.dart' as p;

import '../../../../../reporters/models/html_reporter.dart';
import '../../../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../../metrics/metrics_list/technical_debt/technical_debt_metric.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/lint_file_report.dart';
import '../../lint_report_params.dart';
import '../../utility_selector.dart';
import 'components/icon.dart';
import 'components/issue_details_tooltip.dart';
import 'models/icon_type.dart';
import 'models/report_table_record.dart';
import 'utility_functions.dart';

const _violationLevelFunctionStyle = {
  MetricValueLevel.alarm: 'metrics-source-code__text--attention-complexity',
  MetricValueLevel.warning: 'metrics-source-code__text--warning-complexity',
  MetricValueLevel.noted: 'metrics-source-code__text--noted-complexity',
  MetricValueLevel.none: 'metrics-source-code__text--normal-complexity',
};

const _violationLevelLineStyle = {
  MetricValueLevel.alarm: 'metrics-source-code__line--attention-complexity',
  MetricValueLevel.warning: 'metrics-source-code__line--warning-complexity',
  MetricValueLevel.noted: 'metrics-source-code__line--noted-complexity',
  MetricValueLevel.none: 'metrics-source-code__line--normal-complexity',
};

const _cyclomaticComplexity = 'Cyclomatic complexity';
const _cyclomaticComplexityWithViolations =
    '$_cyclomaticComplexity / violations';
const _sourceLinesOfCode = 'Source lines of code';
const _sourceLinesOfCodeWithViolations = '$_sourceLinesOfCode / violations';
const _maintainabilityIndex = 'Maintainability index';
const _maintainabilityIndexWithViolations =
    '$_maintainabilityIndex / violations';
const _numberOfArguments = 'Number of Arguments';
const _numberOfArgumentsWithViolations = '$_numberOfArguments / violations';
const _maximumNesting = 'Maximum Nesting';
const _maximumNestingWithViolations = '$_maximumNesting / violations';
const _technicalDebt = 'Technical Debt';

const _codeIssues = 'Issues';
const _designIssues = 'Design issues';

/// Lint HTML reporter.
///
/// Use it to create reports in HTML format.
class LintHtmlReporter extends HtmlReporter<LintFileReport, LintReportParams> {
  LintHtmlReporter(super.reportFolder);

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    LintReportParams? additionalParams,
  }) async {
    await super.report(records);

    for (final record in records) {
      _generateSourceReport(reportFolder, record);
    }
    _generateFoldersReports(reportFolder, records);
  }

  Element _generateTable(String title, Iterable<ReportTableRecord> records) {
    final sortedRecords = records.toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    final tableContent = Element.tag('tbody');
    for (final record in sortedRecords) {
      tableContent.append(renderTableRecord(record));
    }

    final totalComplexity = sortedRecords.fold<int>(
      0,
      (prevValue, record) =>
          prevValue + record.report.totalCyclomaticComplexity,
    );
    final complexityViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) =>
          prevValue + record.report.cyclomaticComplexityViolations,
    );
    final totalSourceLinesOfCode = sortedRecords.fold<int>(
      0,
      (prevValue, record) => prevValue + record.report.totalSourceLinesOfCode,
    );
    final sourceLinesOfCodeViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) =>
          prevValue + record.report.sourceLinesOfCodeViolations,
    );
    final averageMaintainabilityIndex = sortedRecords.fold<double>(
          0,
          (prevValue, record) =>
              prevValue + record.report.averageMaintainabilityIndex,
        ) /
        sortedRecords.length;
    final maintainabilityIndexViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) =>
          prevValue + record.report.maintainabilityIndexViolations,
    );
    final averageArgumentsCount = (sortedRecords.fold<int>(
              0,
              (prevValue, record) =>
                  prevValue + record.report.averageArgumentsCount,
            ) /
            sortedRecords.length)
        .round();
    final argumentsCountViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) => prevValue + record.report.argumentsCountViolations,
    );
    final averageMaximumNesting = (sortedRecords.fold<int>(
              0,
              (prevValue, record) =>
                  prevValue + record.report.averageMaximumNestingLevel,
            ) /
            sortedRecords.length)
        .round();
    final maximumNestingViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) =>
          prevValue + record.report.maximumNestingLevelViolations,
    );
    final technicalDebt = sortedRecords.fold<double>(
      0,
      (prevValue, record) => prevValue + record.report.technicalDebt,
    );
    final technicalDebtViolations = sortedRecords.fold<int>(
      0,
      (prevValue, record) => prevValue + record.report.technicalDebtViolations,
    );

    final withCyclomaticComplexityViolations = complexityViolations > 0;
    final withSourceLinesOfCodeViolations = sourceLinesOfCodeViolations > 0;
    final withMaintainabilityIndexViolations =
        maintainabilityIndexViolations > 0;
    final withArgumentsCountViolations = argumentsCountViolations > 0;
    final withMaximumNestingViolations = maximumNestingViolations > 0;

    final cyclomaticComplexityTitle = withCyclomaticComplexityViolations
        ? _cyclomaticComplexityWithViolations
        : _cyclomaticComplexity;
    final sourceLinesOfCodeTitle = withSourceLinesOfCodeViolations
        ? _sourceLinesOfCodeWithViolations
        : _sourceLinesOfCode;
    final maintainabilityIndexTitle = withMaintainabilityIndexViolations
        ? _maintainabilityIndexWithViolations
        : _maintainabilityIndex;
    final argumentsCountTitle = withArgumentsCountViolations
        ? _numberOfArgumentsWithViolations
        : _numberOfArguments;
    final maximumNestingTitle = withMaximumNestingViolations
        ? _maximumNestingWithViolations
        : _maximumNesting;

    final table = Element.tag('table')
      ..classes.add('metrics-total-table')
      ..append(Element.tag('thead')
        ..append(Element.tag('tr')
          ..append(Element.tag('th')..text = title)
          ..append(Element.tag('th')..text = cyclomaticComplexityTitle)
          ..append(Element.tag('th')..text = sourceLinesOfCodeTitle)
          ..append(Element.tag('th')..text = maintainabilityIndexTitle)
          ..append(Element.tag('th')..text = argumentsCountTitle)
          ..append(Element.tag('th')..text = maximumNestingTitle)
          ..append(Element.tag('th')..text = _technicalDebt)))
      ..append(tableContent);

    return Element.tag('div')
      ..classes.add('metric-wrapper')
      ..append(table)
      ..append(Element.tag('div')
        ..classes.add('metrics-totals')
        ..append(renderSummaryMetric(
          _cyclomaticComplexity,
          totalComplexity,
          violations: complexityViolations,
        ))
        ..append(renderSummaryMetric(
          _sourceLinesOfCode,
          totalSourceLinesOfCode,
          violations: sourceLinesOfCodeViolations,
        ))
        ..append(renderSummaryMetric(
          _maintainabilityIndex,
          averageMaintainabilityIndex.toInt(),
          violations: maintainabilityIndexViolations,
        ))
        ..append(renderSummaryMetric(
          _numberOfArguments,
          averageArgumentsCount,
          violations: argumentsCountViolations,
        ))
        ..append(renderSummaryMetric(
          _maximumNesting,
          averageMaximumNesting,
          violations: maximumNestingViolations,
        ))
        ..append(renderSummaryMetric(
          _technicalDebt,
          technicalDebt.toInt(),
          unitType: sortedRecords.firstOrNull?.report.technicalDebtUnitType,
          forceViolations: technicalDebtViolations > 0,
        )));
  }

  void _generateFoldersReports(
    String reportDirectory,
    Iterable<LintFileReport> records,
  ) {
    final folders =
        records.map((record) => p.dirname(record.relativePath)).toSet();

    for (final folder in folders) {
      _generateFolderReport(
        reportDirectory,
        folder,
        records.where((record) => p.dirname(record.relativePath) == folder),
      );
    }

    final tableRecords = folders.map((folder) {
      final report = UtilitySelector.analysisReportForRecords(
        records.where((record) => p.dirname(record.relativePath) == folder),
      );

      return ReportTableRecord(
        title: folder,
        link: p.join(folder, 'index.html'),
        report: report,
      );
    });

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(Element.tag('head')
        ..append(Element.tag('title')..text = 'Metrics report')
        ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = 'variables.css')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = 'normalize.css')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = 'base.css')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = 'main.css'))
      ..append(Element.tag('body')
        ..append(Element.tag('h1')
          ..classes.add('metric-header')
          ..text = 'All files')
        ..append(_generateTable('Directory', tableRecords)));

    final htmlDocument = Document()..append(html);

    File(p.join(reportDirectory, 'index.html'))
      ..createSync(recursive: true)
      ..writeAsStringSync(
        htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'),
      );
  }

  void _generateFolderReport(
    String reportDirectory,
    String folder,
    Iterable<LintFileReport> records,
  ) {
    final tableRecords = records.map((record) {
      final report = UtilitySelector.fileReport(record);
      final fileName = p.basename(record.relativePath);

      return ReportTableRecord(
        title: fileName,
        link: p.setExtension(fileName, '.html'),
        report: report,
      );
    });

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(Element.tag('head')
        ..append(Element.tag('title')..text = 'Metrics report for $folder')
        ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = p.relative('variables.css', from: folder))
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = p.relative('normalize.css', from: folder))
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = p.relative('base.css', from: folder))
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = p.relative('main.css', from: folder)))
      ..append(Element.tag('body')
        ..append(Element.tag('h1')
          ..classes.add('metric-header')
          ..append(Element.tag('a')
            ..attributes['href'] = p.relative('index.html', from: folder)
            ..text = 'All files')
          ..append(Element.tag('span')..text = ' : ')
          ..append(Element.tag('span')..text = folder))
        ..append(_generateTable('File', tableRecords)));

    final htmlDocument = Document()..append(html);

    File(p.join(reportDirectory, folder, 'index.html'))
      ..createSync(recursive: true)
      ..writeAsStringSync(
        htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'),
      );
  }

  void _generateSourceReport(String reportDirectory, LintFileReport record) {
    final sourceFileContent = File(record.path).readAsStringSync();
    final sourceFileLines = LineSplitter.split(sourceFileContent);

    final linesIndices = Element.tag('td')
      ..classes.add('metrics-source-code__number-lines');
    for (var lineIndex = 1; lineIndex <= sourceFileLines.length; ++lineIndex) {
      linesIndices
        ..append(Element.tag('a')..attributes['name'] = 'L$lineIndex')
        ..append(Element.tag('a')
          ..classes.add('metrics-source-code__number')
          ..attributes['href'] = '#L$lineIndex'
          ..text = '$lineIndex')
        ..append(Element.tag('br'));
    }

    final cyclomaticValues = Element.tag('td')
      ..classes.add('metrics-source-code__complexity');
    for (var lineIndex = 1; lineIndex <= sourceFileLines.length; ++lineIndex) {
      final complexityValueElement = Element.tag('div')
        ..classes.add('metrics-source-code__text');

      final classReport = record.classes.entries.firstWhereOrNull((report) {
        final location = report.value.location;

        return location.start.line <= lineIndex &&
            location.end.line >= lineIndex;
      });
      if (classReport != null &&
          classReport.value.location.start.line == lineIndex) {
        complexityValueElement
          ..classes.add('metrics-source-code__text--with-icon')
          ..append(renderComplexityIcon(classReport.value, classReport.key));
      }

      final functionReport = record.functions.entries.firstWhereOrNull(
        (report) =>
            report.value.location.start.line <= lineIndex &&
            report.value.location.end.line >= lineIndex,
      );

      var line = '';
      if (functionReport != null) {
        if (functionReport.value.location.start.line == lineIndex) {
          complexityValueElement
            ..classes.add('metrics-source-code__text--with-icon')
            ..append(
              renderComplexityIcon(functionReport.value, functionReport.key),
            );
        }

        final lineWithComplexityIncrement = functionReport.value
                .metric(CyclomaticComplexityMetric.metricId)
                ?.context
                .where((element) => element.location.start.line == lineIndex)
                .length ??
            0;

        if (lineWithComplexityIncrement > 0) {
          line += '+$lineWithComplexityIncrement cyclo';
        }

/*      uncomment this block if you need check lines with code
        final lineWithCode = functionReport.linesWithCode.contains(i);
        if (lineWithCode) {
          line += ' c';
        }
*/
        final functionViolationLevel = functionReport.value.metricsLevel;

        final lineViolationStyle = lineWithComplexityIncrement > 0
            ? _violationLevelLineStyle[functionViolationLevel]
            : _violationLevelFunctionStyle[functionViolationLevel];

        complexityValueElement.classes.add(lineViolationStyle ?? '');
      }

      final debt = record.file
          ?.metric(TechnicalDebtMetric.metricId)
          ?.context
          .firstWhereOrNull(
            (context) => context.location.start.line == lineIndex,
          )
          ?.message;
      if (debt != null) {
        line += debt;
      }

      line = line.trim();
      if (line.isNotEmpty) {
        complexityValueElement.text = line.replaceAll(' ', '&nbsp;');
      }

      final issue = record.issues.firstWhereOrNull(
            (element) => element.location.start.line == lineIndex,
          ) ??
          record.antiPatternCases.firstWhereOrNull(
            (element) => element.location.start.line == lineIndex,
          );

      if (issue != null) {
        final issueIcon = Element.tag('div')
          ..classes.addAll(
            ['metrics-source-code__icon', 'metrics-source-code__icon--issue'],
          )
          ..append(renderIcon(IconType.issue))
          ..append(renderIssueDetailsTooltip(issue));

        complexityValueElement.append(issueIcon);
      }

      cyclomaticValues.append(complexityValueElement);
    }

    final from = p.dirname(record.relativePath);

    final codeBlock = Element.tag('td')
      ..classes.add('metrics-source-code__code')
      ..append(Element.tag('pre')
        ..classes.add('prettyprint lang-dart')
        ..text = sourceFileContent);

    final body = Element.tag('body')
      ..append(Element.tag('h1')
        ..classes.add('metric-header')
        ..append(Element.tag('a')
          ..attributes['href'] = p.relative('index.html', from: from)
          ..text = 'All files')
        ..append(Element.tag('span')..text = ' : ')
        ..append(Element.tag('a')
          ..attributes['href'] = 'index.html'
          ..text = from)
        ..append(
          Element.tag('span')..text = '/${p.basename(record.relativePath)}',
        ))
      ..append(_generateSourceReportMetricsHeader(record))
      ..append(Element.tag('pre')
        ..append(Element.tag('table')
          ..classes.add('metrics-source-code')
          ..append(Element.tag('thead')
            ..classes.add('metrics-source-code__header')
            ..append(Element.tag('tr')
              ..append(Element.tag('td')
                ..classes.add('metrics-source-code__number-lines'))
              ..append(Element.tag('td')
                ..classes.add('metrics-source-code__complexity'))
              ..append(Element.tag('td')
                ..classes.add('metrics-source-code__code')
                ..text = 'Source code')))
          ..append(Element.tag('tbody')
            ..classes.add('metrics-source-code__body')
            ..append(Element.tag('tr')
              ..append(linesIndices)
              ..append(cyclomaticValues)
              ..append(codeBlock)))))
      ..append(Element.tag('script')
        ..attributes['src'] =
            'https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.min.js')
      ..append(Element.tag('script')
        ..attributes['src'] =
            'https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/lang-dart.min.js');

    final head = Element.tag('head')
      ..append(Element.tag('title')
        ..text = 'Metrics report for ${record.relativePath}')
      ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = p.relative('variables.css', from: from))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = p.relative('normalize.css', from: from))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = p.relative('base.css', from: from))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = p.relative('main.css', from: from));

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(head)
      ..append(body);

    final htmlDocument = Document()..append(html);

    File(p.setExtension(p.join(reportDirectory, record.relativePath), '.html'))
      ..createSync(recursive: true)
      ..writeAsStringSync(
        htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'),
      );
  }

  Element _generateSourceReportMetricsHeader(LintFileReport record) {
    final report = UtilitySelector.fileReport(record);

    return Element.tag('div')
      ..classes.add('metric-sub-header')
      ..nodes.addAll([
        renderSummaryMetric(
          _cyclomaticComplexity,
          report.totalCyclomaticComplexity,
          violations: report.cyclomaticComplexityViolations,
        ),
        renderSummaryMetric(
          _sourceLinesOfCode,
          report.totalSourceLinesOfCode,
          violations: report.sourceLinesOfCodeViolations,
        ),
        renderSummaryMetric(
          _maintainabilityIndex,
          report.averageMaintainabilityIndex.toInt(),
          violations: report.maintainabilityIndexViolations,
        ),
        renderSummaryMetric(
          _numberOfArguments,
          report.averageArgumentsCount,
          violations: report.argumentsCountViolations,
        ),
        renderSummaryMetric(
          _maximumNesting,
          report.averageMaximumNestingLevel,
          violations: report.maximumNestingLevelViolations,
        ),
        if (report.technicalDebt > 0)
          renderSummaryMetric(
            _technicalDebt,
            report.technicalDebt.toInt(),
            unitType: report.technicalDebtUnitType,
            forceViolations: report.technicalDebtViolations > 0,
          ),
        if (record.issues.isNotEmpty)
          renderSummaryMetric(
            _codeIssues,
            record.issues.length,
            forceViolations: true,
          ),
        if (record.antiPatternCases.isNotEmpty)
          renderSummaryMetric(
            _designIssues,
            record.antiPatternCases.length,
            forceViolations: true,
          ),
      ]);
  }
}
