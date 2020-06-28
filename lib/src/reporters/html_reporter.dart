import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/models/report_metric.dart';
import 'package:html/dom.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:resource/resource.dart';

const _violationLevelFunctionStyle = {
  ViolationLevel.alarm: 'metrics-source-code__text--attention-complexity',
  ViolationLevel.warning: 'metrics-source-code__text--warning-complexity',
  ViolationLevel.noted: 'metrics-source-code__text--noted-complexity',
  ViolationLevel.none: 'metrics-source-code__text--normal-complexity',
};

const _violationLevelLineStyle = {
  ViolationLevel.alarm: 'metrics-source-code__line--attention-complexity',
  ViolationLevel.warning: 'metrics-source-code__line--warning-complexity',
  ViolationLevel.noted: 'metrics-source-code__line--noted-complexity',
  ViolationLevel.none: 'metrics-source-code__line--normal-complexity',
};

const _cyclomaticComplexity = 'Cyclomatic complexity';
const _cyclomaticComplexityWithViolations =
    'Cyclomatic complexity / violations';
const _linesOfCode = 'Lines of code';
const _linesOfCodeWithViolations = 'Lines of code / violations';
const _maintainabilityIndex = 'Maintainability index';
const _maintainabilityIndexWithViolations =
    'Maintainability index / violations';
const _nuberOfArguments = 'Number of Arguments';
const _nuberOfArgumentsWithViolations = 'Number of Arguments / violations';

@immutable
class ReportTableRecord {
  final String title;
  final String link;

  final int cyclomaticComplexity;
  final int cyclomaticComplexityViolations;

  final int linesOfCode;
  final int linesOfCodeViolations;

  final double maintainabilityIndex;
  final int maintainabilityIndexViolations;

  final int averageArgumentsCount;
  final int argumentsCountViolations;

  const ReportTableRecord(
      {@required this.title,
      @required this.link,
      @required this.cyclomaticComplexity,
      @required this.cyclomaticComplexityViolations,
      @required this.linesOfCode,
      @required this.linesOfCodeViolations,
      @required this.maintainabilityIndex,
      @required this.maintainabilityIndexViolations,
      @required this.averageArgumentsCount,
      @required this.argumentsCountViolations});
}

/// HTML-doc reporter
class HtmlReporter implements Reporter {
  final Config reportConfig;
  final String reportFolder;

  HtmlReporter({this.reportConfig, this.reportFolder = 'metrics'});

  @override
  Iterable<String> report(Iterable<FileRecord> records) {
    if (records?.isNotEmpty ?? false) {
      _createReportDirectory(reportFolder);
      _copyResources(reportFolder);
      for (final record in records) {
        _generateSourceReport(reportFolder, record);
      }
      _generateFoldersReports(reportFolder, records);
    }

    return [];
  }

  void _createReportDirectory(String directoryName) {
    final reportDirectory = Directory(directoryName);
    if (reportDirectory.existsSync()) {
      reportDirectory.deleteSync(recursive: true);
    }
    reportDirectory.createSync(recursive: true);
  }

  void _copyResources(String reportFolder) {
    const baseStylesheet = 'base';

    const res = Resource(
        'package:dart_code_metrics/src/reporters/html_resources/base.css');
    res.readAsString().then((content) {
      File(p.setExtension(p.join(reportFolder, baseStylesheet), '.css'))
        ..createSync(recursive: true)
        ..writeAsStringSync(content);
    });
  }

