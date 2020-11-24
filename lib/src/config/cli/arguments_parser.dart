import 'dart:io';

import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../config.dart';

const usageHeader = 'Usage: metrics [options...] <directories>';
const helpFlagName = 'help';
const reporterName = 'reporter';
const verboseName = 'verbose';
const ignoredFilesName = 'ignore-files';
const rootFolderName = 'root-folder';
const setExitOnViolationLevel = 'set-exit-on-violation-level';

ArgParser argumentsParser() {
  final parser = ArgParser();

  _appendHelpOption(parser);
  _appendReporterOption(parser);
  _appendMetricsThresholdOptions(parser);
  _appendRootOption(parser);
  _appendExcludesOption(parser);
  _appendVerboseOption(parser);
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
  parser.addOption(
    reporterName,
    abbr: 'r',
    help: 'The format of the output of the analysis',
    valueHelp: 'console',
    allowed: ['console', 'github', 'json', 'html', 'codeclimate'],
    defaultsTo: 'console',
  );
}

@immutable
class _MetricOption {
  final String name;
  final String help;
  final int defaultValue;

  const _MetricOption(this.name, this.help, this.defaultValue);
}

void _appendMetricsThresholdOptions(ArgParser parser) {
  const metrics = [
    _MetricOption(
      cyclomaticComplexityKey,
      'Cyclomatic complexity threshold',
      cyclomaticComplexityDefaultWarningLevel,
    ),
    _MetricOption(
      linesOfExecutableCodeKey,
      'Lines of executable code threshold',
      linesOfExecutableCodeDefaultWarningLevel,
    ),
    _MetricOption(
      numberOfArgumentsKey,
      'Number of arguments threshold',
      numberOfArgumentsDefaultWarningLevel,
    ),
    _MetricOption(
      numberOfMethodsKey,
      'Number of methods threshold',
      numberOfMethodsDefaultWarningLevel,
    ),
    _MetricOption(
      maximumNestingKey,
      'Maximum nesting threshold',
      maximumNestingDefaultWarningLevel,
    ),
  ];

  for (final metric in metrics) {
    parser.addOption(
      metric.name,
      help: metric.help,
      valueHelp: '${metric.defaultValue}',
      // ignore: avoid_types_on_closure_parameters
      callback: (String i) {
        if (i != null && int.tryParse(i) == null) {
          print("'$i' invalid value for argument ${metric.name}");
        }
      },
    );
  }
}

void _appendRootOption(ArgParser parser) {
  parser.addOption(
    rootFolderName,
    help: 'Root folder',
    valueHelp: './',
    defaultsTo: Directory.current.path,
  );
}

void _appendExcludesOption(ArgParser parser) {
  parser.addOption(
    ignoredFilesName,
    help: 'Filepaths in Glob syntax to be ignored',
    valueHelp: '{/**.g.dart,/**.template.dart}',
    defaultsTo: '{/**.g.dart,/**.template.dart}',
  );
}

void _appendVerboseOption(ArgParser parser) {
  parser.addFlag(
    verboseName,
    negatable: false,
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
