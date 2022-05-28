// ignore_for_file: cascade_invocations, unused_local_variable, prefer_const_declarations

import 'nullable_class_parameters.dart';
import 'nullable_function_parameters.dart';
import 'nullable_method_parameters.dart';

void main() {
  final withMethods = ClassWithMethods();
  final nullableWrapper = Test();

  withMethods
    ..someMethod(null)
    ..someMethod('value');

  withMethods.alwaysNonNullable('anotherValue');

  withMethods.multipleParametersUsed('123', 1, name: 'null');
  withMethods.multipleParametersUsed('123', 1, name: null);

  withMethods.multipleParametersWithNamed('value', 1, name: 'name');

  final nonNullableConstructor = const AlwaysUsedAsNonNullable('anotherValue');
  final nullableConstructor = const NullableClassParameters(null);
  final defaultNonNullable = const DefaultNonNullable(value: '321');
  final namedNonNullable = const NamedNonNullable(value: '123');

  doSomething(null);
  doSomething('value');

  alwaysNonNullableDoSomething('anotherValue');

  multipleParametersUsed('str', 1, name: nullableWrapper.level.uri);
  multipleParametersUsed('str', 1, name: 'name', secondName: 'secondName');
  multipleParametersUsed('str', 1, name: 'name', thirdName: 'thirdName');

  multipleParametersWithNamed('name', 1, name: 'secondName');
  multipleParametersWithOptional('name', 1, 'secondName');
}

class Test {
  Test get level => Test();
  String? get uri => null;
}
