void main() {
  print('Hello');

  test('good unit test', () {
    final a = 1;
    final b = 2;
    final c = a + 1;
    expect(b, c);
  });

  testWidgets('good widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });

  test('with expectLater', () {
    await expectLater(1, 1);
  });

  test('with expectAsync0', () {
    expectAsync0(() {});
  });

  test('with expectAsync1', () {
    expectAsync1((p0) {});
  });

  test('with expectAsync1', () {
    expectAsync2((p0, p1) {});
  });

  test('with expectAsync3', () {
    expectAsync3((p0, p1, p2) {});
  });

  test('with expectAsync4', () {
    expectAsync4((p0, p1, p2, p3) {});
  });

  test('with expectAsync5', () {
    expectAsync5((p0, p1, p2, p3, p4) {});
  });

  test('with expectAsync6', () {
    expectAsync6((p0, p1, p2, p3, p4, p5) {});
  });

  test('with expectAsyncUntil0', () {
    expectAsyncUntil0(() {}, () => true);
  });

  test('with expectAsyncUntil1', () {
    expectAsyncUntil1((p0) {}, () => true);
  });

  test('with expectAsyncUntil2', () {
    expectAsyncUntil2((p0, p1) {}, () => true);
  });

  test('with expectAsyncUntil3', () {
    expectAsyncUntil3((p0, p1, p2) {}, () => true);
  });

  test('with expectAsyncUntil4', () {
    expectAsyncUntil4((p0, p1, p2, p3) {}, () => true);
  });

  test('with expectAsyncUntil5', () {
    expectAsyncUntil5((p0, p1, p2, p3, p4) {}, () => true);
  });

  test('with expectAsyncUntil6', () {
    expectAsyncUntil6((p0, p1, p2, p3, p4, p5) {}, () => true);
  });

  test('with fail', () {
    fail('some failure reason');
  });

  test(null, () => expect(1, 1));
}
