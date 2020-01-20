import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:metrics/src/models/component_record.dart';
import 'package:metrics/src/models/config.dart';
import 'package:metrics/src/reporters/reporter.dart';
import 'package:metrics/src/reporters/utility_selector.dart';

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
            'cyclomatic-complexity-violation-level': report.cyclomaticComplexityViolationLevel.toString().toLowerCase(),
            'lines-of-code': report.linesOfCode,
            'lines-of-code-violation-level': report.linesOfCodeViolationLevel.toString().toLowerCase(),
            'maintainability-index': report.maintainabilityIndex.toInt(),
            'maintainability-index-violation-level': report.maintainabilityIndexViolationLevel.toString().toLowerCase(),
          });
        })
      };
}
