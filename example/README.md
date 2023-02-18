# Examples

DCM is a static analysis tool and code from it is not expected to be used directly. Instead, it should be added as a dev dependency and installed [as described here](https://dcm.dev/docs/individuals/getting-started).

## Preferred way: plugin and CLI

To use DCM as a plugin or a CLI, check out [this repository](https://github.com/dart-code-checker/dart-code-metrics-example) with the example Flutter app. It covers DCM setup and shows all commands output.

## Additional way: as a library

**Note:** usually you don't need to use DCM directly.

DCM can be used directly as a library, imported and called from your code. Continue with [this example](https://github.com/dart-code-checker/dart-code-metrics-example/blob/main/lib_example/lib/main.dart) in order to get more details.

## Presets

Presets can be enabled with `extends` config, more details [can be found here](https://dcm.dev/docs/individuals/configuration/presets/).
