import 'package:meta/meta.dart';

import 'edge_insets_param.dart';

@immutable
class EdgeInsetsData {
  final String className;
  final String constructorName;
  final List<EdgeInsetsParam> params;

  const EdgeInsetsData(this.className, this.constructorName, this.params);
}
