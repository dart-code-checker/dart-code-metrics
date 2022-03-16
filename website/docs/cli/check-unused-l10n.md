# Check unused l10n

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

Read more about this localization approach [in the Flutter docs](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#defining-a-class-for-the-apps-localized-resources).

By default the command searches for classes that end with `I18n`, but you can override this behavior with `--class-pattern` argument.

To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-l10n lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-l10n lib
```

Full command description:

```text
Usage: metrics check-unused-l10n [arguments] <directories>
-h, --help                                        Print this usage information.


-p, --class-pattern=<I18n$>                       The pattern to detect classes providing localization
                                                  (defaults to "I18n$")


-r, --reporter=<console>                          The format of the output of the analysis.
                                                  [console (default), json]
    --report-to-file=<path/to/report.json>        The path, where a JSON file with the analysis result will be placed (only for the JSON reporter).


    --root-folder=<./>                            Root folder.
                                                  (defaults to current directory)
    --sdk-path=<directory-path>                   Dart SDK directory path. 
                                                  Should be provided only when you run the application as compiled executable(https://dart.dev/tools/dart-compile#exe) and automatic Dart SDK path detection fails.
    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.
                                                  (defaults to "{/**.g.dart,/**.template.dart}")


    --no-congratulate                             Don't show output even when there are no issues.


    --[no-]fatal-unused                           Treat find unused l10n as fatal.
```

## Output example {#output-example}

### Console {#console}

Use `--reporter=console` to enable this format.

![Console](../../static/img/unused-l10n-console-report.png)

### JSON {#json}

The reporter prints a single JSON object containing meta information and the unused file paths. Use `--reporter=json` to enable this format.

#### The **root** object fields are {#the-root-object-fields-are}

- `formatVersion` - an integer representing the format version (will be incremented each time the serialization format changes)
- `timestamp` - a creation time of the report in YYYY-MM-DD HH:MM:SS format
- `unusedLocalizations` - an array of [unused files](#the-unusedlocalizations-object-fields-are)

```JSON
{
  "formatVersion": 2,
  "timestamp": "2021-04-11 14:44:42",
  "unusedLocalizations": [
    {
      ...
    },
    {
      ...
    },
    {
      ...
    }
  ]
}
```

#### The **unusedLocalizations** object fields are {#the-unusedlocalizations-object-fields-are}

- `path` - a relative path of the unused file
- `className` - a name of the class that has unused members
- `issues` - an array of [issues](#the-issue-object-fields-are) detected in the target class

```JSON
{
  "path": "lib/src/some/class.dart",
  "className": "class",
  "issues": [
    ...
  ],
}
```

#### The **issue** object fields are {#the-issue-object-fields-are}

- `memberName` - unused class member name
- `offset` - a zero-based offset of the class member location in the source
- `line` - a zero-based line of the class member  location in the source
- `column` - a zero-based column of class member  the location in the source

```JSON
{
  "memberName": "someGetter",
  "offset": 156,
  "line": 7,
  "column": 1
}
```
