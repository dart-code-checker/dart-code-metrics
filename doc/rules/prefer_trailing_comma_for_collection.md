# Prefer trailing a comma for collection

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id
prefer-trailing-comma-for-collection

## Description
Prefer trailing a comma for collection literals (`List<T>, Map<K, V>, Set<T>`).

### Example
Bad:
```dart
final a = [
  1
];

final a = [
  1, 
  2, 
  3
];

final b = <int>[1, 
  2, 
  3
];

final c = <Object>[
  const A('a1'), 
  const A('a2'), 
  const A('a3') 
];

var d = {
  'a', 
  'b'
};

var e = {
  'a': 1, 
  'b': 2
};

var e = <String, int>{'a': 1, 
  'b': 2,
  'c': 3,
  if (true)
    'e': 10
};
```

Good:
```dart
final a = [1, 2, 3];
final b = <int>[1, 2, 3];
var c = {'a', 'b'};
var d = {'a': 1, 'b': 2};
final c = <Object>[const A('a1'), const A('a2'), const A('a3')];

final a = [
  1,
];

final a = [
  1, 
  2, 
  3,
];

final b = <int>[1, 2, 
  3,
];

var c = {
  'a',
  'b',
};

var d = {
  'a': 1, 
  'b': 2,
};

final c = <Object>[
  const A('a1'), 
  const A('a2'), 
  const A('a3'),
];
```
