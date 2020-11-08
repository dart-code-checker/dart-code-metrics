# Component annotation arguments ordering

![Configurable](https://img.shields.io/badge/-configurable-informational)

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
- change_detection

### Config example

```yaml
component-annotation-arguments-ordering:
  order:
    - selector
    - templates
    - change_detection
```
