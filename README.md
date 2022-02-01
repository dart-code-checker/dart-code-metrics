[![Build Status](https://shields.io/github/workflow/status/dart-code-checker/dart-code-metrics/build?logo=github&logoColor=white)](https://github.com/dart-code-checker/dart-code-metrics/)
[![Coverage Status](https://img.shields.io/codecov/c/github/dart-code-checker/dart-code-metrics?logo=codecov&logoColor=white)](https://codecov.io/gh/dart-code-checker/dart-code-metrics/)
[![Pub Version](https://img.shields.io/pub/v/dart_code_metrics?logo=dart&logoColor=white)](https://pub.dev/packages/dart_code_metrics/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![License](https://img.shields.io/github/license/dart-code-checker/dart-code-metrics)](https://github.com/dart-code-checker/dart-code-metrics/blob/master/LICENSE)
[![Pub popularity](https://badgen.net/pub/popularity/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)
[![GitHub popularity](https://img.shields.io/github/stars/dart-code-checker/dart-code-metrics?logo=github&logoColor=white)](https://github.com/dart-code-checker/dart-code-metrics/stargazers)

<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/logo.svg"
  alt="Dart Code Metrics logo"
  height="150" width="150"
  align="right">

# Dart Code Metrics

**Note: you can find [the full documentation on the website](https://dartcodemetrics.dev/docs/getting-started/introduction)**

[Configuration](https://dartcodemetrics.dev/docs/getting-started/configuration) |
[Rules](https://dartcodemetrics.dev/docs/rules/overview) |
[Metrics](https://dartcodemetrics.dev/docs/metrics/overview) |
[Anti-patterns](https://dartcodemetrics.dev/docs/anti-patterns/overivew)

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/flutter-favorite-badge-1200px.png"
  alt="Flutter Favorite Badge"
  height="140" width="140"
  align="right">
</a>

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

## Installation

```sh
$ dart pub add --dev dart_code_metrics

# or for a Flutter package
$ flutter pub add --dev dart_code_metrics
```

**OR**

add it manually to `pubspec.yaml`

```yaml
dev_dependencies:
  dart_code_metrics: ^4.10.1
```

and then run

```sh
$ dart pub get

# or for a Flutter package
$ flutter pub get
```

## Basic configuration

Add configuration to `analysis_options.yaml`

```yaml
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

Reload IDE to allow the analyzer to discover the plugin config.

You can read more about the configuration [on the website](https://dartcodemetrics.dev/docs/getting-started/configuration).

## Usage

### Analyzer plugin

Dart Code Metrics can be used as a plugin for the Dart `analyzer` [package](https://pub.dev/packages/analyzer) providing additional rules. All issues produced by rules or anti-patterns will be highlighted in IDE.

![Highlighted issue example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/plugin-example.png)

Rules that marked with a `has auto-fix` badge have auto-fixes available through the IDE context menu. VS Code example:

![VS Code example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/quick-fix.gif)

### CLI

The package can be used as CLI and supports multiple commands:

| Command            | Example of use                                            | Short description                                         |
| ------------------ | --------------------------------------------------------- | --------------------------------------------------------- |
| analyze            | dart run dart_code_metrics:metrics analyze lib            | Reports code metrics, rules and anti-patterns violations. |
| check-unused-files | dart run dart_code_metrics:metrics check-unused-files lib | Checks unused \*.dart files.                              |
| check-unused-l10n  | dart run dart_code_metrics:metrics check-unused-l10n lib  | Check unused localization in \*.dart files.               |
| check-unused-code  | dart run dart_code_metrics:metrics check-unused-code lib  | Checks unused code in \*.dart files.                      |

For additional help on any of the commands, enter `dart run dart_code_metrics:metrics help <command>`

**Note:** if you're setting up Dart Code Metrics for multi-package repository, check out [this website section](https://dartcodemetrics.dev/docs/cli/overview#multi-package-repositories-usage).

#### Analyze

Reports code metrics, rules and anti-patterns violations. To execute the command, run

```sh
$ dart run dart_code_metrics:metrics analyze lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics analyze lib
```

It will produce a result in one of the format:

- Console
- GitHub
- Codeclimate
- HTML
- JSON

Console report example:

![Console report example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/analyze-console-report.png)

#### Check unused files

Checks unused `*.dart` files. To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-files lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-files lib
```

It will produce a result in one of the format:

- Console
- JSON

Console report example:

![Console report example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/unused-files-console-report.png)

#### Check unused localization

Checks unused Dart class members, that encapsulates the app’s localized values.

An example of such class:

```dart
class ClassWithLocalization {
  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }
}
```

To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-l10n lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-l10n lib
```

It will produce a result in one of the format:

- Console
- JSON

Console report example:

![Console report example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/unused-l10n-console-report.png)

#### Check unused code

Checks unused code in `*.dart` files. To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-code lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-code lib
```

It will produce a result in one of the format:

- Console
- JSON

Console report example:

![Console report example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/unused-code-console-report.png)

## Troubleshooting

Please read [the following guide](./TROUBLESHOOTING.md) if the plugin is not working as you'd expect it to work.

## Contributing

If you are interested in contributing, please check out the [contribution guidelines](https://github.com/dart-code-checker/dart-code-metrics/blob/master/CONTRIBUTING.md). Feedback and contributions are welcome!

## Articles

### En

- [Finding Unused Files With Dart Code Metrics](https://medium.com/wriketechclub/finding-unused-files-with-dart-code-metrics-b9aba48ad7ca) - This article considers one of the first commands, checking unused Dart files, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Improving Code Quality With Dart Code Metrics](https://medium.com/wriketechclub/improving-code-quality-with-dart-code-metrics-430a5e3e316d) -  Advantages of using Dart Code Metrics, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Creating a Custom Plugin for Dart Analyzer](https://medium.com/wriketechclub/creating-a-custom-plugin-for-dart-analyzer-48b76d81a239) -  How to develop a custom Dart code analyzer plugin, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Flutter Static Analysis, Dart Code Metrics](https://fredgrott.medium.com/flutter-static-analysis-dart-code-metrics-c9ec484f4e0f) -  How to install the dart_code-metrics plugin and effectively use it to analyze dart code, by [Fred Grott](https://github.com/fredgrott)

### Ru

- [Повышаем качество кода с Dart Code Metrics](https://habr.com/ru/company/wrike/blog/552012/) -  Преимущества использования Dart Code Metrics, от [Dmitry Zhifarsky](https://github.com/incendial)
- [Как создать кастомный плагин для Dart-анализатора](https://habr.com/ru/company/wrike/blog/541672/) -  Описан процесс создания плагина для анализатора кода, от [Dmitry Zhifarsky](https://github.com/incendial)
- [Dart Code Metrics — мой первый pull request](https://habr.com/ru/post/592131/) -  Инструкция по созданию нового правила, от [Vlad Konoshenko](https://github.com/Konoshenko)

## How to reach us

Please feel free to ask any questions about this tool. Join our community [chat on Telegram](https://t.me/DartCodeMetrics). We speak both English and Russian.

## LICENSE

[MIT](./LICENSE)
