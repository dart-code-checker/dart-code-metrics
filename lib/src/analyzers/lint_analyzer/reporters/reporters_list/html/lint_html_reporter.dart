import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../../../../../reporters/models/html_reporter.dart';
import '../../../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/lint_file_report.dart';
import '../../models/file_metrics_report.dart';
import '../../utility_selector.dart';
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

const _codeIssues = 'Issues';
const _designIssues = 'Design issues';

@immutable
class ReportTableRecord {
  final String title;
  final String link;

  final FileMetricsReport report;

  const ReportTableRecord({
    required this.title,
    required this.link,
    required this.report,
  });
}

class LintHtmlReporter extends HtmlReporter<LintFileReport> {
  LintHtmlReporter(String reportFolder) : super(reportFolder);

  @override
  Future<void> report(Iterable<LintFileReport> records) async {
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
          ..append(Element.tag('th')..text = maximumNestingTitle)))
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
    for (var i = 1; i <= sourceFileLines.length; ++i) {
      linesIndices
        ..append(Element.tag('a')..attributes['name'] = 'L$i')
        ..append(Element.tag('a')
          ..classes.add('metrics-source-code__number')
          ..attributes['href'] = '#L$i'
          ..text = '$i')
        ..append(Element.tag('br'));
    }

    final cyclomaticValues = Element.tag('td')
      ..classes.add('metrics-source-code__complexity');
    for (var i = 1; i <= sourceFileLines.length; ++i) {
      final functionReport = record.functions.values.firstWhereOrNull(
        (functionReport) =>
            functionReport.location.start.line <= i &&
            functionReport.location.end.line >= i,
      );

      final complexityValueElement = Element.tag('div')
        ..classes.add('metrics-source-code__text');

      var line = ' ';
      if (functionReport != null) {
        final report = UtilitySelector.functionMetricsReport(functionReport);

        if (functionReport.location.start.line == i) {
          final complexityTooltip = Element.tag('div')
            ..classes.add('metrics-source-code__tooltip')
            ..append(Element.tag('div')
              ..classes.add('metrics-source-code__tooltip-title')
              ..text = 'Function stats:')
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(renderFunctionMetric(
                _cyclomaticComplexity,
                report.cyclomaticComplexity,
              )))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(renderFunctionMetric(
                _sourceLinesOfCode,
                report.sourceLinesOfCode,
              )))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(renderFunctionMetric(
                _maintainabilityIndex,
                report.maintainabilityIndex,
              )))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(renderFunctionMetric(
                _numberOfArguments,
                report.argumentsCount,
              )))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(renderFunctionMetric(
                _maximumNesting,
                report.maximumNestingLevel,
              )));

          final complexityIcon = Element.tag('div')
            ..classes.addAll([
              'metrics-source-code__icon',
              'metrics-source-code__icon--complexity',
            ])
            ..append(Element.tag('svg')
              ..attributes['xmlns'] = 'http://www.w3.org/2000/svg'
              ..attributes['viewBox'] = '0 0 32 32'
              ..append(Element.tag('path')
                ..attributes['d'] =
                    'M16 3C8.832 3 3 8.832 3 16s5.832 13 13 13 13-5.832 13-13S23.168 3 16 3zm0 2c6.086 0 11 4.914 11 11s-4.914 11-11 11S5 22.086 5 16 9.914 5 16 5zm-1 5v2h2v-2zm0 4v8h2v-8z'))
            ..append(complexityTooltip);

          complexityValueElement
            ..attributes['class'] =
                '${complexityValueElement.attributes['class']} metrics-source-code__text--with-icon'
                    .trim()
            ..append(complexityIcon);
        }

        final lineWithComplexityIncrement = functionReport
                .metric(CyclomaticComplexityMetric.metricId)
                ?.context
                .where((element) => element.location.start.line == i)
                .length ??
            0;

        if (lineWithComplexityIncrement > 0) {
          line = '$line +$lineWithComplexityIncrement'.trim();
          complexityValueElement.text = line.replaceAll(' ', '&nbsp;');
        }

