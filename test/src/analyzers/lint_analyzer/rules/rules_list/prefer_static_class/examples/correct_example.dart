void main() {}

Future<void> main() {}

class Example {
  void classMethod() {}
  static void staticClassMethod() {}
  var classVariable = 42;
  static var staticClassVariable = 42;
  static final staticClassFinalVariable = 42;
  static const classConstant = 42;

  void _privateClassMethod() {}
  static void _privateStaticClassMethod() {}
  var _privateClassVariable = 42;
  static var _privateStaticClassVariable = 42;
  static final _privateStaticClassFinalVariable = 42;
  static const _privateClassConstant = 42;
}

@FunctionalWidget
Widget functionalWidget() {}

@swidget
Widget statelessWidget() {}

@hwidget
Widget hookWidget() {}

@hcwidget
Widget hookConsumerWidget() {}

@riverpod
int riverpodFunction(riverpodFunction ref) => 0;
