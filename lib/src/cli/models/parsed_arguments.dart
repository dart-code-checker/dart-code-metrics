import 'package:meta/meta.dart';

@immutable
class ParsedArguments {
  final String excludePath;
  final Map<String, Object> metricsConfig;

  const ParsedArguments({
    required this.excludePath,
    required this.metricsConfig,
  });
}
