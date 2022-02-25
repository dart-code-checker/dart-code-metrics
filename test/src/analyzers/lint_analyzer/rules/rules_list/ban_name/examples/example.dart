import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;

void func() {
  myShowDialog('some_arguments', 'another_argument');
  showDialog('some_arguments', 'another_argument'); // LINT
  material.showDialog('some_arguments', 'another_argument'); // LINT

  myShowSnackBar(42);
  showSnackBar(42); // LINT
}
