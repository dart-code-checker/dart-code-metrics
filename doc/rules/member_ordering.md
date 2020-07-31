# Member ordering

## Rule id

member-ordering

## Description

Enforces member ordering.

The value for `order` may be an array consisting of the following strings (default order listed):

- public_fields
- private_fields
- public_getters
- private_getters
- public_setters
- private_setters
- constructors
- public_methods
- private_methods
- angular_inputs
- angular_outputs
- angular_host_bindings
- angular_host_listeners
- angular_view_children
- angular_content_children

The `alphabetize` option will enforce that members within the same category should be alphabetically sorted by name.

## Config example

```yaml
member-ordering:
  alphabetize: true
  order:
    - public_fields
    - private_fields
    - constructors
```
