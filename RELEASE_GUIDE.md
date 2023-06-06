# Release guide

## Changelog updates

* each entry should end with a `.`
* all updated entities has a link pointing to the website (ex. rule update, metric update)

## Check and bump version

* the version should be updated in:
  * ./CHANGELOG.md
  * ./pubspec.yaml
  * ./lib/src/version.dart
  * ./tools/analyzer_plugin/pubspec.yaml

## Publishing

* commit and push all changes to the master branch
* create a git tag with a new version name
* run `dart pub publish --dry-run.`. Only one warning is allowed:

  ```bash
  Rename the top-level "tools" directory to "tool".
    The Pub layout convention is to use singular directory names.
    Plural names won't be correctly identified by Pub and other tools.
    See https://dart.dev/tools/pub/package-layout.
  ```

* run `dart pub publish`
* create a [new draft release on GitHub](https://github.com/dart-code-checker/dart-code-metrics/releases)
  * select the newly created tag
  * generate release notes (clean them from the dependabot updates)
  * publish release
