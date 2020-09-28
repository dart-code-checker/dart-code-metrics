import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dart_code_metrics/src/models/report_metric.dart';
import 'package:html/dom.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'utility_functions.dart';

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
const _linesOfExecutableCode = 'Lines of executable code';
const _linesOfExecutableCodeWithViolations =
    'Lines of executable code / violations';
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

  final int linesOfExecutableCode;
  final int linesOfExecutableCodeViolations;

  final double maintainabilityIndex;
  final int maintainabilityIndexViolations;

  final int averageArgumentsCount;
  final int argumentsCountViolations;

  const ReportTableRecord(
      {@required this.title,
      @required this.link,
      @required this.cyclomaticComplexity,
      @required this.cyclomaticComplexityViolations,
      @required this.linesOfExecutableCode,
      @required this.linesOfExecutableCodeViolations,
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
    const resources = [
      'package:dart_code_metrics/src/reporters/html/resources/variables.css',
      'package:dart_code_metrics/src/reporters/html/resources/normalize.css',
      'package:dart_code_metrics/src/reporters/html/resources/base.css',
      'package:dart_code_metrics/src/reporters/html/resources/main.css',
    ];

    for (final resource in resources) {
      Isolate.resolvePackageUri(Uri.parse(resource)).then((resolvedUri) {
        if (resolvedUri != null) {
          final fileWithExtension = p.split(resolvedUri.toString()).last;
          File.fromUri(resolvedUri)
              .copySync(p.join(reportFolder, fileWithExtension));
        }
      });
    }
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
    final totalLinesOfExecutableCode = sortedRecords.fold<int>(
        0, (prevValue, record) => prevValue + record.linesOfExecutableCode);
    final totalLinesOfExecutableCodeViolations = sortedRecords.fold<int>(
        0,
        (prevValue, record) =>
            prevValue + record.linesOfExecutableCodeViolations);
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
    final withLinesOfExecutableCodeViolations =
        totalLinesOfExecutableCodeViolations > 0;
    final withMaintainabilityIndexViolations =
        totalMaintainabilityIndexViolations > 0;
    final withArgumentsCountViolations = totalArgumentsCountViolations > 0;

    final tableContent = Element.tag('tbody');
    for (final record in sortedRecords) {
      final recordHaveCyclomaticComplexityViolations =
          record.cyclomaticComplexityViolations > 0;
      final recordHaveLinesOfExecutableCodeViolations =
          record.linesOfExecutableCodeViolations > 0;
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
          ..text = recordHaveLinesOfExecutableCodeViolations
              ? '${record.linesOfExecutableCode} / ${record.linesOfExecutableCodeViolations}'
              : '${record.linesOfExecutableCode}'
          ..classes.add(recordHaveLinesOfExecutableCodeViolations
              ? 'with-violations'
              : ''))
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
    final linesOfExecutableCodeTitle = withLinesOfExecutableCodeViolations
        ? _linesOfExecutableCodeWithViolations
        : _linesOfExecutableCode;
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
          ..append(Element.tag('th')..text = linesOfExecutableCodeTitle)
          ..append(Element.tag('th')..text = maintainabilityIndexTitle)
          ..append(Element.tag('th')..text = argumentsCountTitle)))
      ..append(tableContent);

    return Element.tag('div')
      ..classes.add('metric-wrapper')
      ..append(table)
      ..append(Element.tag('div')
        ..classes.add('metrics-totals')
        ..append(renderMetric(
            cyclomaticComplexityTitle,
            withCyclomaticComplexityViolations
                ? '$totalComplexity / $totalComplexityViolations'
                : '$totalComplexity',
            withViolation: withCyclomaticComplexityViolations))
        ..append(renderMetric(
            linesOfExecutableCodeTitle,
            withLinesOfExecutableCodeViolations
                ? '$totalLinesOfExecutableCode / $totalLinesOfExecutableCodeViolations'
                : '$totalLinesOfExecutableCode',
            withViolation: withLinesOfExecutableCodeViolations))
        ..append(renderMetric(
            maintainabilityIndexTitle,
            withMaintainabilityIndexViolations
                ? '${averageMaintainabilityIndex.toInt()} / $totalMaintainabilityIndexViolations'
                : '${averageMaintainabilityIndex.toInt()}',
            withViolation: withMaintainabilityIndexViolations))
        ..append(renderMetric(
            argumentsCountTitle,
            withArgumentsCountViolations
                ? '$averageArgumentsCount / $totalArgumentsCountViolations'
                : '$averageArgumentsCount',
            withViolation: withMaintainabilityIndexViolations)));
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
          linesOfExecutableCode: report.totalLinesOfExecutableCode,
          linesOfExecutableCodeViolations:
              report.totalLinesOfExecutableCodeViolations,
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
          linesOfExecutableCode: report.totalLinesOfExecutableCode,
          linesOfExecutableCodeViolations:
              report.totalLinesOfExecutableCodeViolations,
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
          ..classes.add('metrics-source-code__number')
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
          final complexityTooltip = Element.tag('div')
            ..classes.add('metrics-source-code__tooltip')
            ..append(Element.tag('div')
              ..classes.add('metrics-source-code__tooltip-title')
              ..text = 'Function stats:')
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(
                  _report(report.cyclomaticComplexity, _cyclomaticComplexity)))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(_report(
                  report.linesOfExecutableCode, _linesOfExecutableCode)))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(
                  _report(report.maintainabilityIndex, _maintainabilityIndex)))
            ..append(Element.tag('p')
              ..classes.add('metrics-source-code__tooltip-text')
              ..append(_report(report.argumentsCount, _nuberOfArguments)));

          final complexityIcon = Element.tag('div')
            ..classes.add('metrics-source-code__icon')
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

        final lineWithComplexityIncrement =
            functionReport.cyclomaticComplexityLines.containsKey(i);

        if (lineWithComplexityIncrement) {
          line = '$line +${functionReport.cyclomaticComplexityLines[i]}'.trim();
          complexityValueElement.text = line.replaceAll(' ', '&nbsp;');
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
            Element.tag('span')..text = '/${p.basename(record.relativePath)}'))
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
          htmlDocument.outerHtml.replaceAll('&amp;nbsp;', '&nbsp;'));
  }

  Element _generateSourceReportMetricsHeader(FileRecord record) {
    final report = UtilitySelector.fileReport(record, reportConfig);

    final totalMaintainabilityIndexViolations =
        report.totalMaintainabilityIndexViolations > 0;
    final withArgumentsCountViolations =
        report.totalArgumentsCountViolations > 0;
    final withCyclomaticComplexityViolations =
        report.totalCyclomaticComplexityViolations > 0;
    final withLinesOfExecutableCodeViolations =
        report.totalLinesOfExecutableCodeViolations > 0;

    return Element.tag('div')
      ..classes.add('metric-subheader')
      ..append(renderMetric(
          withCyclomaticComplexityViolations
              ? _cyclomaticComplexityWithViolations
              : _cyclomaticComplexity,
          withCyclomaticComplexityViolations
              ? '${report.totalCyclomaticComplexity} / ${report.totalCyclomaticComplexityViolations}'
              : '${report.totalCyclomaticComplexity}',
          withViolation: withCyclomaticComplexityViolations))
      ..append(renderMetric(
          withLinesOfExecutableCodeViolations
              ? _linesOfExecutableCodeWithViolations
              : _linesOfExecutableCode,
          withLinesOfExecutableCodeViolations
              ? '${report.totalLinesOfExecutableCode} / ${report.totalLinesOfExecutableCodeViolations}'
              : '${report.totalLinesOfExecutableCode}',
          withViolation: withLinesOfExecutableCodeViolations))
      ..append(renderMetric(
          totalMaintainabilityIndexViolations
              ? _maintainabilityIndexWithViolations
              : _maintainabilityIndex,
          totalMaintainabilityIndexViolations
              ? '${report.averageMaintainabilityIndex.toInt()} / ${report.totalMaintainabilityIndexViolations}'
              : '${report.averageMaintainabilityIndex.toInt()}',
          withViolation: totalMaintainabilityIndexViolations))
      ..append(renderMetric(
          withArgumentsCountViolations
              ? _nuberOfArgumentsWithViolations
              : _nuberOfArguments,
          withArgumentsCountViolations
              ? '${report.averageArgumentsCount} / ${report.totalArgumentsCountViolations}'
              : '${report.averageArgumentsCount}',
          withViolation: withArgumentsCountViolations));
  }

  Element _report(ReportMetric<num> metric, String humanReadableName) {
    final violationLevelText = metric.violationLevel.toString().toLowerCase();

    return Element.tag('div')
      ..classes.add('metrics-source-code__tooltip-section')
      ..append(Element.tag('p')
        ..classes.add('metrics-source-code__tooltip-text')
        ..append(Element.tag('span')
          ..classes.add('metrics-source-code__tooltip-label')
          ..text = '${humanReadableName.toLowerCase()}:&nbsp;')
        ..append(Element.tag('span')..text = metric.value.round().toString()))
      ..append(Element.tag('p')
        ..classes.add('metrics-source-code__tooltip-text')
        ..append(Element.tag('span')
          ..classes.add('metrics-source-code__tooltip-label')
          ..text = '${humanReadableName.toLowerCase()} violation level:&nbsp;')
        ..append(Element.tag('span')
          ..classes.add('metrics-source-code__tooltip-level')
          ..classes
              .add('metrics-source-code__tooltip-level--$violationLevelText')
          ..text = violationLevelText));
  }
}