  Element _generateTable(String title, Iterable<ReportTableRecord> records) {
    final sortedRecords = records.toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    final totalComplexity = sortedRecords.fold<int>(
        0, (prevValue, record) => prevValue + record.cyclomaticComplexity);
    final totalComplexityViolations = sortedRecords.fold<int>(
        0,
        (prevValue, record) =>
            prevValue + record.cyclomaticComplexityViolations);
    final totalLinesOfCode = sortedRecords.fold<int>(
        0, (prevValue, record) => prevValue + record.linesOfCode);
    final totalLinesOfCodeViolations = sortedRecords.fold<int>(
        0, (prevValue, record) => prevValue + record.linesOfCodeViolations);
    final averageMaintainabilityIndex = sortedRecords.fold<double>(
            0, (prevValue, record) => prevValue + record.maintainabilityIndex) /
        sortedRecords.length;
    final totalMaintainabilityIndexViolations = sortedRecords.fold<int>(
        0,
        (prevValue, record) =>
            prevValue + record.maintainabilityIndexViolations);
    final averageArgumentsCount = (sortedRecords.fold<int>(
                    0,
                    (prevValue, record) =>
                        prevValue + record.averageArgumentsCount) /
                sortedRecords.length +
            0.5)
        .toInt();
    final totalArgumentsCountViolations = sortedRecords.fold<int>(
        0, (prevValue, record) => prevValue + record.argumentsCountViolations);

    final withCyclomaticComplexityViolations = totalComplexityViolations > 0;
    final withLinesOfCodeViolations = totalLinesOfCodeViolations > 0;
    final withMaintainabilityIndexViolations =
        totalMaintainabilityIndexViolations > 0;
    final withArgumentsCountViolations = totalArgumentsCountViolations > 0;

    final tableContent = Element.tag('tbody');
    for (final record in sortedRecords) {
      final recordHaveCyclomaticComplexityViolations =
          record.cyclomaticComplexityViolations > 0;
      final recordHaveLinesOfCodeViolations = record.linesOfCodeViolations > 0;
      final recordHaveMaintainabilityIndexViolations =
          record.maintainabilityIndexViolations > 0;
      final recordArgumentsCountViolations =
          record.argumentsCountViolations > 0;

      tableContent.append(Element.tag('tr')
        ..append(Element.tag('td')
          ..append(Element.tag('a')
            ..attributes['href'] = record.link
            ..text = record.title))
        ..append(Element.tag('td')
          ..text = recordHaveCyclomaticComplexityViolations
              ? '${record.cyclomaticComplexity} / ${record.cyclomaticComplexityViolations}'
              : '${record.cyclomaticComplexity}'
          ..classes.add(recordHaveCyclomaticComplexityViolations
              ? 'with-violations'
              : ''))
        ..append(Element.tag('td')
          ..text = recordHaveLinesOfCodeViolations
              ? '${record.linesOfCode} / ${record.linesOfCodeViolations}'
              : '${record.linesOfCode}'
          ..classes
              .add(recordHaveLinesOfCodeViolations ? 'with-violations' : ''))
        ..append(Element.tag('td')
          ..text = recordHaveMaintainabilityIndexViolations
              ? '${record.maintainabilityIndex.toInt()} / ${record.maintainabilityIndexViolations}'
              : '${record.maintainabilityIndex.toInt()}'
          ..classes.add(recordHaveMaintainabilityIndexViolations
              ? 'with-violations'
              : ''))
        ..append(Element.tag('td')
          ..text = recordArgumentsCountViolations
              ? '${record.averageArgumentsCount} / ${record.argumentsCountViolations}'
              : '${record.averageArgumentsCount}'
          ..classes.add(recordHaveMaintainabilityIndexViolations
              ? 'with-violations'
              : '')));
    }

    final cyclomaticComplexityTitle = withCyclomaticComplexityViolations
        ? _cyclomaticComplexityWithViolations
        : _cyclomaticComplexity;
    final linesOfCodeTitle =
        withLinesOfCodeViolations ? _linesOfCodeWithViolations : _linesOfCode;
    final maintainabilityIndexTitle = withMaintainabilityIndexViolations
        ? _maintainabilityIndexWithViolations
        : _maintainabilityIndex;
    final argumentsCountTitle = withArgumentsCountViolations
        ? _nuberOfArgumentsWithViolations
        : _nuberOfArguments;

    final table = Element.tag('table')
      ..classes.add('metrics-total-table')
      ..append(Element.tag('thead')
        ..append(Element.tag('tr')
          ..append(Element.tag('th')..text = title)
          ..append(Element.tag('th')..text = cyclomaticComplexityTitle)
          ..append(Element.tag('th')..text = linesOfCodeTitle)
          ..append(Element.tag('th')..text = maintainabilityIndexTitle)
          ..append(Element.tag('th')..text = argumentsCountTitle)))
      ..append(tableContent);

    return Element.tag('div')
      ..classes.add('metric-wrapper')
      ..append(table)
      ..append(Element.tag('div')
        ..classes.add('metrics-totals')
        ..append(_generateTotalMetrics(
            cyclomaticComplexityTitle,
            withCyclomaticComplexityViolations
                ? '$totalComplexity / $totalComplexityViolations'
                : '$totalComplexity',
            withCyclomaticComplexityViolations))
        ..append(_generateTotalMetrics(
            linesOfCodeTitle,
            withLinesOfCodeViolations
                ? '$totalLinesOfCode / $totalLinesOfCodeViolations'
                : '$totalLinesOfCode',
            withLinesOfCodeViolations))
        ..append(_generateTotalMetrics(
            maintainabilityIndexTitle,
            withMaintainabilityIndexViolations
                ? '${averageMaintainabilityIndex.toInt()} / $totalMaintainabilityIndexViolations'
                : '${averageMaintainabilityIndex.toInt()}',
            withMaintainabilityIndexViolations))
        ..append(_generateTotalMetrics(
            argumentsCountTitle,
            withArgumentsCountViolations
                ? '$averageArgumentsCount / $totalArgumentsCountViolations'
                : '$averageArgumentsCount',
            withMaintainabilityIndexViolations)));
  }

