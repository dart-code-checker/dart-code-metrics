import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:glob/glob.dart';

const _usageHeader = 'Usage: metrics [options...] <directories>';
const _helpFlagName = 'help';
const _reporterOptionName = 'reporter';
const _cyclomaticComplexityThreshold = 'cyclomatic-complexity';
const _linesOfCodeThreshold = 'lines-of-code';
const _verboseName = 'verbose';
const _ignoredFilesName = 'ignore-files';
const _rootFolderName = 'root-folder';

final _parser = ArgParser()
  ..addFlag(_helpFlagName,
      abbr: 'h', help: 'Print this usage information.', negatable: false)
  ..addOption(_reporterOptionName,
      abbr: 'r',
      help: 'The format of the output of the analysis',
      valueHelp: 'console',
      allowed: ['console', 'json', 'html', 'codeclimate'],
      defaultsTo: 'console')
  ..addOption(_cyclomaticComplexityThreshold,
      help: 'Cyclomatic complexity threshold',
      valueHelp: '20',
      defaultsTo: '20', callback: (String i) {
    if (int.tryParse(i) == null) print('$_cyclomaticComplexityThreshold:');
  })
  ..addOption(_linesOfCodeThreshold,
      help: 'Lines of code threshold',
      valueHelp: '50',
      defaultsTo: '50', callback: (String i) {
    if (int.tryParse(i) == null) print('$_linesOfCodeThreshold:');
  })
  ..addOption(_rootFolderName,
      help: 'Root folder', valueHelp: './', defaultsTo: Directory.current.path)
  ..addOption(_ignoredFilesName,
      help: 'Filepaths in Glob syntax to be ignored',
      valueHelp: '{/**.g.dart,/**.template.dart}',
      defaultsTo: '{/**.g.dart,/**.template.dart}')
  ..addFlag(_verboseName, negatable: false);

void main(List<String> args) {
  try {
    final arguments = _parser.parse(args);

    if (arguments[_helpFlagName] as bool) {
      _showUsageAndExit(0);
    }

    if (arguments.rest.isEmpty) {
      throw _InvalidArgumentException(
          'Invalid number of directories. At least one must be specified');
    }

    arguments.rest.forEach((p) {
      if (!Directory(p).existsSync()) {
        throw _InvalidArgumentException(
            "$p doesn't exist or isn't a directory");
      }
    });

    // TODO: check that directories to analyze are all children of root folder

    _runAnalysis(
        arguments[_rootFolderName] as String,
        arguments.rest,
        arguments[_ignoredFilesName] as String,
        int.parse(arguments[_cyclomaticComplexityThreshold] as String),
        int.parse(arguments[_linesOfCodeThreshold] as String),
        arguments[_reporterOptionName] as String,
        arguments[_verboseName] as bool);
  } on FormatException catch (e) {
    print('${e.message}\n');
    _showUsageAndExit(1);
  } on _InvalidArgumentException catch (e) {
    print('${e.message}\n');
    _showUsageAndExit(1);
  }
}

void _showUsageAndExit(int exitCode) {
  print(_usageHeader);
  print(_parser.usage);
  exit(exitCode);
}

void _runAnalysis(
    String rootFolder,
    Iterable<String> analysisDirectories,
    String ignoreFilesPattern,
    int cyclomaticComplexityThreshold,
    int linesOfCodeThreshold,
    String reporterType,
    bool verbose) {
  var dartFilePaths = analysisDirectories.expand((directory) =>
      Glob('$directory**.dart')
          .listSync(root: rootFolder, followLinks: false)
          .whereType<File>()
          .map((entity) => entity.path));

  if (ignoreFilesPattern.isNotEmpty) {
    final ignoreFilesGlob = Glob(ignoreFilesPattern);
    dartFilePaths =
        dartFilePaths.where((path) => !ignoreFilesGlob.matches(path));
  }

  final recorder = MetricsAnalysisRecorder();
  final analyzer = MetricsAnalyzer(recorder);
  final runner = MetricsAnalysisRunner(recorder, analyzer, dartFilePaths,
      rootFolder: rootFolder)
    ..run();

  final config = Config(
      cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold,
      linesOfCodeWarningLevel: linesOfCodeThreshold);

  Reporter reporter;

  switch (reporterType) {
    case 'console':
      reporter = ConsoleReporter(reportConfig: config, reportAll: verbose);
      break;
    case 'json':
      reporter = JsonReporter(reportConfig: config);
      break;
    case 'html':
      reporter = HtmlReporter(reportConfig: config);
      break;
    case 'codeclimate':
      reporter = CodeClimateReporter(reportConfig: config);
      break;
    default:
      throw ArgumentError.value(reporterType, 'reporter');
  }

  reporter.report(runner.results()).forEach(print);
}

class _InvalidArgumentException implements Exception {
  final String message;
  _InvalidArgumentException(this.message);
}
