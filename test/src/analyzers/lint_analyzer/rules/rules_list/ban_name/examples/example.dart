void func() {
  myShowDialog('some_arguments', 'another_argument');
  showDialog('some_arguments', 'another_argument'); // LINT

  myShowSnackBar(42);
  showSnackBar(42); // LINT
}
