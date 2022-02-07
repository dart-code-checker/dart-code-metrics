---
sidebar_label: 'Installation and Usage'
sidebar_position: 1
---

# Installing the package

To install the package as a dev dependency run

```sh
$ dart pub add --dev dart_code_metrics

# or for a Flutter package
$ flutter pub add --dev dart_code_metrics
```

**OR**

add it manually to `pubspec.yaml`

```yaml title="pubspec.yaml"
environment:
  sdk: '>=2.12.0 <3.0.0'

dev_dependencies:
  dart_code_metrics: ^4.10.1
```

and then run

```sh
$ dart pub get

# or for a Flutter package
$ flutter pub get
```

## Usage {#usage}

### Analyzer plugin {#analyzer-plugin}

To use Dart Code Metrics as a plugin to the Dart analyzer refer to the [Analyzer Plugin documentation section](../analyzer-plugin.md).

### CLI {#cli}

To use Dart Code Metrics as a command-line tool refer to the [Command Line Interface documentation section](../cli/overview.md).

### Library {#library}

To use Dart Code Metrics as a library refer to this [example](https://github.com/dart-code-checker/dart-code-metrics/blob/master/example/example.dart).
