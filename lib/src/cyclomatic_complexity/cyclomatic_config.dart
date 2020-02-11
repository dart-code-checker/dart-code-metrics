import 'package:meta/meta.dart';

@immutable
class CyclomaticConfig {
  static const Iterable<String> _options = [
    'assertStatement',
    'blockFunctionBody',
    'catchClause',
    'conditionalExpression',
    'forEachStatement',
    'forStatement',
    'ifStatement',
    'switchDefault',
    'switchCase',
    'whileStatement',
    'yieldStatement',
  ];

  final Map<String, int> _addedComplexityByControlFlowType;

  int complexityByControlFlowType(String type) {
    if (!_options.contains(type)) {
      throw ArgumentError.value(type);
    }

    return _addedComplexityByControlFlowType[type] ?? 0;
  }

  CyclomaticConfig({Iterable<int> complexity})
      : _addedComplexityByControlFlowType = Map<String, int>.fromIterables(
            _options, complexity ?? _options.map((_) => 1));
}

final CyclomaticConfig defaultCyclomaticConfig = CyclomaticConfig();
