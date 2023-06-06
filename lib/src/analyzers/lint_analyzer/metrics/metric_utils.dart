import 'models/metric_value_level.dart';

/// Returns the url of a page containing documentation associated with [metricId]
Uri documentation(String metricId) => Uri(
      scheme: 'https',
      host: 'dcm.dev',
      pathSegments: [
        'docs',
        'metrics',
        metricId,
      ],
    );

/// Returns a nullable threshold from [config] for metric with [metricId]
T? readNullableThreshold<T extends num>(
  Map<String, Object?> config,
  String metricId,
) =>
    readConfigValue<T>(config, metricId, 'threshold') ??
    readConfigValue<T>(config, metricId);

/// Returns a nullable value from [config] for metric with [metricId]
T? readConfigValue<T extends Object>(
  Map<String, Object?> config,
  String metricId, [
  String? valueName,
]) {
  final metricConfig = config[metricId];

  final configValue = metricConfig is Map<String, Object?>
      ? metricConfig[valueName]?.toString()
      : (valueName == null ? metricConfig?.toString() : null);

  if (configValue != null && T == int) {
    return int.tryParse(configValue) as T?;
  } else if (configValue != null && T == double) {
    return double.tryParse(configValue) as T?;
  } else if (configValue != null && T == String) {
    return configValue as T?;
  }

  return null;
}

/// Returns calculated [MetricValueLevel] based on the [value] to [warningLevel] ratio.
MetricValueLevel valueLevel(num? value, num? warningLevel) {
  if (value == null || warningLevel == null) {
    return MetricValueLevel.none;
  }

  if (value > warningLevel * 2) {
    return MetricValueLevel.alarm;
  } else if (value > warningLevel) {
    return MetricValueLevel.warning;
  } else if (value > warningLevel * 0.8) {
    return MetricValueLevel.noted;
  }

  return MetricValueLevel.none;
}

/// Returns calculated [MetricValueLevel] based on the [value] to [warningLevel] inverted ratio.
MetricValueLevel invertValueLevel(num? value, num? warningLevel) {
  if (value == null || warningLevel == null) {
    return MetricValueLevel.none;
  }

  if (value < warningLevel * 0.5) {
    return MetricValueLevel.alarm;
  } else if (value < warningLevel) {
    return MetricValueLevel.warning;
  } else if (value < warningLevel * 1.25) {
    return MetricValueLevel.noted;
  }

  return MetricValueLevel.none;
}

/// Determines if the [level] warns about need to be a report about a metric value.
bool isReportLevel(MetricValueLevel level) =>
    level == MetricValueLevel.warning || level == MetricValueLevel.alarm;

/// Returns user friendly string representations of [type].
String userFriendlyType(Type type) {
  const impl = 'Impl';

  final typeName = type.toString();

  return typeName.endsWith(impl)
      ? typeName.substring(0, typeName.length - impl.length)
      : typeName;
}
