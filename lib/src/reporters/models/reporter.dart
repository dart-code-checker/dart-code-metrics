/// Abstract reporter interface.
abstract class Reporter<T> {
  Future<void> report(T report);

  const Reporter();
}
