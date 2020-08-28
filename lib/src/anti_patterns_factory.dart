import 'anti_patterns/base_pattern.dart';
import 'anti_patterns/long_method.dart';

final _implementedPatterns = <String, BasePattern Function()>{
  LongMethod.patternId: () => LongMethod(),
};

Iterable<BasePattern> get allPatterns =>
    _implementedPatterns.keys.map((id) => _implementedPatterns[id]());

Iterable<BasePattern> getPatternsById(Iterable<String> patternsId) =>
    List.unmodifiable(_implementedPatterns.keys
        .where((id) => patternsId.contains(id))
        .map<BasePattern>((id) => _implementedPatterns[id]()));
