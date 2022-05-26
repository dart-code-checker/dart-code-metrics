# Ban name

## Rule id {#rule-id}

avoid-banned-imports

## Severity {#severity}

Style

## Description {#description}

Configure some imports that you want to ban.

### Example {#example}

With the configuration in the example below, here are some bad/good examples.

Bad:

```dart
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
```

Good:

```dart
// No restricted imports in listed folders.
```

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - avoid_restricted_imports
      - paths: ["some/**/folder/*.dart", "another/folder/**.dart"]
      deny: ["package:flutter/material.dart"]
      message: "Do not import Flutter Material Design library, we should not depend on it!"
      - paths: ["core/*.dart"]
        deny: ["package:flutter_bloc/flutter_bloc.dart"]
        message: 'State management should be not used inside "core" folder.'
```
