import 'dart:convert';
import 'dart:io';

import 'package:lcov/lcov.dart' as lcov;
import 'package:path/path.dart' as p;

void main() {
  final lcovReportFile = File('coverage/coverage.lcov');
  if (!lcovReportFile.existsSync()) {
    _printCoverageOutputDoesntExistBanner();

    return;
  }

  lcov.Report report;

  try {
    report = lcov.Report.fromCoverage(lcovReportFile.readAsStringSync());
  } on lcov.LcovException catch (err) {
    print('An error occurred: ${err.message}');

    return;
  }

  final uncoveredFiles = _getUncoveredFiles(report);
  _addFilesToReportAsUncovered(uncoveredFiles, report);

  lcovReportFile.writeAsStringSync(report.toString(), mode: FileMode.writeOnly);
  _printCoverageDetails(report);
}

void _printCoverageDetails(lcov.Report report) {
  final coveredLines =
      report.records.fold<int>(0, (count, record) => count + record.lines.hit);
  final totalLines = report.records
      .fold<int>(0, (count, record) => count + record.lines.found);

  print(
      '$coveredLines of $totalLines relevant lines covered (${(coveredLines * 100 / totalLines).toStringAsPrecision(4)}%)');
}

void _printCoverageOutputDoesntExistBanner() {
  print('Coverage lcov report does not exist.');
}

Set<String> _getUncoveredFiles(lcov.Report report) {
  final coveredFiles =
      report.records.map((record) => p.relative(record.sourceFile)).toSet();
  final sourceFiles =
      _findSourceFiles(Directory('lib'), false).map((f) => f.path).toSet();

  return sourceFiles.difference(coveredFiles);
}

void _addFilesToReportAsUncovered(Iterable<String> files, lcov.Report report) {
  report.records.addAll(files.map(_fileToUncoveredRecord));
}

lcov.Record _fileToUncoveredRecord(String filePath) {
  final uncoveredLines = LineSplitter.split(File(filePath).readAsStringSync())
      .map((l) => l.trim())
      .toList()
      .asMap()
      .entries
      .where((e) =>
          e.value.isNotEmpty &&
          !e.value.startsWith('import') &&
          !e.value.startsWith('library') &&
          !e.value.startsWith('export') &&
          !e.value.startsWith('//') &&
          e.value != '}')
      .map((e) => lcov.LineData(e.key + 1));

  return lcov.Record(filePath,
      lines: lcov.LineCoverage(uncoveredLines.length, 0, uncoveredLines));
}

Iterable<File> _findSourceFiles(Directory directory, bool skipGenerated) {
  final sourceFiles = <File>[];
  for (final fileOrDir in directory.listSync()) {
    if (fileOrDir is File &&
        _isSourceFileHaveValidExtension(fileOrDir) &&
        _isSourceFileNotPartOfLibrary(fileOrDir)) {
      sourceFiles.add(fileOrDir);
    } else if (fileOrDir is Directory &&
        p.basename(fileOrDir.path) != 'packages') {
      sourceFiles.addAll(_findSourceFiles(fileOrDir, skipGenerated));
    }
  }

  return sourceFiles;
}

bool _isSourceFileHaveValidExtension(File file) =>
    p.extension(file.path)?.endsWith('.dart') ?? false;

bool _isSourceFileNotPartOfLibrary(File file) =>
    file.readAsLinesSync().every((line) => !line.startsWith('part of '));
