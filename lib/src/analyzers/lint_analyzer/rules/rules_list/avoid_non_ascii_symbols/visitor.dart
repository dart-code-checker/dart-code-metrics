part of 'avoid_non_ascii_symbols_rule.dart';

final _onlyAsciiSymbolsRegExp = RegExp(r'^[\u0000-\u007f]*$');

class _Visitor extends RecursiveAstVisitor<void> {
  final _literals = <SingleStringLiteral>[];

  Iterable<SingleStringLiteral> get literals => _literals;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    super.visitSimpleStringLiteral(node);

    if (!_onlyAsciiSymbolsRegExp.hasMatch(node.value)) {
      _literals.add(node);
    }
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    super.visitStringInterpolation(node);

    for (final element in node.elements) {
      if (element is InterpolationString &&
          !_onlyAsciiSymbolsRegExp.hasMatch(element.value)) {
        _literals.add(node);
        break;
      }
    }
  }
}
