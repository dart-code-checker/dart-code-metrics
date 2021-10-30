# Component annotation arguments ordering

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id {#rule-id}

component-annotation-arguments-ordering

## Severity {#severity}

Style

## Description {#description}

Enforces Angular `@Component` annotation arguments ordering.

The value for `order` may be an array consisting of the following strings (default order listed):

- selector
- templates
- styles
- directives
- pipes
- providers
- encapsulation
- visibility
- exports
- change-detection

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - component-annotation-arguments-ordering:
        order:
          - selector
          - templates
          - change-detection
```
