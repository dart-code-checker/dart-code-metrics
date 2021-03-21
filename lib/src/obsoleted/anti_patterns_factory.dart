// ignore_for_file: public_member_api_docs, prefer-trailing-comma
import 'anti_patterns/base_pattern.dart';
import 'anti_patterns/long_method.dart';
import 'anti_patterns/long_parameter_list.dart';

final _implementedPatterns =
    <String, BasePattern Function(Map<String, Object>)>{
  LongMethod.patternId: (config) => LongMethod(),
  LongParameterList.patternId: (config) => LongParameterList(),
};

Iterable<BasePattern> get allPatterns =>
    _implementedPatterns.keys.map((id) => _implementedPatterns[id]({}));

Iterable<BasePattern> getPatternsById(Map<String, Object> patternsConfig) =>
    List.unmodifiable(_implementedPatterns.keys
        .where((id) => patternsConfig.keys.contains(id))
        .map<BasePattern>((id) => _implementedPatterns[id](
            patternsConfig[id] as Map<String, Object>)));
