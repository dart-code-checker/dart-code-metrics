---
sidebar_position: 0
sidebar_label: 'Overview'
---

# CLI Overview

To use the package as a command-line tool, run

```sh
$ dart run dart_code_metrics:metrics <command> lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics <command> lib
```

Alternatively, the package can be installed globally

```sh
$ dart pub global activate dart_code_metrics
$ metrics <command> lib

# or for a Flutter package
$ flutter pub global activate dart_code_metrics
$ metrics <command> lib
```

It will produce a result in one of the supported formats:

- Console
- GitHub
- Codeclimate
- HTML
- JSON

**Note:** you need to configure `rules` entry in the `analysis_options.yaml` to have rules report included into the result.

## Available commands {#available-commands}

The following table shows which commands you can use with the tool:

| Command            | Example of use                                            | Short description                                         |
| ------------------ | --------------------------------------------------------- | --------------------------------------------------------- |
| analyze            | dart run dart_code_metrics:metrics analyze lib            | Reports code metrics, rules and anti-patterns violations. |
| check-unused-files | dart run dart_code_metrics:metrics check-unused-files lib | Checks unused \*.dart files. |
| check-unused-l10n  | dart run dart_code_metrics:metrics check-unused-l10n lib  | Checks unused localization in *.dart files. |
| check-unused-code  | dart run dart_code_metrics:metrics check-unused-code lib  | Checks unused code in *.dart files. |

For additional help on any of the commands, enter `dart run dart_code_metrics:metrics help <command>`

## Multi-package repositories usage {#multi-package-repositories-usage}

If you run a command from the root of a multi-package repository (aka monorepo), it'll pick up `analysis_options.yaml` files correctly.

Additionally, if you use [Melos](https://pub.dev/packages/melos), you can add custom command to the `melos.yaml`.

```yaml title="melos.yaml"
metrics:
  run: |
    melos exec -c 1 --ignore="*example*" -- \
      flutter pub run dart_code_metrics:metrics analyze lib
  description: |
    Run `dart_code_metrics` in all packages.
     - Note: you can also rely on your IDEs Dart Analysis / Issues window.
```
