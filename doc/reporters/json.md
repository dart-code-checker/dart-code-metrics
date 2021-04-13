# JSON reporter

Dart Code Metrics can generate a report in JSON format. Use `--reporter=json` to enable this format. The reporter prints a single JSON object containing meta information and the violations grouped by a file. A sample command to analyze a package:

```sh
dart pub run dart_code_metrics:metrics --reporter=json lib

# or for a Flutter package
flutter pub run dart_code_metrics:metrics --reporter=json lib
```

## The **root** object fields are

- `formatVersion` - an integer representing a format version (will be incremented each time the serialization format changes)
- `timestamp` - a creation time of the report in format YYYY-MM-DD HH:MM:SS
- `records` - an array of [objects](#the-record-object-fields-are)

```JSON
{
  "formatVersion": 2,
  "timestamp": "2021-04-11 14:44:42",
  "records": [
    {
      ...
    },
    {
      ...
    },
    {
      ...
    }
  ]
}
```

## The **record** object fields are

- `path` - a relative path to the target file
- `classes` - a map with **class name** as the **key** and **[class report](#the-report-object-fields-are)** as the **value**
- `functions` - a map with **function name** as the **key** and **[function report](#the-report-object-fields-are)** as the **value**
- `issues` - an array of [issues](#the-issue-object-fields-are) detected in the target file
- `antiPatternCases` - an array of [anti-pattern cases](#the-issue-object-fields-are) detected in the target file

```JSON
{
  "path": "lib/src/metrics/metric_computation_result.dart",
  "classes": {
    ...
  },
  "functions": {
    ...
  },
  "issues": [
    ...
  ],
  "antiPatternCases": [
    ...
  ]
}
```

## The **report** object fields are

- `codeSpan` - a source [code span](#the-code-span-object-fields-are) of the target entity
- `metrics` - an array with target entity [metrics](#the-metric-value-object-fields-are)

```JSON
{
  "codeSpan": {
    ...
  },
  "metrics": [
    ...
  ]
}
```

## The **code span** object fields are

- `start` - a start [location](#the-location-object-fields-are) of an entity
- `end` - an end [location](#the-location-object-fields-are) of an entity
- `text` - a source code text of an entity

```JSON
{
  "start": {
    ...
  },
  "end": {
    ...
  },
  "text": "entity source code"
}
```

## The **location** object fields are

- `offset` - a zero-based offset of the location in the source
- `line` - a zero-based line of the location in the source
- `column` - a zero-based column of the location in the source

```JSON
{
  "offset": 156,
  "line": 7,
  "column": 1
}
```

## The **metric value** object fields are

- `metricsId` - an id of the computed metric
- `value` - an actual value computed by the metric
- `level` - a level of the value computed by the metric
- `comment` - a message with information about the value
- `recommendation` - a message with information about how the user can improve the value *(optional)*
- `context` - an [additional information](#the-context-message-object-fields-are) associated with the value that helps understand how the metric was computed

```JSON
{
  "metricsId": "number-of-methods",
  "value": 14,
  "level": "warning",
  "comment": "This class has 14 methods, which exceeds the maximum of 10 allowed.",
  "recommendation": "Consider breaking this class up into smaller parts.",
  "context": [
    ...
  ]
}
```

## The **context message** object fields are

- `message` - an message to be displayed to the user
- `codeSpan` - a source [code span](#the-code-span-object-fields-are) associated with or referenced by the message

```JSON
{
  "message": "getter complexityEntities increase metric value",
  "codeSpan": {
    ...
  }
}
```

## The **issue** object fields are

- `ruleId` - an id of the rule associated with the issue
- `documentation` - an url of a page containing documentation associated with the issue
- `codeSpan` - a source [code span](#the-code-span-object-fields-are) associated with the issue
- `severity` - a severity of the issue
- `message` - a short message
- `verboseMessage` - a verbose message containing information about how the user can fix the issue (optional)
- `suggestion` - a [suggested](#the-suggestion-object-fields-are) relevant change (optional)

```JSON
{
  "ruleId": "long-parameter-list",
  "documentation": "https://git.io/JUGrU",
  "codeSpan": {
    ...
  },
  "severity": "none",
  "message": "Long Parameter List. This function require 5 arguments.",
  "verboseMessage": "Based on configuration of this package, we don't recommend writing a function with argument count more than 4.",
  "suggestion": {
    ...
  }
}
```

## The **suggestion** object fields are

- `comment` - a human-readable description of the change to be applied
- `replacement` - a code with changes to replace original code with

```JSON
{
  "comment": "Add trailing comma",
  "replacement": "WeightOfClassMetric.metricId: (config) => WeightOfClassMetric(config: config),"
}
```
