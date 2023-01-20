// ignore_for_file: cascade_invocations, unused_local_variable, prefer_const_declarations

import 'nullable_class_parameters.dart';
import 'nullable_function_parameters.dart';
import 'nullable_method_parameters.dart';
import 'nullable_widget_key_parameters.dart';
import 'suppressed_file.dart';

void main() {
  final withMethods = ClassWithMethods();
  final nullableWrapper = _Test();
  final map = {'123': '321'};

  withMethods
    ..someMethod(null)
    ..someMethod('value')
    ..tearOff('str');

  withMethods.alwaysNonNullable('anotherValue');
  withMethods.ignoredAlwaysNonNullable('anotherValue');

  withMethods.multipleParametersUsed('123', 1, name: 'null');
  withMethods.multipleParametersUsed('123', 1, name: null);

  withMethods.multipleParametersWithNamed('value', 1, name: 'name');

  final nonNullableConstructor = const AlwaysUsedAsNonNullable('anotherValue');
  final nullableConstructor = const NullableClassParameters(null);
  final defaultNonNullable = const DefaultNonNullable(value: '321');
  final namedNonNullable = const NamedNonNullable(value: '123');

  IgnoredClassWithMethods().alwaysNonNullable('string');

  doSomething(_getNullableString());
  doSomething(map['321']);
  doSomething('value');

  alwaysNonNullableDoSomething('anotherValue');

  multipleParametersUsed('str', 1, name: nullableWrapper.level.uri);
  multipleParametersUsed('str', 1, name: 'name', secondName: 'secondName');
  multipleParametersUsed('str', 1, name: 'name', thirdName: 'thirdName');

  multipleParametersWithNamed('name', 1, name: 'secondName');
  multipleParametersWithOptional('name', 1, 'secondName');

  MyWidget(GlobalKey());

  AnotherWidget(onSubmit: withMethods.tearOff);
  AnotherWidget(onSubmit: withMethods.inner.anotherTearOff);
}

class _Test {
  _Test get level => _Test();
  String? get uri => null;
}

String? _getNullableString() => null;
