import 'dart:io';

import 'package:args/args.dart';
import 'package:glob/glob.dart';
import 'package:metrics/metrics_analyzer.dart';
import 'package:metrics/reporters.dart';

void main(List<String> args) {
  const helpFlagName = 'help';
  const reporterOptionName = 'reporter';
  const cyclomaticComplexityThreshold = 'cyclomatic-complexity';
  const linesOfCodeThreshold = 'lines-of-code';
  const verboseName = 'verbose';
  const ignoredFilesName = 'ignore-files';
  const rootFolderName = 'root-folder';

  var showUsage = false;

  final parser = ArgParser()
    ..addFlag(helpFlagName, abbr: 'h', help: 'Print this usage information.', negatable: false)
    ..addOption(reporterOptionName,
        abbr: 'r',
        help: 'The format of the output of the analysis',
        valueHelp: 'console',
        allowed: ['console', 'json', 'html', 'codeclimate'],
        defaultsTo: 'console')
    ..addOption(cyclomaticComplexityThreshold,
        help: 'Cyclomatic complexity threshold', valueHelp: '20', defaultsTo: '20')
    ..addOption(linesOfCodeThreshold, help: 'Lines of code threshold', valueHelp: '50', defaultsTo: '50')
    ..addOption(rootFolderName, help: 'Root folder', valueHelp: './', defaultsTo: Directory.current.path)
    ..addOption(ignoredFilesName,
        help: 'Filepaths in Glob syntax to be ignored',
        valueHelp: '{/**.g.dart,/**.template.dart}',
        defaultsTo: '{/**.g.dart,/**.template.dart}')
    ..addFlag(verboseName, negatable: false);

  ArgResults arguments;

  try {
    arguments = parser.parse(args);
  } on FormatException catch (_) {
    showUsage = true;
  }

  if (arguments == null || arguments[helpFlagName] as bool || arguments.rest.length != 1) {
    showUsage = true;
  }

  if (showUsage) {
    print('Usage: metrics [options...] <directory>');
    print(parser.usage);
    return;
  }

  final rootFolder = arguments[rootFolderName] as String;
  var dartFilePaths = Glob('${arguments.rest.first}**.dart')
      .listSync(root: rootFolder, followLinks: false)
      .whereType<File>()
      .map((entity) => entity.path);

  final ignoreFilesPattern = arguments[ignoredFilesName] as Object;
  if (ignoreFilesPattern is String && ignoreFilesPattern.isNotEmpty) {
    final ignoreFilesGlob = Glob(ignoreFilesPattern);
    dartFilePaths = dartFilePaths.where((path) => !ignoreFilesGlob.matches(path));
  }

  final recorder = MetricsAnalysisRecorder();
  final analyzer = MetricsAnalyzer(recorder);
  final runner = MetricsAnalysisRunner(recorder, analyzer, dartFilePaths, rootFolder: rootFolder)..run();

  final config = Config(
      cyclomaticComplexityWarningLevel: int.parse(arguments[cyclomaticComplexityThreshold] as String),
      linesOfCodeWarningLevel: int.parse(arguments[linesOfCodeThreshold] as String));

  switch (arguments[reporterOptionName] as String) {
    case 'console':
      ConsoleReporter(reportConfig: config, reportAll: arguments[verboseName] as bool).report(runner.results());
      break;
    case 'json':
      JsonReporter(reportConfig: config).report(runner.results());
      break;
    case 'html':
      HtmlReporter(reportConfig: config).report(runner.results());
      break;
    case 'codeclimate':
      CodeClimateReporter(reportConfig: config).report(runner.results());
      break;
    default:
      throw ArgumentError.value(arguments[reporterOptionName], reporterOptionName);
  }
}
