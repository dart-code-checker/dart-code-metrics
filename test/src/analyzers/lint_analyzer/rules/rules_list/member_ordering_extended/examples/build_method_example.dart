class _MyStatelessWidget extends StatelessWidget {
  const _MyStatelessWidget();

  void doNothing() {}

  // LINT
  @override
  _Widget build(_BuildContext context) {
    return _Widget();
  }

  @override
  void initState() {} // LINT
}

class _Widget {}

class _StatelessWidget extends _Widget {
  _Widget build(_BuildContext context);

  void initState();

  void dispose();
}

class _BuildContext {}
