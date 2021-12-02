# Weight Of a Class

Number of **functional** public methods divided by the total number of public methods.

This metric tries to quantify whether the measured class (or _mixin_, or _extension_) interface reveals more data than behavior. Low values indicate that the class reveals much more data than behavior, which is a sign of poor encapsulation.

Our definition of **functional** method excludes getters and setters.

## Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  metrics:
    ...
    weight-of-class: 0.33
    ...
```
