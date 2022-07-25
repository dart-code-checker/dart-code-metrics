// ignore_for_file: avoid_positional_boolean_parameters, library_private_types_in_public_api, override_on_non_overriding_member, unused_local_variable, no-empty-block

// LINT
void printInteger(int aNumber) {
  print('The number is $aNumber.'); // Print to console.
}

void printBool(bool value) {
  print(value); // Print to console.
}

// LINT
const String someVariable = 'hello';

const String someOtherVariable = 'world';

class MyWidget extends StatefulWidget {
  final String prop;

  MyWidget(this.prop);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends BaseState<MyWidget> {
  String myString = '';

  String data = '';

  final service = SomeService();

  @override
  void initState() {
    super.initState();

    myAsyncMethod();
  }

  void myMethod() {
    setState(() {
      myString = 'Hello';
    });
  }

  Future<void> myAsyncMethod() async {
    final data = await service.fetchData();

    setState(() {
      myString = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final widget = ElevatedButton(
      onPressed: myMethod,
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );

    myAsyncMethod();

    return ElevatedButton(
      onPressed: myMethod,
      onLongPress: () {
        setState(() {
          myString = data;
        });
      },
      child: Text('PRESS'),
    );
  }
}

class ElevatedButton implements Widget {
  final Function onPressed;
  final Function onLongPress;
  final dynamic child;

  const ElevatedButton({
    required this.onPressed,
    required this.onLongPress,
    this.child,
  });
}

class StatefulWidget {
  dynamic createState() {}
}

// LINT
class SomeClassWithMethod {
  void myMethod() {}
}

class State<T> {}

abstract class BaseState<T> extends State<T> {
  dynamic initState() {}
  dynamic setState(void Function() newState) {}
}

class Widget with Mixin {}

class BuildContext {}

class Text {
  final String value;

  Text(this.value);
}

class SomeService {
  Future<String> fetchData() async => 'new string';
}

// LINT
class SomeOtherService {
  final String value;

  SomeOtherService(this.value);

  void init() {}
}

class ClassWithStaticFiled {
  static const field = 'value';
}

class ClassWithStaticMethod {
  static String printHello() => 'hello';
}

extension StringX on String {
  void doNothing() {}
}

// LINT
extension IntX on int {
  void doOtherNothing() {}
}

enum SomeEnum {
  hello,
}

// LINT
enum SomeOtherEnum {
  world,
}

mixin Mixin {}

typedef Hello = String;

// LINT
typedef World = int;

const double _kMenuVerticalPadding = 1;

void setPadding() {
  const padding = _kMenuVerticalPadding;
}

// LINT
class MyOtherWidget extends StatefulWidget {
  MyOtherWidget();

  @override
  _MyOtherWidgetState createState() => _MyOtherWidgetState();
}

class _MyOtherWidgetState extends BaseState<MyOtherWidget> {
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {},
        onLongPress: () {},
        child: Text('PRESS'),
      );
}

// ignore: unused-code
void ignoredPrintBool(bool value) {
  print(value); // Print to console.
}
