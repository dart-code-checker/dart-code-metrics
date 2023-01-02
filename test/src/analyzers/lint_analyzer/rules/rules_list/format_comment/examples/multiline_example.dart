/// Constructs a regular expression.
///
/// Throws a [FormatException] if [source] is not valid regular
/// expression syntax.
///
/// If `multiLine` is enabled, then `^` and `$` will match the beginning and
/// end of a _line_, in addition to matching beginning and end of input,
/// respectively.
///
/// If `caseSensitive` is disabled, then case is ignored.
///
/// If `unicode` is enabled, then the pattern is treated as a Unicode
/// pattern as described by the ECMAScript standard.
///
/// If `dotAll` is enabled, then the `.` pattern will match _all_ characters,
/// including line terminators.
///
/// Example:
///
/// ```dart
/// final wordPattern = RegExp(r'(\w+)');
/// final digitPattern = RegExp(r'(\d+)');
/// ```
///
/// Notice the use of a _raw string_ in the first example, and a regular
/// string in the second. Because of the many escapes, like `\d`, used in
/// regular expressions, it is common to use a raw string here, unless string
/// interpolation is required.
class Test {
  /// whether [_enclosingClass] and [_enclosingExecutable] have been
  /// initialized.
  Test() {
    // with start space with dot.
    // some text
  }

  // not
  // a
  // sentence
  // at all
  void method() {}

  /// With start space without dot
  /// that finished on another line.
  function() {}

  // Some comment about why the line is ignored.
  // ignore: text
  final a = 1;

  //Some wrong comment
  // ignore: text
  final b = 2;
}
