# Examples

Dart Code Metrics is a static analysis tool and code from it is not expected to be used directly. Instead, it should be added as a dev dependency and installed [as described here](https://dartcodemetrics.dev/docs/getting-started/installation).

## Plugin and CLI

To use Dart Code Metrics as a plugin or a CLI, check out [this repository](https://github.com/dart-code-checker/dart-code-metrics-example) with the example Flutter app. It covers DCM setup and shows all commands output.

## As a library

Dart Code Metrics can be used as a library, imported and called directly from your code. Continue with [this example](https://github.com/dart-code-checker/dart-code-metrics/blob/master/example/lib/main.dart) in order to get more details.

## Presets

Dart Code Metrics supports presets:

- all Dart rules [dart_all.yaml](https://github.com/dart-code-checker/dart-code-metrics/blob/master/lib/presets/dart_all.yaml)
- all Flutter rules [flutter_all.yaml](https://github.com/dart-code-checker/dart-code-metrics/blob/master/lib/presets/flutter_all.yaml)
- all rules [all.yaml](https://github.com/dart-code-checker/dart-code-metrics/blob/master/lib/presets/all.yaml)

Presets can be enabled with `extends` config, more details [can be found here](https://dartcodemetrics.dev/docs/getting-started/configuration#extending-an-existing-configuration-preset).
