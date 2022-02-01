# Check unused files

Checks unused `*.dart` files. To execute the command, run

```sh
$ dart run dart_code_metrics:metrics check-unused-files lib

# or for a Flutter package
$ flutter pub run dart_code_metrics:metrics check-unused-files lib
```

Full command description:

```text
Usage: metrics check-unused-files [arguments...] <directories>

-h, --help                                        Print this usage information.


-r, --reporter=<console>                          The format of the output of the analysis.
                                                  [console (default), json]


    --root-folder=<./>                            Root folder.
                                                  (defaults to current directory)
    --sdk-path=<directory-path>                   Dart SDK directory path. 
                                                  Should be provided only when you run the application as compiled executable(https://dart.dev/tools/dart-compile#exe) and automatic Dart SDK path detection fails.
    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.
                                                  (defaults to "{/**.g.dart,/**.template.dart}")


    --no-congratulate                             Don't show output even when there are no issues.


    --[no-]fatal-unused                           Treat find unused file as fatal.

-d, --[no-]delete-files                           Delete all unused files.
```

## Output example {#output-example}

### Console {#console}

Use `--reporter=console` to enable this format.

![Console](../../static/img/unused-files-console-report.png)

### JSON {#json}

The reporter prints a single JSON object containing meta information and the unused file paths. Use `--reporter=json` to enable this format.

#### The **root** object fields are {#the-root-object-fields-are}

- `formatVersion` - an integer representing the format version (will be incremented each time the serialization format changes)
- `timestamp` - a creation time of the report in YYYY-MM-DD HH:MM:SS format
- `unusedFiles` - an array of [unused files](#the-unusedFiles-object-fields-are)
- `automaticallyDeleted` - an indication of unused files being automatically deleted

```JSON
{
  "formatVersion": 2,
  "timestamp": "2021-04-11 14:44:42",
  "unusedFiles": [
    {
      ...
    },
    {
      ...
    },
    {
      ...
    }
  ],
  "automaticallyDeleted": false
}
```

#### The **unusedFiles** object fields are {#the-unusedfiles-object-fields-are}

- `path` - a relative path of the unused file

```JSON
{
  "path": "lib/src/some/file.dart",
}
```
