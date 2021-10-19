class Example {
  final v = '';
  final String? v2 = null;

  void main() {
    final result = v is String; // LINT
    final result2 = v2 is String?; // LINT
    final result3 = v is String?;
    final result4 = v2 is String;
  }
}
