import 'dart:io';

import 'package:args/args.dart';

import '../../metrics_analyzer.dart';

const usageHeader = 'Usage: metrics [options...] <directories>';
const helpFlagName = 'help';
const reporterName = 'reporter';
const cyclomaticComplexityThreshold = 'cyclomatic-complexity';
const linesOfExecutableCodeThreshold = 'lines-of-executable-code';
const numberOfArgumentsThreshold = 'number-of-arguments';
const numberOfMethodsThreshold = 'number-of-methods';
const verboseName = 'verbose';
const ignoredFilesName = 'ignore-files';
const rootFolderName = 'root-folder';
const setExitOnViolationLevel = 'set-exit-on-violation-level';

// ignore_for_file: avoid_types_on_closure_parameters

ArgParser argumentsParser() => ArgParser()
  ..addFlag(helpFlagName,
      abbr: 'h', help: 'Print this usage information.', negatable: false)
  ..addOption(reporterName,
      abbr: 'r',
      help: 'The format of the output of the analysis',
      valueHelp: 'console',
      allowed: ['console', 'github', 'json', 'html', 'codeclimate'],
      defaultsTo: 'console')
  ..addOption(cyclomaticComplexityThreshold, help: 'Cyclomatic complexity threshold', valueHelp: '$cyclomaticComplexityDefaultWarningLevel',
      callback: (String i) {
    if (i != null && int.tryParse(i) == null) {
      _printInvalidArgumentValue(cyclomaticComplexityThreshold, i);
    }
  })
  ..addOption(linesOfExecutableCodeThreshold, help: 'Lines of executable code threshold', valueHelp: '$linesOfExecutableCodeDefaultWarningLevel',
      callback: (String i) {
    if (i != null && int.tryParse(i) == null) {
      _printInvalidArgumentValue(linesOfExecutableCodeThreshold, i);
    }
  })
  ..addOption(numberOfArgumentsThreshold,
      help: 'Number of arguments threshold',
      valueHelp: '$numberOfArgumentsDefaultWarningLevel', callback: (String i) {
    if (i != null && int.tryParse(i) == null) {
      _printInvalidArgumentValue(numberOfArgumentsThreshold, i);
    }
  })
  ..addOption(numberOfMethodsThreshold,
      help: 'Number of methods threshold',
      valueHelp: '$numberOfMethodsDefaultWarningLevel', callback: (String i) {
    if (i != null && int.tryParse(i) == null) {
      _printInvalidArgumentValue(numberOfMethodsThreshold, i);
    }
  })
  ..addOption(rootFolderName,
      help: 'Root folder', valueHelp: './', defaultsTo: Directory.current.path)
  ..addOption(ignoredFilesName,
      help: 'Filepaths in Glob syntax to be ignored',
      valueHelp: '{/**.g.dart,/**.template.dart}',
      defaultsTo: '{/**.g.dart,/**.template.dart}')
  ..addFlag(verboseName, negatable: false)
  ..addOption(setExitOnViolationLevel,
      allowed: ['noted', 'warning', 'alarm'],
      valueHelp: 'warning',
      help: 'Set exit code 2 if code violations same or higher level than selected are detected');

void _printInvalidArgumentValue(String argument, String value) {
  print("'$value' invalid value for argument $argument");
}
