// ignore_for_file: public_member_api_docs
import 'dart:io';

import 'package:args/args.dart';
import 'package:meta/meta.dart';

import '../config.dart';

const usageHeader = 'Usage: metrics [options...] <directories>';
const helpFlagName = 'help';
const reporterName = 'reporter';
const verboseName = 'verbose';
const gitlabCompatibilityName = 'gitlab';
const reportFolder = 'output-directory';
const ignoredFilesName = 'ignore-files';
const rootFolderName = 'root-folder';
const setExitOnViolationLevel = 'set-exit-on-violation-level';

ArgParser argumentsParser() {
  final parser = ArgParser();

  _appendHelpOption(parser);
  parser.addSeparator('');
  _appendReporterOption(parser);
  parser.addSeparator('');
  _appendMetricsThresholdOptions(parser);
  parser.addSeparator('');
  _appendRootOption(parser);
  _appendExcludesOption(parser);
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
      valueHelp: 'console',
      allowed: ['console', 'github', 'json', 'html', 'codeclimate'],
      defaultsTo: 'console',
    )
    ..addFlag(
      verboseName,
      help: 'Additional flag for Console reporter',
      negatable: false,
    )
    ..addFlag(
      gitlabCompatibilityName,
      help:
          'Additional flag for Code Climate reporter to report in GitLab Code Quality format',
      negatable: false,
    )
    ..addOption(
      reportFolder,
      abbr: 'o',
      help: 'Write HTML output to OUTPUT',
      valueHelp: 'OUTPUT',
      defaultsTo: 'metrics',
    );
}

@immutable
class _MetricOption<T> {
  final String name;
  final String help;
  final T defaultValue;

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
    _MetricOption(
      weightOfClassKey,
      'Weight Of Class threshold',
      weightOfClassDefaultWarningLevel,
    ),
  ];

  for (final metric in metrics) {
    parser.addOption(
      metric.name,
      help: metric.help,
      valueHelp: '${metric.defaultValue}',
      // ignore: avoid_types_on_closure_parameters
      callback: (String value) {
        var invalid = true;
        if (metric.defaultValue is int) {
          invalid = value != null && int.tryParse(value) == null;
        } else if (metric.defaultValue is double) {
          invalid = value != null && double.tryParse(value) == null;
        }

        if (invalid) {
          print("'$value' invalid value for argument ${metric.name}");
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

void _appendExitOption(ArgParser parser) {
  parser.addOption(
    setExitOnViolationLevel,
    allowed: ['noted', 'warning', 'alarm'],
    valueHelp: 'warning',
    help:
        'Set exit code 2 if code violations same or higher level than selected are detected',
  );
}
