import 'models/metric_value_level.dart';

/// Returns the url of a page containing documentation associated with [metricId]
Uri documentation(String metricId) => Uri(
      scheme: 'https',
      host: 'github.com',
      pathSegments: [
        'dart-code-checker',
        'dart-code-metrics',
        'blob',
        'master',
        'doc',
        'metrics',
        '$metricId.md',
      ],
    );

/// Returns a threshold from [Map] based [config] for metrics with [metricId] otherwise [defaultValue]
T readThreshold<T extends num>(
  Map<String, Object?> config,
  String metricId,
  T defaultValue,
) {
  final configValue = config[metricId]?.toString();

  if (configValue != null && T == int) {
    return int.tryParse(configValue) as T? ?? defaultValue;
  } else if (configValue != null && T == double) {
    return double.tryParse(configValue) as T? ?? defaultValue;
  }

  return defaultValue;
}

/// Returns calculated [MetricValueLevel] based on the [value] to [warningLevel] ratio
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

/// Returns calculated [MetricValueLevel] based on the [value] to [warningLevel] inverted ratio
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

/// Determines if the [level] warns about need to be a report about a metric value
bool isReportLevel(MetricValueLevel level) =>
    level == MetricValueLevel.warning || level == MetricValueLevel.alarm;

/// Returns user friendly string representations of [type].
String userFriendlyType(Type type) {
  const _impl = 'Impl';

  final typeName = type.toString();

  return typeName.endsWith(_impl)
      ? typeName.substring(0, typeName.length - _impl.length)
      : typeName;
}
