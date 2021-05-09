import 'dart:io';

import 'package:args/args.dart';

import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'arguments_parser.dart';
import 'arguments_validation.dart';
import 'exceptions/arguments_validation_exceptions.dart';
import 'models/flag_names.dart';
import 'models/parsed_arguments.dart';

// ignore: avoid_classes_with_only_static_members
class ArgumentsBuilder {
  static final _parser = argumentsParser();

  static ParsedArguments? getArguments(List<String> args) {
    try {
      final arguments = _parser.parse(args);

      if (arguments[FlagNames.help] as bool) {
        _showUsageAndExit(0);
      }

      validateArguments(arguments);

      return ParsedArguments(
        rootFolder: arguments[FlagNames.rootFolder] as String,
        reporterName: arguments[FlagNames.reporter] as String,
        reportFolder: arguments[FlagNames.reportFolder] as String,
        metricValueLevel: MetricValueLevel.fromString(
          arguments[FlagNames.setExitOnViolationLevel] as String?,
        ),
        folders: arguments.rest,
        exclude: arguments[FlagNames.exclude] as String,
        metricsConfig: {
          for (final metric in getMetrics(config: {}))
            if (arguments.wasParsed(metric.id))
              metric.id: arguments[metric.id] as Object,
        },
      );
    } on ArgParserException catch (e) {
      print('${e.message}\n');
      _showUsageAndExit(1);
    } on InvalidArgumentException catch (e) {
      print('${e.message}\n');
      _showUsageAndExit(1);
    }

    return null;
  }

  static void _showUsageAndExit(int exitCode) {
    print(FlagNames.usage);
    print(_parser.usage);

    exit(exitCode);
  }
}
