
[![Build Status](https://github.com/dart-code-checker/dart-code-metrics/workflows/build/badge.svg)](https://github.com/dart-code-checker/dart-code-metrics/)
[![Coverage Status](https://codecov.io/gh/dart-code-checker/dart-code-metrics/branch/master/graph/badge.svg?branch=master)](https://codecov.io/gh/dart-code-checker/dart-code-metrics)
[![Pub Version](https://badgen.net/pub/v/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![License](https://badgen.net/pub/license/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/license)
[![Pub popularity](https://badgen.net/pub/popularity/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)

# Dart Code Metrics

[Configuration](#configuration) |
[Rules](#rules) |
[Metrics](#metrics) |
[Anti-patterns](#anti-patterns)

<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/doc/.assets/logo.svg"
  alt="Dart Code Metrics logo"
  height="120" width="120"
  align="right">

Dart Code Metrics is a static analysis tool that helps you analyse and improve your code quality.

- Reports [code metrics](#metrics)
- Provides [additional rules](#rules) for the dart analyzer
- Checks for [anti-patterns](#anti-patterns)
- Can be used as [CLI](#cli), [analyzer plugin](#analyzer-plugin) or [library](#library)

## Links

- See [CHANGELOG.md](./CHANGELOG.md) for major/breaking updates, and [releases](https://github.com/dart-code-checker/dart-code-metrics/releases) for a detailed version history.
- To contribute, please read [CONTRIBUTING.md](./CONTRIBUTING.md) first.
- Please [open an issue](https://github.com/dart-code-checker/dart-code-metrics/issues/new?assignees=dkrutskikh&labels=question&template=question.md&title=%5BQuestion%5D+) if anything is missing or unclear in this documentation.

## Usage

### Analyzer plugin

A plugin for the Dart `analyzer` [package](https://pub.dev/packages/analyzer) providing additional rules from Dart Code Metrics. All issues produced by rules or anti-patterns will be highlighted in IDE.

1. Install package as a dev dependency

    ```sh
    $ dart pub add --dev dart_code_metrics
    
    # or for a Flutter package
    $ flutter pub add --dev dart_code_metrics
    ```

    **OR**

    add it manually to `pubspec.yaml`

    ```yaml
    dev_dependencies:
      dart_code_metrics: ^3.0.0
    ```

    and then run

    ```sh
    $ dart pub get
    
    # or for a Flutter package
    $ flutter pub get
    ```

2. Add configuration to `analysis_options.yaml`

    ```yaml
    analyzer:
      plugins:
        - dart_code_metrics

    dart_code_metrics:
      anti-patterns:
        - long-method
        - long-parameter-list
      metrics:
        cyclomatic-complexity: 20
        lines-of-executable-code: 50
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
    ```

3. Reload IDE to allow the analyzer to discover the plugin

### CLI

The package can be used as a command-line tool.
It will produce a result in one of the supported formats:

- Plain terminal
- [GitHub](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/reporters/github-reporter.md)
- Codeclimate
- HTML
- JSON

#### Basic usage

Install the package as listed in the [Analyzer plugin usage example](#analyzer-plugin).

If you want the command-line tool to check rules, you [should configure](#configuring-a-rules-entry) `rules` entry in the `analysis_options.yaml` first.

```sh
dart pub run dart_code_metrics:metrics lib

# or for a Flutter package
flutter pub run dart_code_metrics:metrics lib
```

#### Global usage

```sh
dart pub global activate dart_code_metrics
dart pub global run dart_code_metrics:metrics lib

# or for a Flutter package
flutter pub global activate dart_code_metrics
flutter pub global run dart_code_metrics:metrics lib
```

#### Options

```text
Usage: metrics [arguments...] <directories>

-h, --help                                        Print this usage information.


-r, --reporter=<console>                          The format of the output of the analysis
                                                  [console (default), console-verbose, codeclimate, github, gitlab, html, json]
-o, --output-directory=<OUTPUT>                   Write HTML output to OUTPUT
                                                  (defaults to "metrics")


    --cyclomatic-complexity=<20>                  Cyclomatic Complexity threshold
    --lines-of-code=<100>                         Lines of Code threshold
    --maximum-nesting-level=<5>                   Maximum Nesting Level threshold
    --number-of-methods=<10>                      Number of Methods threshold
    --number-of-parameters=<4>                    Number of Parameters threshold
    --weight-of-class=<0.33>                      Weight Of a Class threshold
    --lines-of-executable-code=<50>               Lines of executable code threshold


    --root-folder=<./>                            Root folder
                                                  (defaults to current directory)
    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude
                                                  (defaults to "{/**.g.dart,/**.template.dart}")


    --set-exit-on-violation-level=<warning>       Set exit code 2 if code violations same or higher level than selected are detected
                                                  [noted, warning, alarm]
```

### Library

[See `example/example.dart`](https://github.com/dart-code-checker/dart-code-metrics/blob/master/example/example.dart).

## Configuration

To configure the package add the `dart_code_metrics` entry to the `analysis_options.yaml` and update plugins list of the analyzer.

```yaml
analyzer:
  plugins:
    - dart_code_metrics

dart_code_metrics:
  anti-patterns:
    - ... # add this entry to configure the list of anti-patterns
  metrics:
      ... # add this entry to configure the list of reported metrics
  metrics-exclude:
    - ... # add this entry to configure the list of files that should be ignored by metrics
  rules:
    - ... # add this entry to configure the list of rules
```

Basic config example:

```yaml
analyzer:
  plugins:
    - dart_code_metrics

dart_code_metrics:
  anti-patterns:
    - long-method
    - long-parameter-list
  metrics:
    cyclomatic-complexity: 20
    lines-of-executable-code: 50
    number-of-arguments: 4
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
```

### Configuring a rules entry

To enable a rule add its id to the `rules` entry. Rules with a `configurable` badge have additional configuration, check out their docs for more information.

### Configuring a metrics entry

To enable a metric add its id to the `metrics` entry in the `analysis_options.yaml`. All metrics can take a threshold value. If no value was provided, the default value will be used.

### Configuring a metrics-exclude entry

To exclude files from a metrics report provide a list of regular expressions for ignored files. For example:

```yaml
dart_code_metrics:
  metrics-exclude:
    - test/**
    - lib/src/some_file.dart
```

### Configuring an anti-pattern entry

To enable an anti-pattern add its id to the `anti-patterns` entry.

## Ignoring a rule or anti-pattern

If a specific rule or anti-pattern warning should be ignored, it can be flagged with a comment. For example,

```dart
// ignore: no-empty-block
void emptyFunction() {}
```

tells the analyzer to ignore this instance of the no-empty-block warning.

End-of-line comments are supported as well. The following communicates the same thing:

```dart
void emptyFunction() {} // ignore: no-empty-block
```

To ignore a rule for an entire file, use the ignore_for_file comment flag. For example,

```dart
// ignore_for_file: no-empty-block
...

void emptyFunction() {}
```

tells the analyzer to ignore all occurrences of the camel_case_types warning in this file.

It's the same approach that the dart linter package [use](https://github.com/dart-lang/linter#usage).

Additionally, `exclude` entry for the analyzer config can be used to ignore files. For example,

```yaml
analyzer:
  exclude:
    - example/**
```

will work both for the analyzer and for this plugin.

If you want a specific rule to ignore files, you can configure `exclude` entry for it. For example,

```yaml
dart_code_metrics:
  rules:
    no_equal_arguments:
      exclude:
        - test/**
```

## Metrics

Metrics configuration is [described here](#configuring-a-metrics-entry).

Available metrics:

- [Cyclomatic Complexity](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/cyclomatic-complexity.md)
- [Lines of Code](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/lines-of-code.md)
- [Maximum Nesting](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/maximum-nesting-level.md)
- [Number of Parameters](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/number-of-parameters.md)
- [Number of Methods](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/number-of-methods.md)
- [Weight of a Class](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/weight-of-class.md)
- [Lines of Executable Code](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/lines-of-executable-code.md)

## Rules

Rules are grouped by a category to help you understand their purpose.

Right now auto-fixes are available through an IDE context menu (ex. VS Code Quick Fix).

Rules configuration is [described here](#configuring-a-rules-entry).

### Common

- [avoid-unused-parameters](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/avoid_unused_parameters.md)
- [binary-expression-operand-order](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/binary_expression_operand_order.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [double-literal-format](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/double_literal_format.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [member-ordering](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/member_ordering.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [member-ordering-extended](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/member_ordering_extended.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [newline-before-return](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/newline_before_return.md)
- [no-boolean-literal-compare](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_boolean_literal_compare.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [no-empty-block](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_empty_block.md)
- [no-equal-arguments](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_equal_arguments.md)
- [no-equal-then-else](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_equal_then_else.md)
- [no-magic-number](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_magic_number.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [no-object-declaration](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/no_object_declaration.md)
- [prefer-conditional-expressions](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/prefer_conditional_expressions.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [prefer-trailing-comma](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/prefer_trailing_comma.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

### Intl specific

- [prefer-intl-name](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/prefer_intl_name.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [provide-correct-intl-args](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/provide_correct_intl_args.md)

### Angular specific

- [avoid-preserve-whitespace-false](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/avoid_preserve_whitespace_false.md)
- [component-annotation-arguments-ordering](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/component_annotation_arguments_ordering.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [prefer-on-push-cd-strategy](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/prefer_on_push_cd_strategy.md)

## Anti-patterns

Like rules, anti-patterns display issues in IDE, except that their configuration is based on a `metrics` entry in the config.

- [long-method](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/anti-patterns/long-method.md)
- [long-parameter-list](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/anti-patterns/long-parameter-list.md)

## Contributing

If you are interested in contributing, please check out the [contribution guidelines](https://github.com/dart-code-checker/dart-code-metrics/blob/master/CONTRIBUTING.md). Feedback and contributions are welcome!

## LICENCE

[MIT](./LICENSE)
