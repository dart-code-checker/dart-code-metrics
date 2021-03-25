// ignore_for_file: public_member_api_docs
import 'package:meta/meta.dart';

import '../../models/metric_value.dart';

@immutable
class ComponentReport {
  final MetricValue<int> methodsCount;
  final MetricValue<double> weightOfClass;

  const ComponentReport({
    @required this.methodsCount,
    @required this.weightOfClass,
  });
}
