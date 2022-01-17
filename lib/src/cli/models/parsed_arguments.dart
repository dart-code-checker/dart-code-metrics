/// Represents the arguments parsed from raw cli arguments.
class ParsedArguments {
  final String excludePath;
  final Map<String, Object> metricsConfig;

  const ParsedArguments({
    required this.excludePath,
    required this.metricsConfig,
  });
}
