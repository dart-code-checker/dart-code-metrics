# Member ordering

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

member-ordering-extended

## Description

**Note:** Don't use it with the default member-ordering rule!

Enforces extended member ordering.

The value for the `order` entry should match the following pattern:

`
< (overridden | protected)_ >< (private | public)_ >< static_ >< late_ >< (var | final | const)_ >< nullable_ >< named_ >< factory_> (fields | getters | getters_setters | setters | constructors | methods)
`

where values in the `<>` are optional, values in the `()` are interchangeable and the last part of the pattern which represents a class member type is **REQUIRED**.

**Note:** not all of the pattern parts are applicable for every case, for example, `late_constructors` are not expected, since they are not supported by the language itself.

For example, the value for `order` may be an array consisting of the following strings:

- public_late_final_fields
- private_late_final_fields
- public_nullable_fields
- private_nullable_fields
- named_constructors
- factory_constructors
- getters
- setters
- public_static_methods
- private_static_methods
- protected_methods
- etc.

You can simply configure the rule to sort only by a type:

- fields
- methods
- setters
- getters (or just **getters_setters** if you don't want to separate them)
- constructors

The default config is:

- public_fields
- private_fields
- public_getters
- private_getters
- public_setters
- private_setters
- constructors
- public_methods
- private_methods

The `alphabetize` option will enforce that members within the same category should be alphabetically sorted by name.

### Config example

With the default config:

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - member-ordering
```

**OR** with a custom one:

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - member-ordering:
        alphabetize: true
        order:
          - public_fields
          - private_fields
          - constructors
```
