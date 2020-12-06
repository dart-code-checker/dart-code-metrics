[![Build Status](https://github.com/wrike/metrics/workflows/build/badge.svg)](https://github.com/wrike/dart-code-metrics/)
[![Coverage Status](https://coveralls.io/repos/github/wrike/dart-code-metrics/badge.svg?branch=master)](https://coveralls.io/github/wrike/dart-code-metrics?branch=master)
[![License](https://badgen.net/pub/license/dart_code_metrics)](https://github.com/wrike/dart-code-metrics/blob/master/LICENSE)
[![Pub Version](https://badgen.net/pub/v/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
![Dart SDK Verison](https://badgen.net/pub/sdk-version/dart_code_metrics)
![Dart Platform](https://badgen.net/pub/dart-platform/dart_code_metrics)

# Dart code metrics

Dart code metrics is a static analysis tool that helps improve code quality. It analyzes code metrics and provides [additional rules](https://github.com/wrike/dart-code-metrics#rules) for dart analyzer.
Can be used as a command line tool, analyzer plugin or library.

Reports:

- Cyclomatic complexity of methods
- [Lines of Executable Code](https://github.com/wrike/dart-code-metrics/blob/master/doc/metrics/lines-of-executable-code.md)
- [Maximum Nesting](https://github.com/wrike/dart-code-metrics/blob/master/doc/metrics/maximum-nesting.md)
- [Number of Arguments](https://github.com/wrike/dart-code-metrics/blob/master/doc/metrics.md#number-of-arguments)
- [Number of Methods](https://github.com/wrike/dart-code-metrics/blob/master/doc/metrics.md#number-of-methods)

Output formats:

- Plain terminal
- [GitHub](https://github.com/wrike/dart-code-metrics/blob/master/doc/reporters/github-reporter.md)
- Codeclimate
- HTML
- JSON

## Usage

### Analyzer plugin

A plugin for the Dart `analyzer` library [package](https://pub.dev/packages/dart_code_metrics) providing additional rules from Dart code metrics.

1. Add dependency to `pubspec.yaml`

    ```yaml
    dev_dependencies:
      dart_code_metrics: ^2.0.0
    ```

2. Add configuration to `analysis_options.yaml`

    ```yaml
    analyzer:
      plugins:
        - dart_code_metrics

    dart_code_metrics:
      anti-patterns:
        - long-method
      metrics:
        cyclomatic-complexity: 20
        lines-of-executable-code: 50
        number-of-arguments: 4
      metrics-exclude:
        - test/**
      rules:
        - newline-before-return
        - no-boolean-literal-compare
        - no-empty-block
        - prefer-trailing-comma-for-collection

### Command line tool

#### Simple usage:

```bash
pub global activate dart_code_metrics
metrics lib
```

#### Flutter usage:

```bash
flutter pub global run dart_code_metrics:metrics lib
```

#### Full usage:

```text
Usage: metrics [options...] <directories>
-h, --help                                             Print this usage information.
-r, --reporter=<console>                               The format of the output of the analysis
                                                       [console (default), github, json, html, codeclimate]

    --cyclomatic-complexity=<20>                       Cyclomatic complexity threshold
                                                       (defaults to "20")

    --lines-of-executable-code=<50>                    Lines of executable code threshold
                                                       (defaults to "50")

    --number-of-arguments=<4>                          Number of arguments threshold
                                                       (defaults to "4")

    --number-of-methods=<10>                           Number of methods threshold
                                                       (defaults to "10")

    --root-folder=<./>                                 Root folder
                                                       (defaults to current directory)

    --ignore-files=<{/**.g.dart,/**.template.dart}>    Filepaths in Glob syntax to be ignored
                                                       (defaults to "{/**.g.dart,/**.template.dart}")

    --verbose
    --set-exit-on-violation-level=<warning>            Set exit code 2 if code violations same or higher level than selected are detected
                                                       [noted, warning, alarm]
```

If you want command line tool to check rules, you should add configuration to your `analysis_options.yaml` as listed in Analyzer plugin usage example.

### Library

[See `example/example.dart`](https://github.com/wrike/dart-code-metrics/blob/master/example/example.dart)

## Anti-Patterns

- [long-method](https://github.com/wrike/dart-code-metrics/blob/master/doc/anti-patterns/long-method.md)
- [long-parameter-list](https://github.com/wrike/dart-code-metrics/blob/master/doc/anti-patterns/long-parameter-list.md)

## Rules

### Common

- [binary-expression-operand-order](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/binary_expression_operand_order.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [double-literal-format](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/double_literal_format.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [member-ordering](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/member_ordering.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [newline-before-return](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/newline_before_return.md)
- [no-boolean-literal-compare](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_boolean_literal_compare.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [no-empty-block](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_empty_block.md)
- [no-equal-arguments](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_equal_arguments.md)
- [no-equal-then-else](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_equal_then_else.md)
- [no-magic-number](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_magic_number.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [no-object-declaration](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_object_declaration.md)
- [potential-null-dereference](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/potential_null_dereference.md)
- [prefer-conditional-expressions](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/prefer_conditional_expressions.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [prefer-trailing-comma-for-collection](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/prefer_trailing_comma_for_collection.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [prefer-trailing-comma](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/prefer_trailing_comma.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

### Intl specific

- [prefer-intl-name](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/prefer_intl_name.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [provide-correct-intl-args](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/provide_correct_intl_args.md)

### Angular specific

- [avoid-preserve-whitespace-false](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/avoid_preserve_whitespace_false.md)
- [component-annotation-arguments-ordering](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/component_annotation_arguments_ordering.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
- [prefer-on-push-cd-strategy](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/prefer_on_push_cd_strategy.md)
