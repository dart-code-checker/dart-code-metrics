import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/context_message.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/summary_lint_report_record.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/summary_lint_report_record_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';

import '../../../../../stubs_builders.dart';

const src1Path = 'test/resources/abstract_class.dart';
const src2Path = 'test/resources/class_with_factory_constructors.dart';

class _DeclarationMock extends Mock implements Declaration {}

final _file1Report = Report(
  location: SourceSpan(SourceLocation(0), SourceLocation(12), 'file content'),
  declaration: _DeclarationMock(),
  metrics: const [
    MetricValue<int>(
      metricsId: 'file-metric-id',
      documentation: MetricDocumentation(
        name: 'metric1',
        shortName: 'MTR1',
        measuredType: EntityType.fileEntity,
        recommendedThreshold: 0,
      ),
      value: 100,
      unitType: 'units',
      level: MetricValueLevel.warning,
      comment: 'metric comment',
    ),
  ],
);

final _class1Report = Report(
  location: SourceSpan(SourceLocation(0), SourceLocation(10), 'class body'),
  declaration: _DeclarationMock(),
  metrics: const [
    MetricValue<int>(
      metricsId: 'id',
      documentation: MetricDocumentation(
        name: 'metric1',
        shortName: 'MTR1',
        measuredType: EntityType.classEntity,
        recommendedThreshold: 0,
      ),
      value: 0,
      level: MetricValueLevel.none,
      comment: 'metric comment',
    ),
  ],
);

final _function1Report = Report(
  location:
      SourceSpan(SourceLocation(0), SourceLocation(16), 'constructor body'),
  declaration: _DeclarationMock(),
  metrics: const [
    MetricValue<int>(
      metricsId: 'id',
      documentation: MetricDocumentation(
        name: 'metric2',
        shortName: 'MTR2',
        measuredType: EntityType.methodEntity,
        recommendedThreshold: 0,
      ),
      value: 10,
      level: MetricValueLevel.alarm,
      comment: 'metric comment',
      recommendation: 'refactoring',
    ),
  ],
);

final _function2Report = Report(
  location: SourceSpan(SourceLocation(0), SourceLocation(11), 'method body'),
  declaration: _DeclarationMock(),
  metrics: [
    MetricValue<int>(
      metricsId: 'id2',
      documentation: const MetricDocumentation(
        name: 'metric3',
        shortName: 'MTR3',
        measuredType: EntityType.methodEntity,
        recommendedThreshold: 0,
      ),
      value: 1,
      level: MetricValueLevel.none,
      comment: 'metric comment',
      context: [
        ContextMessage(
          message: 'begin of method',
          location: SourceSpan(SourceLocation(0), SourceLocation(6), 'method'),
        ),
      ],
    ),
  ],
);

final _function3Report = Report(
  location:
      SourceSpan(SourceLocation(0), SourceLocation(20), 'simple function body'),
  declaration: _DeclarationMock(),
  metrics: const [
    MetricValue<int>(
      metricsId: 'id',
      documentation: MetricDocumentation(
        name: 'metric4',
        shortName: 'MTR4',
        measuredType: EntityType.methodEntity,
        recommendedThreshold: 0,
      ),
      value: 5,
      unitType: 'units',
      level: MetricValueLevel.warning,
      comment: 'metric comment',
    ),
  ],
);

final _issueReport1 = Issue(
  ruleId: 'id',
  documentation: Uri.parse('https://documentation.com'),
  location:
      SourceSpan(SourceLocation(0), SourceLocation(20), 'simple function body'),
  severity: Severity.warning,
  message: 'simple message',
  verboseMessage: 'verbose message',
  suggestion: const Replacement(
    comment: 'replacement comment',
    replacement: 'function body',
  ),
);

final _issueReport2 = Issue(
  ruleId: 'designId',
  documentation: Uri.parse('https://documentation.com'),
  location:
      SourceSpan(SourceLocation(0), SourceLocation(20), 'simple function body'),
  severity: Severity.style,
  message: 'simple design message',
  verboseMessage: 'verbose design message',
);

final Iterable<LintFileReport> testReport = [
  LintFileReport(
    path: src1Path,
    relativePath: src1Path,
    file: _file1Report,
    classes: {'class': _class1Report},
    functions: {
      'class.constructor': _function1Report,
      'class.method': _function2Report,
    },
    issues: const [],
    antiPatternCases: const [],
  ),
  LintFileReport(
    path: src2Path,
    relativePath: src2Path,
    file: buildReportStub(),
    classes: const {},
    functions: {'function': _function3Report},
    issues: [_issueReport1],
    antiPatternCases: [_issueReport2],
  ),
];

const Iterable<SummaryLintReportRecord<Object>> testSummary = [
  SummaryLintReportRecord<Iterable<String>>(
    status: SummaryLintReportRecordStatus.none,
    title: 'Scanned package folders',
    value: ['bin', 'example', 'lib', 'test'],
  ),
  SummaryLintReportRecord<int>(
    status: SummaryLintReportRecordStatus.warning,
    title: 'Found issues',
    value: 5,
  ),
  SummaryLintReportRecord<int>(
    status: SummaryLintReportRecordStatus.warning,
    title: 'Average Source Lines of Code per method',
    value: 30,
    violations: 2,
  ),
];
