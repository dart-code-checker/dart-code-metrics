// ignore_for_file: unnecessary_statements, cascade_invocations, prefer_const_declarations, omit_local_variable_types

import 'public_members.dart';
import 'unconditional_file.dart'
    if (dart.library.html) 'conditional_file.dart'
    if (dart.library.io) 'conditional_file.dart';
import 'unconditional_prefixed_file.dart'
    if (dart.library.html) 'conditional_prefixed_file.dart'
    if (dart.library.io) 'conditional_prefixed_file.dart' as config;

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

  calculateResults();

  config.calculate();

  setPadding();
}
