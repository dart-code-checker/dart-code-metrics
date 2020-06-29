import 'package:meta/meta.dart';

import 'report_metric.dart';

@immutable
class ComponentReport {
  final ReportMetric<int> methodsCount;

  const ComponentReport({@required this.methodsCount});
}
