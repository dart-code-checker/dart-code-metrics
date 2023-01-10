part of 'use_setstate_synchronously_rule.dart';

/// Similar to a [bool], with an optional third indeterminate state and metadata.
abstract class Fact<T> {
  const factory Fact.maybe([T? info]) = _Maybe;
  const Fact._();

  T? get info => null;
  bool? get value => null;

  bool get isDefinite => this is! _Maybe;

  Fact<U> _asValue<U>() => value! ? true.asFact() : false.asFact();

  Fact<T> get not {
    if (isDefinite) {
      return value! ? false.asFact() : true.asFact();
    }

    // ignore: avoid_returning_this
    return this;
  }

  Fact<U> or<U>(Fact<U> other) => isDefinite ? _asValue() : other;

  Fact<U> orElse<U>(Fact<U> Function() other) =>
      isDefinite ? _asValue() : other();

  @override
  String toString() => isDefinite ? '(definite: $value)' : '(maybe: $info)';
}

class _Bool<T> extends Fact<T> {
  @override
  final bool value;

  // ignore: avoid_positional_boolean_parameters
  const _Bool(this.value) : super._();
}

class _Maybe<T> extends Fact<T> {
  @override
  final T? info;

  const _Maybe([this.info]) : super._();
}

extension _BoolExt on bool {
  Fact<T> asFact<T>() => this ? const _Bool(true) : const _Bool(false);
}
