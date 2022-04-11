import 'package:meta/meta.dart';

@immutable
class EdgeInsetsParam {
  final String? name;
  final num? value;

  const EdgeInsetsParam({required this.value, this.name});
}
