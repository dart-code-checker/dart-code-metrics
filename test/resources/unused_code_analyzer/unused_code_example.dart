// ignore_for_file: unnecessary_statements, cascade_invocations, prefer_const_declarations, omit_local_variable_types

import 'public_members.dart';
import 'unconditional_file.dart'
    if (dart.library.html) 'conditional_file.dart'
    if (dart.library.io) 'conditional_file.dart' as config;

part 'part_of_test_class.dart';
part 'part_of_test_class_2.dart';

void main() {
  final widget = MyWidget('hello');

  if (someOtherVariable == widget.prop) {
    widget.createState();
  }

  printBool(false);

  ClassWithStaticFiled.field;
  ClassWithStaticMethod.printHello();

  final Hello str = 'world';

  str.doNothing();

  SomeEnum.hello;

  config.calculateResults();

  setPadding();

  _PartOfTestClass();
  _PartOfTestClassWithNumberInFileName();
}
