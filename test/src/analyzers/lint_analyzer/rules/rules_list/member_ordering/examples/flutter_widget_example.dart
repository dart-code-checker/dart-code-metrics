class _MyStatelessWidget extends StatelessWidget {
  const _MyStatelessWidget();

  void doNothing() {}

  // LINT
  @override
  Widget build(BuildContext context) {
    return Widget();
  }

  @override
  void initState() {} // LINT

  @override
  void didChangeDependencies() {} // LINT

  @override
  void didUpdateWidget() {} // LINT

  @override
  void dispose() {} // LINT

  @override
  void someOtherMethod() {} // LINT
}

class Widget {}

class StatelessWidget extends Widget {
  Widget build(BuildContext context);

  void initState(); // LINT

  void didChangeDependencies(); // LINT

  void didUpdateWidget(); // LINT

  void dispose(); // LINT

  void someOtherMethod();
}

class BuildContext {}
