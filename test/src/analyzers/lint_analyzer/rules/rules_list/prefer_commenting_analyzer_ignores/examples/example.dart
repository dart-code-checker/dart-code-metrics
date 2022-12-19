// ignore_for_file: some_rule
void main() {
  // ignore: deprecated_member_use
  final map = Map(); // LINT

  // ignore: deprecated_member_use, long-method
  final set = Set(); // LINT

  // Ignored for some reasons
  // ignore: deprecated_member_use
  final list = List();

  // ignore: deprecated_member_use same line ignore
  final queue = Queue();

  // ignore: deprecated_member_use, long-method multiple same line ignore
  final linkedList = LinkedList();

  // ignore: avoid-non-null-assertion, checked for non-null
  final hashMap = HashMap();

  /// documentation comment
  // ignore: avoid-non-null-assertion
  final value = 1; // LINT
}
