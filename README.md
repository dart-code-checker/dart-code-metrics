[![Build Status](https://github.com/wrike/metrics/workflows/build/badge.svg)](https://github.com/wrike/dart-code-metrics/)
[![License](https://badgen.net/pub/license/dart_code_metrics)](https://github.com/wrike/dart-code-metrics/blob/master/LICENSE)
[![Pub Version](https://badgen.net/pub/v/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
![Dart SDK Verison](https://badgen.net/pub/sdk-version/dart_code_metrics)
![Dart Platform](https://badgen.net/pub/dart-platform/dart_code_metrics)

### The Dart command line tool which helps to improve code quality
Reports:
* Cyclomatic complexity of methods
* Too long methods
* Number of Arguments

Output formats:
* Plain terminal
* JSON
* HTML
* Codeclimate

### Simple usage:
```bash
pub global activate dart_code_metrics
metrics lib
```

### Full usage:
```
Usage: metrics [options...] <directories>
-h, --help                                             Print this usage information.
-r, --reporter=<console>                               The format of the output of the analysis
                                                       [console (default), json, html, codeclimate]

    --cyclomatic-complexity=<20>                       Cyclomatic complexity threshold
                                                       (defaults to "20")

    --lines-of-code=<50>                               Lines of code threshold
                                                       (defaults to "50")

    --number-of-arguments=<4>                          Number of arguments threshold
                                                       (defaults to "4")

    --root-folder=<./>                                 Root folder
                                                       (defaults to current directory)

    --ignore-files=<{/**.g.dart,/**.template.dart}>    Filepaths in Glob syntax to be ignored
                                                       (defaults to "{/**.g.dart,/**.template.dart}")

    --verbose
    --set-exit-on-violation-level=<warning>            Set exit code 2 if code violations same or higher level than selected are detected
                                                       [noted, warning, alarm]
```

### Use as library
See `example/example.dart`

# Dart-code-metrics analyzer plugin

A plugin for the Dart `analyzer` library [package](https://pub.dev/packages/dart_code_metrics) providing rules support from dart_code_metrics.

## Usage
1. Add dependency to `pubspec.yaml`
    ```yaml
    dev_dependencies:
      dart_code_metrics: ^1.5.1
    ```

2. Add settings to `analysis_options.yaml`
    ```yaml
    analyzer:
      plugins:
        - dart_code_metrics
    
      rules:
        - avoid-preserve-whitespace-false
        - double-literal-format
        - newline-before-return
        - no-boolean-literal-compare
        - no-empty-block
    ```

## Rules

* [avoid-preserve-whitespace-false](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/avoid_preserve_whitespace_false.md)
* [double-literal-format](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/double_literal_format.md)
* [newline-before-return](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/newline_before_return.md)
* [no-boolean-literal-compare-rule](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_boolean_literal_compare_rule.md)
* [no-empty-block](https://github.com/wrike/dart-code-metrics/blob/master/doc/rules/no_empty_block.md)
