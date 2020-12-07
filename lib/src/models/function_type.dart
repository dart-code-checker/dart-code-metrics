class FunctionType {
  static const FunctionType classConstructor = FunctionType._('Constructor');
  static const FunctionType classMethod = FunctionType._('Method');
  static const FunctionType staticFunction = FunctionType._('Function');

  final String _value;

  const FunctionType._(this._value);

  @override
  String toString() => _value;
}
