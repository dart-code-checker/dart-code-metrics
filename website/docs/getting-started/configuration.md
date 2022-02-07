---
sidebar_position: 2
---

# Configuration

To configure the package add a `dart_code_metrics` entry to `analysis_options.yaml`. This configuration is used by both CLI and the analyzer plugin.

```yaml title="analysis_options.yaml"
dart_code_metrics:
  metrics:
    - ... # configures the list of reported metrics
  metrics-exclude:
    - ... # configures the list of files that should be ignored by metrics
  rules:
    - ... # configures the list of rules
  rules-exclude:
    - ... # configures the list of files that should be ignored by rules
  anti-patterns:
    - ... # configures the list of anti-patterns
```

Basic config example:

```yaml title="analysis_options.yaml"
dart_code_metrics:
  metrics:
    cyclomatic-complexity: 20
    number-of-parameters: 4
    maximum-nesting-level: 5
  metrics-exclude:
    - test/**
  rules:
    - newline-before-return
    - no-boolean-literal-compare
    - no-empty-block
    - prefer-trailing-comma
    - prefer-conditional-expressions
    - no-equal-then-else
  anti-patterns:
    - long-method
    - long-parameter-list
```

## Configuring a metrics entry {#configuring-a-metrics-entry}

To enable a metric add its id to the `metrics` entry in the `analysis_options.yaml`. All metrics can take a threshold value. If no value was provided, the default value will be used.

## Configuring a metrics-exclude entry {#configuring-a-metrics-exclude-entry}

To exclude files from a metrics report provide a list of regular expressions for ignored files. For example:

```yaml title="analysis_options.yaml"
dart_code_metrics:
  metrics-exclude:
    - test/**
    - lib/src/some_file.dart
```

## Configuring a rules entry {#configuring-a-rules-entry}

To enable a rule add its id to the `rules` entry. All rules have severity which can be overridden with `severity` config entry. For example,

```yaml title="analysis_options.yaml"
dart_code_metrics:
  rules:
    - newline-before-return:
        severity: style
```

will set severity to `style`. Available severity values:

- none
- style
- performance
- warning
- error

Rules with a `configurable` badge have additional configuration, check out their docs for more information.

## Configuring a rules-exclude entry {#configuring-a-rules-exclude-entry}

To exclude files from a rules analysis provide a list of regular expressions for ignored files. For example:

```yaml title="analysis_options.yaml"
dart_code_metrics:
  rules-exclude:
    - test/**
    - lib/src/some_file.dart
```

## Configuring an anti-pattern entry {#configuring-an-anti-pattern-entry}

To enable an anti-pattern add its id to the `anti-patterns` entry. All anti-pattern have severity which can be overridden with `severity` config entry. For example,

```yaml title="analysis_options.yaml"
dart_code_metrics:
  anti-patterns:
    - long-method:
        severity: warning
```

will set severity to `warning`.

## Ignoring a rule or anti-pattern {#ignoring-a-rule-or-anti-pattern}

If a specific rule or anti-pattern warning should be ignored, it can be flagged with a comment. For example,

```dart
// ignore: no-empty-block
void emptyFunction() {}
```

tells the analyzer to ignore this instance of the `no-empty-block` warning.

End-of-line comments are supported as well. The following communicates the same thing:

```dart
void emptyFunction() {} // ignore: no-empty-block
```

To ignore a rule for an entire file, use the `ignore_for_file` comment flag. For example,

```dart
// ignore_for_file: no-empty-block
...

void emptyFunction() {}
```

tells the analyzer to ignore all occurrences of the kebab-case-types warning in this file.

It's the same approach that the dart linter package [use](https://github.com/dart-lang/linter#usage).

Additionally, `exclude` entry for the analyzer config can be used to ignore files. For example,

```yaml title="analysis_options.yaml"
analyzer:
  exclude:
    - "example/**"
    - "build/**"
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

will work both for the analyzer and for this plugin.

If you want a specific rule to ignore files, you can configure `exclude` entry for it. For example,

```yaml title="analysis_options.yaml"
dart_code_metrics:
  rules:
    - no-equal-arguments:
        exclude:
          - test/**
```

and similar example for anti-pattern,

```yaml title="analysis_options.yaml"
dart_code_metrics:
  anti-patterns:
    - long-method:
        exclude:
          - test/**
```
