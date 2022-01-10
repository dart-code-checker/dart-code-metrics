import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../stubs_builders.dart';

const metric1Id = 'metric-id1';
const metric2Id = 'metric-id2';
const metric3Id = 'metric-id3';

class _DeclarationMock extends Mock implements Declaration {}

void main() {
  group('Report', () {
    late Report report;

    setUp(() {
      report = buildReportStub(metrics: [
        buildMetricValueStub<int>(
          id: metric1Id,
          value: 10,
          level: MetricValueLevel.alarm,
        ),
        buildMetricValueStub<double>(
          id: metric2Id,
          value: 15.5,
          level: MetricValueLevel.warning,
        ),
      ]);
    });

    test('metric returns value of required metric or null', () {
      expect(report.metric(metric1Id)?.metricsId, equals(metric1Id));
      expect(report.metric(metric2Id)?.metricsId, equals(metric2Id));
      expect(report.metric(metric3Id), isNull);
    });

    test(
      'metricsLevel returns maximum severe level from all reported values',
      () {
        expect(report.metricsLevel, equals(MetricValueLevel.alarm));
        expect(
          Report(
            location: SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
            metrics: const [],
            declaration: _DeclarationMock(),
          ).metricsLevel,
          equals(MetricValueLevel.none),
        );
      },
    );
  });
}
