[![Build Status](https://shields.io/github/workflow/status/dart-code-checker/dart-code-metrics/build?logo=github&logoColor=white)](https://github.com/dart-code-checker/dart-code-metrics/)
[![Coverage Status](https://img.shields.io/codecov/c/github/dart-code-checker/dart-code-metrics?logo=codecov&logoColor=white)](https://codecov.io/gh/dart-code-checker/dart-code-metrics/)
[![Pub Version](https://img.shields.io/pub/v/dart_code_metrics?logo=dart&logoColor=white)](https://pub.dev/packages/dart_code_metrics/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![License](https://img.shields.io/github/license/dart-code-checker/dart-code-metrics)](https://github.com/dart-code-checker/dart-code-metrics/blob/master/LICENSE)
[![Pub popularity](https://badgen.net/pub/popularity/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)
[![GitHub popularity](https://img.shields.io/github/stars/dart-code-checker/dart-code-metrics?logo=github&logoColor=white)](https://github.com/dart-code-checker/dart-code-metrics/stargazers)

# Dart Code Metrics

**Note: you can find [the full documentation on the website](https://dartcodemetrics.dev/docs/getting-started/introduction)**

[Configuration](https://dartcodemetrics.dev/docs/getting-started/configuration) |
[Rules](https://dartcodemetrics.dev/docs/rules/overview) |
[Metrics](https://dartcodemetrics.dev/docs/metrics/overview) |
[Anti-patterns](https://dartcodemetrics.dev/docs/anti-patterns/overivew)

<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/doc/.assets/logo.svg"
  alt="Dart Code Metrics logo"
  height="120" width="120"
  align="right">

Dart Code Metrics is a static analysis tool that helps you analyse and improve your code quality.

- Reports [code metrics](https://dartcodemetrics.dev/docs/metrics/overview)
- Provides [additional rules](https://dartcodemetrics.dev/docs/rules/overview) for the dart analyzer
- Checks for [anti-patterns](https://dartcodemetrics.dev/docs/anti-patterns/overview)
- Checks [unused `*.dart` files](https://dartcodemetrics.dev/docs/cli/check-unused-files)
- Checks [unused l10n](https://dartcodemetrics.dev/docs/cli/check-unused-l10n)
- Can be used as [CLI](https://dartcodemetrics.dev/docs/cli/overview), [analyzer plugin](https://dartcodemetrics.dev/docs/analyzer-plugin) or [library](https://dartcodemetrics.dev/docs/getting-started/installation#library)

## Links

- See [CHANGELOG.md](./CHANGELOG.md) for major/breaking updates, and [releases](https://github.com/dart-code-checker/dart-code-metrics/releases) for a detailed version history.
- To contribute, please read [CONTRIBUTING.md](./CONTRIBUTING.md) first.
- Please [open an issue](https://github.com/dart-code-checker/dart-code-metrics/issues/new?assignees=dkrutskikh&labels=question&template=question.md&title=%5BQuestion%5D+) if anything is missing or unclear in this documentation.

## Quick start

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
      dart_code_metrics: ^4.5.0
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
        maximum-nesting-level: 5
        number-of-parameters: 4
        source-lines-of-code: 50
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

- Console
- GitHub
- Codeclimate
- HTML
- JSON

#### Usage

Install the package as listed in the [Analyzer plugin usage example](#analyzer-plugin).

If you want the command-line tool to check rules, you [should configure](https://dartcodemetrics.dev/docs/getting-started/configuration#configuring-a-rules-entry) `rules` entry in the `analysis_options.yaml` first.

```sh
dart pub run dart_code_metrics:metrics lib

# or for a Flutter package
flutter pub run dart_code_metrics:metrics lib
```

#### Multi-package repositories usage

If you use [Melos](https://pub.dev/packages/melos), you can add custom command to `melos.yaml`.

```yaml
metrics:
  run: |
    melos exec -c 1 --ignore="*example*" -- \
      flutter pub run dart_code_metrics:metrics lib
  description: |
    Run `dart_code_metrics` in all packages.
     - Note: you can also rely on your IDEs Dart Analysis / Issues window.
```

#### Options

```text
Usage: metrics [arguments...] <directories>

-h, --help                                        Print this usage information.


-r, --reporter=<console>                          The format of the output of the analysis.
                                                  [console (default), console-verbose, codeclimate, github, gitlab, html, json]
-o, --output-directory=<OUTPUT>                   Write HTML output to OUTPUT.
                                                  (defaults to "metrics")


    --cyclomatic-complexity=<20>                  Cyclomatic Complexity threshold.
    --halstead-volume=<150>                       Halstead Volume threshold.
    --lines-of-code=<100>                         Lines of Code threshold.
    --maximum-nesting-level=<5>                   Maximum Nesting Level threshold.
    --number-of-methods=<10>                      Number of Methods threshold.
    --number-of-parameters=<4>                    Number of Parameters threshold.
    --source-lines-of-code=<50>                   Source lines of Code threshold.
    --weight-of-class=<0.33>                      Weight Of a Class threshold.
    --maintainability-index=<50>                  Maintainability Index threshold.


    --root-folder=<./>                            Root folder.
                                                  (defaults to current directory)
    --sdk-path=<directory-path>                   Dart SDK directory path. Should be provided only when you run the application as compiled Windows executable and automatic Dart SDK path detection fails.
    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.
                                                  (defaults to "{/**.g.dart,/**.template.dart}")


    --set-exit-on-violation-level=<warning>       Set exit code 2 if code violations same or higher level than selected are detected.
                                                  [noted, warning, alarm]
    --[no-]fatal-style                            Treat style level issues as fatal.
    --[no-]fatal-performance                      Treat performance level issues as fatal.
    --[no-]fatal-warnings                         Treat warning level issues as fatal.
```

## Troubleshooting

Please read [the following guide](./TROUBLESHOOTING.md) if the plugin is not working as you'd expect it to work.

## Contributing

If you are interested in contributing, please check out the [contribution guidelines](https://github.com/dart-code-checker/dart-code-metrics/blob/master/CONTRIBUTING.md). Feedback and contributions are welcome!

## How to reach us

Please feel free to ask any questions about this tool. Join our community [chat on Telegram](https://t.me/DartCodeMetrics). We speak both English and Russian.

## LICENCE

[MIT](./LICENSE)
