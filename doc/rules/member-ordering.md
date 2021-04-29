# Member ordering

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

member-ordering

## Description

Enforces member ordering.

The value for `order` may be an array consisting of the following strings (default order listed):

- public-fields
- private-fields
- public-getters
- private-getters
- public-setters
- private-setters
- constructors
- public-methods
- private-methods
- angular-inputs
- angular-outputs
- angular-host-bindings
- angular-host-listeners
- angular-view-children
- angular-content-children

The `alphabetize` option will enforce that members within the same category should be alphabetically sorted by name.

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - member-ordering:
        alphabetize: true
        order:
          - public-fields
          - private-fields
          - constructors
```
