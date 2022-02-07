# Prefer async await

## Rule id {#rule-id}

prefer-async-await

## Severity {#severity}

Style

## Description {#description}

Recommends to use async/await syntax to handle Futures result instead of `.then()` invocation. Also can help prevent errors with mixed `await` and `.then()` usages, since awaiting the result of a `Future` with `.then()` invocation awaits the completion of `.then()`.

### Example {#example}

Bad:

```dart
Future<void> main() async {
  someFuture.then((result) => handleResult(result)); // LINT

  await (foo.asyncMethod()).then((result) => handleResult(result)); // LINT
}
```

Good:

```dart
Future<void> main() async {
  final result = await someFuture; (result) => handleResult(result));
  handleResult(result);

  final anotherResult = await foo.asyncMethod();
  handleResult(anotherResult);
} 
```
