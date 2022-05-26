void main() {
  final english = 'hello';
  final chinese = 'hello 汉字'; // LINT
  final russian = 'hello привет'; // LINT
  final someGenericSymbols = '!@#${english}%^';
  final nonAsciiSymbols = '#!$_&-  éè  ;∞¥₤€'; // LINT
  final misspelling = 'inform@tiv€'; // LINT
}
