import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';

import '../../src/analyzers/lint_analyzer/constants.dart';
import '../../src/analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../config_builder/models/deprecated_option.dart';

const usageHeader = 'Usage: metrics [arguments...] <directories>';

const helpFlagName = 'help';
const reporterName = 'reporter';
const excludedName = 'exclude';
const rootFolderName = 'root-folder';

const consoleReporter = 'console';
const consoleVerboseReporter = 'console-verbose';
const codeClimateReporter = 'codeclimate';
const htmlReporter = 'html';
const jsonReporter = 'json';
const githubReporter = 'github';
const gitlabCodeClimateReporter = 'gitlab';

const reportFolder = 'output-directory';
const setExitOnViolationLevel = 'set-exit-on-violation-level';

ArgParser argumentsParser() {
  final parser = ArgParser()..addSeparator('');

  _appendHelpOption(parser);
  parser.addSeparator('');
  _appendReporterOption(parser);
  parser.addSeparator('');
  _appendMetricsThresholdOptions(parser);
  parser.addSeparator('');
  _appendRootOption(parser);
  _appendExcludeOption(parser);
  parser.addSeparator('');
  _appendExitOption(parser);

  return parser;
}

void _appendHelpOption(ArgParser parser) {
  parser.addFlag(
    helpFlagName,
    abbr: 'h',
    help: 'Print this usage information.',
    negatable: false,
  );
}

void _appendReporterOption(ArgParser parser) {
  parser
    ..addOption(
      reporterName,
      abbr: 'r',
      help: 'The format of the output of the analysis',
      valueHelp: consoleReporter,
      allowed: [
        consoleReporter,
        consoleVerboseReporter,
        codeClimateReporter,
        githubReporter,
        gitlabCodeClimateReporter,
        htmlReporter,
        jsonReporter,
      ],
      defaultsTo: consoleReporter,
    )
    ..addOption(
      reportFolder,
      abbr: 'o',
      help: 'Write HTML output to OUTPUT',
      valueHelp: 'OUTPUT',
      defaultsTo: 'metrics',
    );
}

void _appendMetricsThresholdOptions(ArgParser parser) {
  for (final metric in metrics(config: {})) {
    final deprecation = deprecatedOptions
        .firstWhereOrNull((option) => option.deprecated == metric.id);
    final deprecationMessage = deprecation != null
        ? ' (deprecated, will be removed in ${deprecation.supportUntilVersion} version)'
        : '';

    parser.addOption(
      metric.id,
      help: '${metric.documentation.name} threshold$deprecationMessage',
      valueHelp: '${metric.threshold}',
      callback: (i) {
        if (i != null && int.tryParse(i) == null) {
          print("'$i' invalid value for argument ${metric.documentation.name}");
        }
      },
    );
  }
  parser.addOption(
    linesOfExecutableCodeKey,
    help:
        'Lines of executable code threshold (deprecated, will be removed in 4.0 version)',
    valueHelp: '$linesOfExecutableCodeDefaultWarningLevel',
    callback: (i) {
      if (i != null && int.tryParse(i) == null) {
        print("'$i' invalid value for argument $linesOfExecutableCodeKey");
      }
    },
  );
}

void _appendRootOption(ArgParser parser) {
  parser.addOption(
    rootFolderName,
    help: 'Root folder',
    valueHelp: './',
    defaultsTo: Directory.current.path,
  );
}

void _appendExcludeOption(ArgParser parser) {
  parser.addOption(
    excludedName,
    help: 'File paths in Glob syntax to be exclude',
    valueHelp: '{/**.g.dart,/**.template.dart}',
    defaultsTo: '{/**.g.dart,/**.template.dart}',
  );
}

void _appendExitOption(ArgParser parser) {
  parser.addOption(
    setExitOnViolationLevel,
    allowed: ['noted', 'warning', 'alarm'],
    valueHelp: 'warning',
    help:
        'Set exit code 2 if code violations same or higher level than selected are detected',
  );
}
