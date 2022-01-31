# Check unused code

Checks unused classes, functions, top level variables, extensions, enums, mixins and type aliases.

**Note:** current implementation doesn't check for particular class methods usage. Also, it treats code, that is imported with not named conditional imports as unused. This will be fixed in the future releases.

To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-code lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-code lib
```

Full command description:

```text
Usage: metrics check-unused-code [arguments] <directories>
-h, --help                                        Print this usage information.


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


    --[no-]monorepo                               Treats all exported code as unused by default.


    --[no-]fatal-unused                           Treat find unused file as fatal.
```

## Monorepo support

By default the command treats all code that exported from the package as used. To disable this behavior use `--monorepo` flag. This might be useful when all the packages in your repository only unused inside this repository and not published to pub.

## Output example {#output-example}

### Console {#console}

Use `--reporter=console` to enable this format.

![Console](../../static/img/unused-code-console-report.png)

### JSON {#json}

The reporter prints a single JSON object containing meta information and the unused code file paths. Use `--reporter=json` to enable this format.

#### The **root** object fields are {#the-root-object-fields-are}

- `formatVersion` - an integer representing the format version (will be incremented each time the serialization format changes)
- `timestamp` - a creation time of the report in YYYY-MM-DD HH:MM:SS format
- `unusedCode` - an array of [unused code issues](#the-unusedcode-object-fields-are)

```JSON
{
  "formatVersion": 2,
  "timestamp": "2021-04-11 14:44:42",
  "unusedCode": [
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

#### The **unusedCode** object fields are {#the-unusedcode-object-fields-are}

- `path` - a relative path of the unused file
- `issues` - an array of [issues](#the-issue-object-fields-are) detected in the target file

```JSON
{
  "path": "lib/src/some/file.dart",
  "issues": [
    ...
  ],
}
```

#### The **issue** object fields are {#the-issue-object-fields-are}

- `declarationType` - unused declaration type
- `declarationName` - unused declaration name
- `offset` - a zero-based offset of the class member location in the source
- `line` - a zero-based line of the class member  location in the source
- `column` - a zero-based column of class member  the location in the source

```JSON
{
  "declarationType": "extension",
  "declarationName": "StringX",
  "offset": 156,
  "line": 7,
  "column": 1
}
```
