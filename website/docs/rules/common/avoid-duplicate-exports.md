# Avoid duplicate exports

## Rule id {#rule-id}

avoid-duplicate-exports

## Severity {#severity}

Warning

## Description {#description}

Warns when a file has multiple `exports` declarations with the same URI.

### Example {#example}

With the configuration in the example below, here are some bad/good examples.

Bad:

```dart
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

export 'package:my_app/good_folder/something.dart';
export 'package:my_app/good_folder/something.dart'; // LINT
```

Good:

```dart
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

export 'package:my_app/good_folder/something.dart';
```
