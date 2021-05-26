import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';

import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../config_builder/models/deprecated_option.dart';
import 'models/flag_names.dart';

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
    FlagNames.help,
    abbr: 'h',
    help: 'Print this usage information.',
    negatable: false,
  );
}

void _appendReporterOption(ArgParser parser) {
  parser
    ..addOption(
      FlagNames.reporter,
      abbr: 'r',
      help: 'The format of the output of the analysis',
      valueHelp: FlagNames.consoleReporter,
      allowed: [
        FlagNames.consoleReporter,
        FlagNames.consoleVerboseReporter,
        FlagNames.codeClimateReporter,
        FlagNames.githubReporter,
        FlagNames.gitlabCodeClimateReporter,
        FlagNames.htmlReporter,
        FlagNames.jsonReporter,
      ],
      defaultsTo: FlagNames.consoleReporter,
    )
    ..addOption(
      FlagNames.reportFolder,
      abbr: 'o',
      help: 'Write HTML output to OUTPUT',
      valueHelp: 'OUTPUT',
      defaultsTo: 'metrics',
    );
}

void _appendMetricsThresholdOptions(ArgParser parser) {
  for (final metric in getMetrics(config: {})) {
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
}

void _appendRootOption(ArgParser parser) {
  parser.addOption(
    FlagNames.rootFolder,
    help: 'Root folder',
    valueHelp: './',
    defaultsTo: Directory.current.path,
  );
}

void _appendExcludeOption(ArgParser parser) {
  parser.addOption(
    FlagNames.exclude,
    help: 'File paths in Glob syntax to be exclude',
    valueHelp: '{/**.g.dart,/**.template.dart}',
    defaultsTo: '{/**.g.dart,/**.template.dart}',
  );
}

void _appendExitOption(ArgParser parser) {
  parser.addOption(
    FlagNames.setExitOnViolationLevel,
    allowed: ['noted', 'warning', 'alarm'],
    valueHelp: 'warning',
    help:
        'Set exit code 2 if code violations same or higher level than selected are detected',
  );
}
