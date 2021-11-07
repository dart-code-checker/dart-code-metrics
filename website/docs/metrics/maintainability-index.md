# Maintainability Index

`Maintainability Index` is a software metric which measures how maintainable (easy to support and change) the source code is. The maintainability index is calculated as a factored formula consisting of `Source Lines Of Code`, `Cyclomatic Complexity` and `Halstead Volume`.

The original formula:

```dart
MI = 171 − 5.2 * log(HALVOL) − 0.23 * log(CYCLO) − 16.2 * log(SLOC)
```

We use Microsoft Visual Studio version with a shifted scale (0 to 100) derivative:

```dart
MI = max(0, (171 − 5.2 * log(HALVOL) − 0.23 * log(CYCLO) − 16.2 * log(SLOC)) * 100 / 171)
```

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    maintainability-index: 50
    ...
```

## Example {#example}

```dart
MetricComputationResult<int> computeImplementation(
  Declaration node,
  Iterable<ScopedClassDeclaration> classDeclarations,
  Iterable<ScopedFunctionDeclaration> functionDeclarations,
  InternalResolvedUnitResult source,
  Iterable<MetricValue<num>> otherMetricsValues,
) {
  final halVol = otherMetricsValues.firstWhere(
    (value) => value.metricsId == HalsteadVolumeMetric.metricId,
  );

  final cyclomatic = otherMetricsValues.firstWhere(
    (value) => value.metricsId == CyclomaticComplexityMetric.metricId,
  );

  final sloc = otherMetricsValues.firstWhere(
    (value) => value.metricsId == SourceLinesOfCodeMetric.metricId,
  );

  final halVolScale = log(max(1, halVol.value));
  final cycloScale = cyclomatic.value;
  final slocScale = log(max(1, sloc.value));

  final maintainabilityIndex =
      (171 - halVolScale * 5.2 - cycloScale * 0.23 - slocScale * 16.2) / 171;

  return MetricComputationResult(
    value: (maintainabilityIndex * 100).clamp(0, 100).ceil(),
  );
}
```

**Maintainability Index** for the example function is **56**.

> **Note:** Maintainability Index is still a very experimental metric, and should not be taken into account as seriously as the other metrics.
