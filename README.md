[![Build Status](https://github.com/wrike/metrics/workflows/build/badge.svg)](https://github.com/wrike/metrics/)
[![Pub Version](https://img.shields.io/pub/v/dart_code_metrics?style=flat)](https://pub.dev/packages/dart_code_metrics/)

### The Dart command line tool which helps to improve code quality
Reports:
* Cyclomatic complexity of methods
* Too long methods
* Number of Arguments

Output formats:
* Plain terminal
* JSON
* HTML
* Codeclimate

### Simple usage:
```bash
pub global activate dart_code_metrics
metrics lib
```

### Full usage:
```
Usage: metrics [options...] <directories>
-h, --help                                             Print this usage information.
-r, --reporter=<console>                               The format of the output of the analysis
                                                       [console (default), json, html, codeclimate]

    --cyclomatic-complexity=<20>                       Cyclomatic complexity threshold
                                                       (defaults to "20")

    --lines-of-code=<50>                               Lines of code threshold
                                                       (defaults to "50")

    --number-of-arguments=<4>                          Number of arguments threshold
                                                       (defaults to "4")

    --root-folder=<./>                                 Root folder
                                                       (defaults to current directory)

    --ignore-files=<{/**.g.dart,/**.template.dart}>    Filepaths in Glob syntax to be ignored
                                                       (defaults to "{/**.g.dart,/**.template.dart}")

    --verbose
    --set-exit-on-violation-level=<warning>            Set exit code 2 if code violations same or higher level than selected are detected
                                                       [noted, warning, alarm]
```

### Use as library
See `example/example.dart`
