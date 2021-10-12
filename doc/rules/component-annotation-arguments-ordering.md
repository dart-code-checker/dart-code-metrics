# Component annotation arguments ordering

![Configurable](https://img.shields.io/badge/-configurable-informational)

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/angular/component-annotation-arguments-ordering).

## Rule id

component-annotation-arguments-ordering

## Description

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

### Config example

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
