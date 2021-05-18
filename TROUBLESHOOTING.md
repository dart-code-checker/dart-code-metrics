# Troubleshooting

**Note:** If the plugin is analyzing files it should not analyze (like `.dart_tool/` or an external package source code), please create [an issue](https://github.com/dart-code-checker/dart-code-metrics/issues/new?assignees=dkrutskikh&labels=bug&template=bug-report.md&title=%5BBUG%5D+), it's most likely a bug.

If the plugin is not working as you'd expect it to work, please consider going through the following steps before creating [an issue](https://github.com/dart-code-checker/dart-code-metrics/issues/new?assignees=dkrutskikh&labels=bug&template=bug-report.md&title=%5BBUG%5D+):

1. Check that the plugin is added to an `analyzer` entry in the `analysis_options.yaml` as described in the [Configuration](./README.md#Configuration) section.

2. Check that the `dart_code_metrics` entry in the `analysis_options.yaml` is configured correctly. Note, that you need to add each rule or metric you want to be checked to the config and there is **no** default rule or metric lists config. **Note:** for a rule config there is a 4 spaces / 2 tabs indentation.

3. Check that the `dart_code_metrics` package is added as a dev dependency to the same package, where the plugin entry added to the `analysis_options.yaml`. If you use a separate sub package for an analyzer configuration, please follow [this discussion](https://github.com/dart-code-checker/dart-code-metrics/issues/254).

4. Restart the IDE to invalidate the cache and check if the issue remains.

5. Open Analyzer Diagnostics and check that the plugin is active. To do that:
    - For VS Code: open the command palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and invoke `Dart: Open Analyzer Diagnostics`.

    - For Android Studio (or any other JetBrains IDE): open the `Dart Analysis` tab, click `Analyzer settings` and then click `View analyzer diagnostics`.

    then a `Analyzer Server Diagnostics` webpage will be opened.

    To check that the plugin is active, open the `Plugins` tab and ensure that there is no errors.

    If there is an error or the plugin is still not working as expected, please create [an issue](https://github.com/dart-code-checker/dart-code-metrics/issues/new?assignees=dkrutskikh&labels=bug&template=bug-report.md&title=%5BBUG%5D+) with the `Plugins`  page screenshot, it will be very useful for an investigation.
