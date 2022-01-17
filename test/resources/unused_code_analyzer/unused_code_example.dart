import 'public_members.dart';

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
}
