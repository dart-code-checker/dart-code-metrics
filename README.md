# Dart code metrics

[![Build Status](https://github.com/dart-code-checker/dart-code-metrics/workflows/build/badge.svg)](https://github.com/dart-code-checker/dart-code-metrics/)
[![Coverage Status](https://codecov.io/gh/dart-code-checker/dart-code-metrics/branch/master/graph/badge.svg?branch=master)](https://codecov.io/gh/dart-code-checker/dart-code-metrics)
[![License](https://badgen.net/pub/license/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/license)
[![Pub Version](https://badgen.net/pub/v/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![Pub points](https://badgen.net/pub/points/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)
[![Pub popularity](https://badgen.net/pub/popularity/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)

Dart code metrics is a static analysis tool that helps improve code quality. It analyzes code metrics and provides [additional rules](https://github.com/dart-code-checker/dart-code-metrics#rules) for dart analyzer.
Can be used as a command line tool, analyzer plugin or library.

Reports:

- [Cyclomatic Complexity](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/cyclomatic-complexity.md)
- [Lines of Code](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/lines-of-code.md)
- [Maximum Nesting](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/maximum-nesting-level.md)
- [Number of Parameters](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/number-of-parameters.md)
- [Number of Methods](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/number-of-methods.md)
- [Weight Of a Class](https://github.com/dart-code-checker/dart-code-metrics/blob/master/documentation/metrics/weight-of-class.md)

- [Lines of Executable Code](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/lines-of-executable-code.md)

Output formats:

- Plain terminal
- [GitHub](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/reporters/github-reporter.md)
- Codeclimate
- HTML
- JSON

## Usage

### Analyzer plugin

A plugin for the Dart `analyzer` library [package](https://pub.dev/packages/dart_code_metrics) providing additional rules from Dart code metrics.

1. Add dependency to `pubspec.yaml`

    ```yaml
    dev_dependencies:
      dart_code_metrics: ^2.4.1
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
        maximum-nesting: 5
      metrics-exclude:
        - test/**
      rules:
        - newline-before-return
        - no-boolean-literal-compare
        - no-empty-block
        - prefer-trailing-comma
        - prefer-conditional-expressions
        - no-equal-then-else

### Command line tool

#### Simple usage

```bash
pub global activate dart_code_metrics
metrics lib
```

#### Flutter usage

```bash
flutter pub global activate dart_code_metrics
flutter pub global run dart_code_metrics:metrics lib
```

#### Full usage

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

If you want command line tool to check rules, you should add configuration to your `analysis_options.yaml` as listed in Analyzer plugin usage example.

### Library

[See `example/example.dart`](https://github.com/dart-code-checker/dart-code-metrics/blob/master/example/example.dart)

## Anti-Patterns

- [long-method](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/anti-patterns/long-method.md)
- [long-parameter-list](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/anti-patterns/long-parameter-list.md)

## Rules

Rules are grouped by category to help you understand their purpose.

Right now auto-fixes are available through an IDE context menu (ex. VS Code Quick Fix).

### Common

- [avoid-unused-parameters](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/avoid_unused_parameters.md)
- [binary-expression-operand-order](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/binary_expression_operand_order.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [double-literal-format](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/double_literal_format.md) &nbsp; ![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)
- [member-ordering](https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/rules/member_ordering.md) &nbsp; ![Configurable](https://img.shields.io/badge/-configurable-informational)
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

## Contributing

If you are interested in contributing, please check out the [contribution guidelines](https://github.com/dart-code-checker/dart-code-metrics/blob/master/CONTRIBUTING.md). Feedback and contributions are welcome!
