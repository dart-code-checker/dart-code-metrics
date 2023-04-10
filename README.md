[![Build Status](https://shields.io/github/actions/workflow/status/dart-code-checker/dart-code-metrics/package_analyze.yaml?logo=github&logoColor=white&branch=master)](https://github.com/dart-code-checker/dart-code-metrics/)
[![Coverage Status](https://img.shields.io/codecov/c/github/dart-code-checker/dart-code-metrics?logo=codecov&logoColor=white)](https://codecov.io/gh/dart-code-checker/dart-code-metrics/)
[![Pub Version](https://img.shields.io/pub/v/dart_code_metrics?logo=dart&logoColor=white)](https://pub.dev/packages/dart_code_metrics/)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/)
[![License](https://img.shields.io/github/license/dart-code-checker/dart-code-metrics)](https://github.com/dart-code-checker/dart-code-metrics/blob/master/LICENSE)
[![Pub popularity](https://badgen.net/pub/popularity/dart_code_metrics)](https://pub.dev/packages/dart_code_metrics/score)
[![GitHub popularity](https://img.shields.io/github/stars/dart-code-checker/dart-code-metrics?logo=github&logoColor=white)](https://github.com/dart-code-checker/dart-code-metrics/stargazers)

<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/logo.svg"
  alt="DCM logo"
  height="150" width="150"
  align="right">

# DCM

**Note: you can find [the full documentation on the website](https://dcm.dev/docs/individuals/getting-started/)**

[Configuration](https://dcm.dev/docs/individuals/configuration/) |
[Rules](https://dcm.dev/docs/individuals/rules/) |
[Metrics](https://dcm.dev/docs/individuals/metrics/) |
[Anti-patterns](https://dcm.dev/docs/individuals/anti-patterns/)

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites">
<img
  src="https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/flutter-favorite-badge-1200px.png"
  alt="Flutter Favorite Badge"
  height="140" width="140"
  align="right">
</a>

DCM is a toolkit that helps you identify and fix problems in your Dart and Flutter code. These problems can range from potential runtime bugs and violations of best practices to styling issues. DCM includes over 70 built-in rules to validate your code against various expectations, and you can customize these rules to fit your specific needs.

- Reports [code metrics](https://dcm.dev/docs/individuals/metrics/)
- Provides [additional rules](https://dcm.dev/docs/individuals/rules/) for the dart analyzer
- Checks for [anti-patterns](https://dcm.dev/docs/individuals/anti-patterns/)
- Checks [unused `*.dart` files](https://dcm.dev/docs/individuals/cli/check-unused-files/)
- Checks [unused l10n](https://dcm.dev/docs/individuals/cli/check-unused-l10n/)
- Checks [unnecessary nullable parameters](https://dcm.dev/docs/individuals/cli/check-unnecessary-nullable/)
- Can be used as [CLI](https://dcm.dev/docs/individuals/cli/) and the [analyzer plugin](https://dcm.dev/docs/individuals/analyzer-plugin/)

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

## Basic configuration

Add configuration to `analysis_options.yaml` and reload IDE to allow the analyzer to discover the plugin config.

You can read more about the configuration [on the website](https://dcm.dev/docs/individuals/configuration/).

### Basic config example

```yaml title="analysis_options.yaml"
analyzer:
  plugins:
    - dart_code_metrics

dart_code_metrics:
  rules:
    - avoid-dynamic
    - avoid-passing-async-when-sync-expected
    - avoid-redundant-async
    - avoid-unnecessary-type-assertions
    - avoid-unnecessary-type-casts
    - avoid-unrelated-type-assertions
    - avoid-unused-parameters
    - avoid-nested-conditional-expressions
    - newline-before-return
    - no-boolean-literal-compare
    - no-empty-block
    - prefer-trailing-comma
    - prefer-conditional-expressions
    - no-equal-then-else
    - prefer-moving-to-variable
    - prefer-match-file-name
```

### Basic config with metrics

```yaml title="analysis_options.yaml"
analyzer:
  plugins:
    - dart_code_metrics

dart_code_metrics:
  metrics:
    cyclomatic-complexity: 20
    number-of-parameters: 4
    maximum-nesting-level: 5
  metrics-exclude:
    - test/**
  rules:
    - avoid-dynamic
    - avoid-passing-async-when-sync-expected
    - avoid-redundant-async
    - avoid-unnecessary-type-assertions
    - avoid-unnecessary-type-casts
    - avoid-unrelated-type-assertions
    - avoid-unused-parameters
    - avoid-nested-conditional-expressions
    - newline-before-return
    - no-boolean-literal-compare
    - no-empty-block
    - prefer-trailing-comma
    - prefer-conditional-expressions
    - no-equal-then-else
    - prefer-moving-to-variable
    - prefer-match-file-name
```

## Usage

### Analyzer plugin

DCM can be used as a plugin for the Dart `analyzer` [package](https://pub.dev/packages/analyzer) providing additional rules. All issues produced by rules or anti-patterns will be highlighted in IDE.

Rules that marked with 🛠 have auto-fixes available through the IDE context menu. VS Code example:

![VS Code example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/quick-fixes.png)

### CLI

The package can be used as CLI and supports multiple commands:

| Command            | Example of use                                            | Short description                                         |
| ------------------ | --------------------------------------------------------- | --------------------------------------------------------- |
| analyze            | dart run dart_code_metrics:metrics analyze lib            | Reports code metrics, rules and anti-patterns violations. |
| check-unnecessary-nullable | dart run dart_code_metrics:metrics check-unnecessary-nullable lib | Checks unnecessary nullable parameters in functions, methods, constructors. |
| check-unused-files | dart run dart_code_metrics:metrics check-unused-files lib | Checks unused \*.dart files.                              |
| check-unused-l10n  | dart run dart_code_metrics:metrics check-unused-l10n lib  | Check unused localization in \*.dart files.               |
| check-unused-code  | dart run dart_code_metrics:metrics check-unused-code lib  | Checks unused code in \*.dart files.                      |

For additional help on any of the commands, enter `dart run dart_code_metrics:metrics help <command>`

**Note:** if you're setting up DCM for multi-package repository, check out [this website section](https://dcm.dev/docs/individuals/cli#multi-package-repositories-usage/).

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

#### Check unnecessary nullable parameters

Checks unnecessary nullable parameters in functions, methods, constructors. To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unnecessary-nullable lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unnecessary-nullable lib
```

It will produce a result in one of the format:

- Console
- JSON

Console report example:

![Console report example](https://raw.githubusercontent.com/dart-code-checker/dart-code-metrics/master/assets/unnecessary-nullable-console-report.png)

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

- [What’s new in DCM for Teams 1.3.0](https://dcm.dev/blog/2023/04/06/whats-new-in-dcm-1-3-0/)
- [What’s new in DCM for Teams 1.2.0](https://dcm.dev/blog/2023/03/06/whats-new-in-dcm-1-2-0/)
- [What’s new in DCM for Teams 1.1.0](https://medium.com/@incendial/whats-new-in-dcm-for-teams-1-1-0-501fd6223b0)
- [Announcing DCM for Teams](https://incendial.medium.com/announcing-dcm-for-teams-84db2cffce99)
- [Finding Unused Files With DCM](https://medium.com/wriketechclub/finding-unused-files-with-dart-code-metrics-b9aba48ad7ca) - This article considers one of the first commands, checking unused Dart files, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Improving Code Quality With DCM](https://medium.com/wriketechclub/improving-code-quality-with-dart-code-metrics-430a5e3e316d) -  Advantages of using DCM, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Creating a Custom Plugin for Dart Analyzer](https://medium.com/wriketechclub/creating-a-custom-plugin-for-dart-analyzer-48b76d81a239) -  How to develop a custom Dart code analyzer plugin, by [Dmitry Zhifarsky](https://github.com/incendial)
- [Flutter Static Analysis, DCM](https://fredgrott.medium.com/flutter-static-analysis-dart-code-metrics-c9ec484f4e0f) -  How to install the dart_code-metrics plugin and effectively use it to analyze dart code, by [Fred Grott](https://github.com/fredgrott)

### Ru

- [Повышаем качество кода с DCM](https://habr.com/ru/company/wrike/blog/552012/) -  Преимущества использования DCM, от [Dmitry Zhifarsky](https://github.com/incendial)
- [Как создать кастомный плагин для Dart-анализатора](https://habr.com/ru/company/wrike/blog/541672/) -  Описан процесс создания плагина для анализатора кода, от [Dmitry Zhifarsky](https://github.com/incendial)
- [DCM — мой первый pull request](https://habr.com/ru/post/592131/) -  Инструкция по созданию нового правила, от [Vlad Konoshenko](https://github.com/Konoshenko)

## How to reach us

Please feel free to ask any questions about this tool. Join our community [chat on Telegram](https://t.me/DartCodeMetrics). We speak both English and Russian.

## LICENSE

[MIT](./LICENSE)
