import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

void func() {
  myShowDialog('some_arguments', 'another_argument');
  showDialog('some_arguments', 'another_argument'); // LINT
  material.showDialog('some_arguments', 'another_argument'); // LINT

  var strangeName = 42; // LINT
}

void strangeName() {} // LINT

// LINT
class AnotherStrangeName {
  late var strangeName; // LINT
}