  void _generateFoldersReports(
      String reportDirectory, Iterable<FileRecord> records) {
    final folders =
        records.map((record) => p.dirname(record.relativePath)).toSet();

    for (final folder in folders) {
      _generateFolderReport(reportDirectory, folder,
          records.where((record) => p.dirname(record.relativePath) == folder));
    }

    final tableRecords = folders.map((folder) {
      final report = UtilitySelector.analysisReportForRecords(
          records.where((record) => p.dirname(record.relativePath) == folder),
          reportConfig);

      return ReportTableRecord(
          title: folder,
          link: p.join(folder, 'index.html'),
          cyclomaticComplexity: report.totalCyclomaticComplexity,
          cyclomaticComplexityViolations:
              report.totalCyclomaticComplexityViolations,
          linesOfCode: report.totalLinesOfCode,
          linesOfCodeViolations: report.totalLinesOfCodeViolations,
          maintainabilityIndex: report.averageMaintainabilityIndex,
          maintainabilityIndexViolations:
              report.totalMaintainabilityIndexViolations,
          averageArgumentsCount: report.averageArgumentsCount,
          argumentsCountViolations: report.totalArgumentsCountViolations);
    });

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(Element.tag('head')
        ..append(Element.tag('title')..text = 'Metrics report')
        ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = 'base.css'))
      ..append(Element.tag('body')
        ..append(Element.tag('h1')
          ..classes.add('metric-header')
          ..text = 'All files')
        ..append(_generateTable('Directory', tableRecords)));

    final htmlDocument = Document()..append(html);

    File(p.join(reportDirectory, 'index.html'))
      ..createSync(recursive: true)
      ..writeAsStringSync(
          htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'));
  }

  void _generateFolderReport(
      String reportDirectory, String folder, Iterable<FileRecord> records) {
    final tableRecords = records.map((record) {
      final report = UtilitySelector.fileReport(record, reportConfig);
      final fileName = p.basename(record.relativePath);

      return ReportTableRecord(
          title: fileName,
          link: p.setExtension(fileName, '.html'),
          cyclomaticComplexity: report.totalCyclomaticComplexity,
          cyclomaticComplexityViolations:
              report.totalCyclomaticComplexityViolations,
          linesOfCode: report.totalLinesOfCode,
          linesOfCodeViolations: report.totalLinesOfCodeViolations,
          maintainabilityIndex: report.averageMaintainabilityIndex,
          maintainabilityIndexViolations:
              report.totalMaintainabilityIndexViolations,
          averageArgumentsCount: report.averageArgumentsCount,
          argumentsCountViolations: report.totalArgumentsCountViolations);
    });

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(Element.tag('head')
        ..append(Element.tag('title')..text = 'Metrics report for $folder')
        ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
        ..append(Element.tag('link')
          ..attributes['rel'] = 'stylesheet'
          ..attributes['href'] = p.relative('base.css', from: folder)))
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
          htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'));
  }

