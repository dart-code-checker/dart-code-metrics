import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/lint_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/context_message.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';

const src1Path = 'test/resources/abstract_class.dart';
const src2Path = 'test/resources/class_with_factory_constructors.dart';

class _DeclarationMock extends Mock implements Declaration {}

final _class1Report = Report(
  location: SourceSpan(SourceLocation(0), SourceLocation(10), 'class body'),
  declaration: _DeclarationMock(),
  metrics: const [
    MetricValue<int>(
      metricsId: 'id',
      documentation: MetricDocumentation(
        name: 'metric1',
        shortName: 'MTR1',
        brief: '',
        measuredType: EntityType.classEntity,
        recomendedThreshold: 0,
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
        brief: '',
        measuredType: EntityType.methodEntity,
        recomendedThreshold: 0,
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
        brief: '',
        measuredType: EntityType.methodEntity,
        recomendedThreshold: 0,
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
        brief: '',
        measuredType: EntityType.methodEntity,
        recomendedThreshold: 0,
      ),
      value: 5,
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
    classes: const {},
    functions: {'function': _function3Report},
    issues: [_issueReport1],
    antiPatternCases: [_issueReport2],
  ),
];
