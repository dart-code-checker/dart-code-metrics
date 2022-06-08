class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const a = TextButton(
      onPressed: () => null,
      child: Container(),
    );

    const b = TextButton(
      onPressed: () {
        firstLine();
        secondLine();
        thirdLine();
      },
      child: Container(),
    );

    const c = TextButton(
      // LINT
      onPressed: () {
        firstLine();
        secondLine();
        thirdLine();
        fourthLine();
      },
      child: Container(),
    );

    return Container();
  }
}
