# Number of Methods

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/metrics/number-of-methods).

The number of methods is the total number of methods in a class (or _mixin_, or _extension_). Too many methods indicate a high complexity.

## Config example

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    - number-of-methods: 10
```
