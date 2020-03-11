import 'dart:convert';

import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Machine-readable report in JSON format
class JsonReporter implements Reporter {
  final Config reportConfig;

  JsonReporter({@required this.reportConfig});

  @override
  void report(Iterable<ComponentRecord> records) {
    if (records?.isEmpty ?? true) {
      return;
    }

    print(json.encode(records.map(_analysisRecordToJson).toList()));
  }

  Map<String, Object> _analysisRecordToJson(ComponentRecord record) => {
        'source': record.relativePath,
        'records': record.records.asMap().map((key, value) {
          final report = UtilitySelector.functionReport(value, reportConfig);
          return MapEntry(key, {
            'cyclomatic-complexity': report.cyclomaticComplexity,
            'cyclomatic-complexity-violation-level': report
                .cyclomaticComplexityViolationLevel
                .toString()
                .toLowerCase(),
            'lines-of-code': report.linesOfCode,
            'lines-of-code-violation-level':
                report.linesOfCodeViolationLevel.toString().toLowerCase(),
            'maintainability-index': report.maintainabilityIndex.toInt(),
            'maintainability-index-violation-level': report
                .maintainabilityIndexViolationLevel
                .toString()
                .toLowerCase(),
          });
        })
      };
}
