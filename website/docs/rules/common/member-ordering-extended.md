# Member ordering extended

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id {#rule-id}

member-ordering-extended

## Severity {#severity}

Style

## Description {#description}

**Note:** Don't use it with the default member-ordering rule!

Enforces extended member ordering.

The value for the `order` entry should match the following pattern:

`
< (overridden | protected)- >< (private | public)- >< static- >< late- >< (var | final | const)- >< nullable- >< named- >< factory- > (fields | getters | getters-setters | setters | constructors | methods)
`

where values in the `<>` are optional, values in the `()` are interchangeable and the last part of the pattern which represents a class member type is **REQUIRED**.

**Note:** not all of the pattern parts are applicable for every case, for example, `late-constructors` are not expected, since they are not supported by the language itself.

For example, the value for `order` may be an array consisting of the following strings:

- public-late-final-fields
- private-late-final-fields
- public-nullable-fields
- private-nullable-fields
- named-constructors
- factory-constructors
- getters
- setters
- public-static-methods
- private-static-methods
- protected-methods
- etc.

You can simply configure the rule to sort only by a type:

- fields
- methods
- setters
- getters (or just **getters-setters** if you don't want to separate them)
- constructors

The default config is:

- public-fields
- private-fields
- public-getters
- private-getters
- public-setters
- private-setters
- constructors
- public-methods
- private-methods

The `alphabetize` option will enforce that members within the same category should be alphabetically sorted by name.

The `alphabetize-by-type` option will enforce that members within the same category should be alphabetically sorted by theirs type name.

Only one alphabetize option could be applied at the same time.

### Config example {#config-example}

With the default config:

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - member-ordering-extended
```

**OR** with a custom one:

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - member-ordering-extended:
        alphabetize: true
        order:
          - public-fields
          - private-fields
          - constructors
```
