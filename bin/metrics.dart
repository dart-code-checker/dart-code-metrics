import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:glob/glob.dart';

const usageHeader = 'Usage: metrics [options...] <directory>';
const helpFlagName = 'help';
const reporterOptionName = 'reporter';
const cyclomaticComplexityThreshold = 'cyclomatic-complexity';
const linesOfCodeThreshold = 'lines-of-code';
const verboseName = 'verbose';
const ignoredFilesName = 'ignore-files';
const rootFolderName = 'root-folder';

final parser = ArgParser()
  ..addFlag(helpFlagName,
      abbr: 'h', help: 'Print this usage information.', negatable: false)
  ..addOption(reporterOptionName,
      abbr: 'r',
      help: 'The format of the output of the analysis',
      valueHelp: 'console',
      allowed: ['console', 'json', 'html', 'codeclimate'],
      defaultsTo: 'console')
  ..addOption(cyclomaticComplexityThreshold,
      help: 'Cyclomatic complexity threshold',
      valueHelp: '20',
      defaultsTo: '20')
  ..addOption(linesOfCodeThreshold,
      help: 'Lines of code threshold', valueHelp: '50', defaultsTo: '50')
  ..addOption(rootFolderName,
      help: 'Root folder',
      valueHelp: './',
      defaultsTo: Directory.current.path)
  ..addOption(ignoredFilesName,
      help: 'Filepaths in Glob syntax to be ignored',
      valueHelp: '{/**.g.dart,/**.template.dart}',
      defaultsTo: '{/**.g.dart,/**.template.dart}')
  ..addFlag(verboseName, negatable: false);

void main(List<String> args) {
  ArgResults arguments;

  try {
    arguments = parser.parse(args);
  } on FormatException catch (_) {
    _showUsageAndExit();
  }

  if (arguments == null ||
      arguments[helpFlagName] as bool ||
      arguments.rest.length != 1) {
    _showUsageAndExit();
  } else if (!Directory(arguments.rest.single).existsSync()) {
    print("Can't find directory ${arguments.rest.single}");
    _showUsageAndExit();
  }

  _runAnalysis(
      arguments[rootFolderName] as String,
      arguments.rest.single,
      arguments[ignoredFilesName] as String,
      int.parse(arguments[cyclomaticComplexityThreshold] as String),
      int.parse(arguments[linesOfCodeThreshold] as String),
      arguments[reporterOptionName] as String,
      arguments[verboseName] as bool);
}

void _showUsageAndExit() {
  print(usageHeader);
  print(parser.usage);
  exit(1);
}

void _runAnalysis(String rootFolder, String analysisDirectory, String ignoreFilesPattern,
    int cyclomaticComplexityThreshold, int linesOfCodeThreshold, String reporterType, bool verbose) {
  var dartFilePaths = Glob('$analysisDirectory**.dart')
      .listSync(root: rootFolder, followLinks: false)
      .whereType<File>()
      .map((entity) => entity.path);

  if (ignoreFilesPattern.isNotEmpty) {
    final ignoreFilesGlob = Glob(ignoreFilesPattern);
    dartFilePaths = dartFilePaths.where((path) => !ignoreFilesGlob.matches(path));
  }

  final recorder = MetricsAnalysisRecorder();
  final analyzer = MetricsAnalyzer(recorder);
  final runner = MetricsAnalysisRunner(recorder, analyzer, dartFilePaths, rootFolder: rootFolder)..run();

  final config = Config(
      cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold, linesOfCodeWarningLevel: linesOfCodeThreshold);

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