/*      uncomment this block if you need check lines with code
        final lineWithCode = functionReport.linesWithCode.contains(i);
        if (lineWithCode) {
          line += ' c';
        }
*/
        final functionViolationLevel =
            UtilitySelector.functionMetricViolationLevel(report);

        final lineViolationStyle = lineWithComplexityIncrement > 0
            ? _violationLevelLineStyle[functionViolationLevel]
            : _violationLevelFunctionStyle[functionViolationLevel];

        complexityValueElement.classes.add(lineViolationStyle ?? '');
      }

      final architecturalIssues = record.antiPatternCases
          .firstWhereOrNull((element) => element.location.start.line == i);

      if (architecturalIssues != null) {
        final issueTooltip = Element.tag('div')
          ..classes.add('metrics-source-code__tooltip')
          ..append(Element.tag('div')
            ..classes.add('metrics-source-code__tooltip-title')
            ..text = architecturalIssues.ruleId)
          ..append(Element.tag('p')
            ..classes.add('metrics-source-code__tooltip-section')
            ..text = architecturalIssues.message)
          ..append(Element.tag('p')
            ..classes.add('metrics-source-code__tooltip-section')
            ..text = architecturalIssues.verboseMessage)
          ..append(Element.tag('a')
            ..classes.add('metrics-source-code__tooltip-link')
            ..attributes['href'] = architecturalIssues.documentation.toString()
            ..attributes['target'] = '_blank'
            ..attributes['rel'] = 'noopener noreferrer'
            ..attributes['title'] = 'Open documentation'
            ..text = 'Open documentation');

        final issueIcon = Element.tag('div')
          ..classes.addAll(
            ['metrics-source-code__icon', 'metrics-source-code__icon--issue'],
          )
          ..append(Element.tag('svg')
            ..attributes['xmlns'] = 'http://www.w3.org/2000/svg'
            ..attributes['viewBox'] = '0 0 24 24'
            ..append(Element.tag('path')
              ..attributes['d'] =
                  'M12 1.016c-.393 0-.786.143-1.072.43l-9.483 9.482a1.517 1.517 0 000 2.144l9.483 9.485c.286.286.667.443 1.072.443s.785-.157 1.072-.443l9.485-9.485a1.517 1.517 0 000-2.144l-9.485-9.483A1.513 1.513 0 0012 1.015zm0 2.183L20.8 12 12 20.8 3.2 12 12 3.2zM11 7v6h2V7h-2zm0 8v2h2v-2h-2z'))
          ..append(issueTooltip);

        complexityValueElement.append(issueIcon);
      }

      cyclomaticValues.append(complexityValueElement);
    }

    final codeBlock = Element.tag('td')
      ..classes.add('metrics-source-code__code')
      ..append(Element.tag('pre')
        ..classes.add('prettyprint lang-dart')
        ..text = sourceFileContent);

    final body = Element.tag('body')
      ..append(Element.tag('h1')
        ..classes.add('metric-header')
        ..append(Element.tag('a')
          ..attributes['href'] =
              p.relative('index.html', from: p.dirname(record.relativePath))
          ..text = 'All files')
        ..append(Element.tag('span')..text = ' : ')
        ..append(Element.tag('a')
          ..attributes['href'] = 'index.html'
          ..text = p.dirname(record.relativePath))
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
                ..classes.add('metrics-source-code__complexity')
                ..text = 'Complexity')
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
        ..attributes['href'] =
            p.relative('variables.css', from: p.dirname(record.relativePath)))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] =
            p.relative('normalize.css', from: p.dirname(record.relativePath)))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] =
            p.relative('base.css', from: p.dirname(record.relativePath)))
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] =
            p.relative('main.css', from: p.dirname(record.relativePath)));

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
