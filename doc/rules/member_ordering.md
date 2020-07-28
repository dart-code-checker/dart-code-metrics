# Member ordering

## Rule id

member-ordering

## Description

Enforces member ordering.

The value for order may be an array consisting of the following strings:

- public_fields
- private_fields
- public_getters
- private_getters
- public_setters
- private_setters
- public_methods
- private_methods
- constructors
- angular_inputs
- angular_outputs
- angular_host_bindings
- angular_host_listeners

## Config example

```yaml
member-ordering:
  order:
    - public_fields
    - private_fields
    - constructors
```
