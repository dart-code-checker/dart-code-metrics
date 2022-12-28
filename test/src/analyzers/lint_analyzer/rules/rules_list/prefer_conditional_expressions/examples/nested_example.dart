void main() {
  String? value = 'value';

  final condition = true;
  if (condition) {
    value = !condition ? 'new' : 'old';
  } else {
    value = null;
  }

  Widget traceColor;
  Widget? image;

  if (condition != null) {
    traceColor = condition ? Widget() : Widget();
  } else {
    traceColor = image == null ? Widget() : Widget();
  }
}

class Widget {}
