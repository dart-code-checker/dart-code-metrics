void main() {
  print('Hello');

  test('bad unit test', () {
    final a = 1;
    final b = 2;
    final c = a + 1;
  }); // LINT

  testWidgets('bad widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
  }); // LINT

  test(null, () => 1 == 1); // LINT
}