  void _generateSourceReport(String reportDirectory, FileRecord record) {
    final sourceFileContent = File(record.fullPath).readAsStringSync();
    final sourceFileLines = LineSplitter.split(sourceFileContent);

    final linesIndices = Element.tag('td')
      ..classes.add('metrics-source-code__number-lines');
    for (var i = 1; i <= sourceFileLines.length; ++i) {
      linesIndices
        ..append(Element.tag('a')..attributes['name'] = 'L$i')
        ..append(Element.tag('a')
          ..attributes['href'] = '#L$i'
          ..text = '$i')
        ..append(Element.tag('br'));
    }

    final cyclomaticValues = Element.tag('td')
      ..classes.add('metrics-source-code__complexity');
    for (var i = 1; i <= sourceFileLines.length; ++i) {
      final functionReport = record.functions.values.firstWhere(
          (functionReport) =>
              functionReport.firstLine <= i && functionReport.lastLine >= i,
          orElse: () => null);

      final complexityValueElement = Element.tag('div')
        ..classes.add('metrics-source-code__text');

      var line = ' ';
      if (functionReport != null) {
        final report =
            UtilitySelector.functionReport(functionReport, reportConfig);

        if (functionReport.firstLine == i) {
          line = 'ⓘ';

          complexityValueElement.attributes['class'] =
              '${complexityValueElement.attributes['class']} metrics-source-code__text--with-icon'
                  .trim();

          complexityValueElement.attributes['title'] = 'Function stats:'
              '${_report(report.cyclomaticComplexity, _cyclomaticComplexity)}'
              '${_report(report.linesOfCode, _linesOfCode)}'
              '${_report(report.maintainabilityIndex, _maintainabilityIndex)}'
              '${_report(report.argumentsCount, _nuberOfArguments)}';
        }

        final lineWithComplexityIncrement =
            functionReport.cyclomaticComplexityLines.containsKey(i);
        if (lineWithComplexityIncrement) {
          line = '$line +${functionReport.cyclomaticComplexityLines[i]}'.trim();
        }

/*      uncomment this block if you need check lines with code
        final lineWithCode = functionReport.linesWithCode.contains(i);
        if (lineWithCode) {
          line += ' c';
        }
*/
        final functionViolationLevel =
            UtilitySelector.functionViolationLevel(report);

        final lineViolationStyle = lineWithComplexityIncrement
            ? _violationLevelLineStyle[functionViolationLevel]
            : _violationLevelFunctionStyle[functionViolationLevel];

        complexityValueElement.classes.add(lineViolationStyle ?? '');
      }
      complexityValueElement.text = line.replaceAll(' ', '&nbsp;');

      cyclomaticValues.append(complexityValueElement);
    }

    final codeBlock = Element.tag('td')
      ..classes.add('metrics-source-code__code')
      ..append(Element.tag('pre')
        ..classes.add('prettyprint lang-dart')
        ..text = sourceFileContent);

    final report = UtilitySelector.fileReport(record, reportConfig);

    final totalMaintainabilityIndexViolations =
        report.totalMaintainabilityIndexViolations > 0;
    final withArgumentsCountViolations =
        report.totalArgumentsCountViolations > 0;
    final withCyclomaticComplexityViolations =
        report.totalCyclomaticComplexityViolations > 0;
    final withLinesOfCodeViolations = report.totalLinesOfCodeViolations > 0;

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
            Element.tag('span')..text = '/${p.basename(record.relativePath)}'))
      ..append(_generateTotalMetrics(
          withCyclomaticComplexityViolations
              ? _cyclomaticComplexityWithViolations
              : _cyclomaticComplexity,
          withCyclomaticComplexityViolations
              ? '${report.totalCyclomaticComplexity} / ${report.totalCyclomaticComplexityViolations}'
              : '${report.totalCyclomaticComplexity}',
          withCyclomaticComplexityViolations))
      ..append(_generateTotalMetrics(
          withLinesOfCodeViolations ? _linesOfCodeWithViolations : _linesOfCode,
          withLinesOfCodeViolations
              ? '${report.totalLinesOfCode} / ${report.totalLinesOfCodeViolations}'
              : '${report.totalLinesOfCode}',
          withLinesOfCodeViolations))
      ..append(_generateTotalMetrics(
          totalMaintainabilityIndexViolations
              ? _maintainabilityIndexWithViolations
              : _maintainabilityIndex,
          totalMaintainabilityIndexViolations
              ? '${report.averageMaintainabilityIndex.toInt()} / ${report.totalMaintainabilityIndexViolations}'
              : '${report.averageMaintainabilityIndex.toInt()}',
          totalMaintainabilityIndexViolations))
      ..append(_generateTotalMetrics(
          withArgumentsCountViolations
              ? _nuberOfArgumentsWithViolations
              : _nuberOfArguments,
          withArgumentsCountViolations
              ? '${report.averageArgumentsCount} / ${report.totalArgumentsCountViolations}'
              : '${report.averageArgumentsCount}',
          withArgumentsCountViolations))
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
            p.relative('base.css', from: p.dirname(record.relativePath)));

    final html = Element.tag('html')
      ..attributes['lang'] = 'en'
      ..append(head)
      ..append(body);

    final htmlDocument = Document()..append(html);

    File(p.setExtension(p.join(reportDirectory, record.relativePath), '.html'))
      ..createSync(recursive: true)
      ..writeAsStringSync(
          htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'));
  }

  Element _generateTotalMetrics(String name, String value, bool violations) =>
      Element.tag('div')
        ..classes.add(!violations
            ? 'metrics-total'
            : 'metrics-total metrics-total--violations')
        ..append(Element.tag('span')
          ..classes.add('metrics-total__label')
          ..text = '$name : ')
        ..append(Element.tag('span')
          ..classes.add('metrics-total__count')
          ..text = value);

  String _report(ReportMetric<num> metric, String humanReadableName) =>
      '\n${humanReadableName.toLowerCase()}: ${metric.value}'
      '\n${humanReadableName.toLowerCase()} violation level: ${metric.violationLevel.toString().toLowerCase()}';
}
