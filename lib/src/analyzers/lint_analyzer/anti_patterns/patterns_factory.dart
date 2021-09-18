import '../lint_config.dart';
import 'anti_patterns_list/long_method.dart';
import 'anti_patterns_list/long_parameter_list.dart';
import 'models/obsolete_pattern.dart';

typedef CreatePattern = ObsoletePattern Function(
  Map<String, Object> patternSettings,
  Map<String, Object> metricstTresholds,
);

final _implementedPatterns = <String, CreatePattern>{
  LongMethod.patternId: (settings, tresholds) =>
      LongMethod(patternSettings: settings, metricstTresholds: tresholds),
  LongParameterList.patternId: (settings, tresholds) => LongParameterList(
      patternSettings: settings, metricstTresholds: tresholds),
};

Iterable<ObsoletePattern> get allPatterns =>
    _implementedPatterns.keys.map((id) => _implementedPatterns[id]!({}, {}));

Iterable<ObsoletePattern> getPatternsById(LintConfig config) =>
    List.unmodifiable(_implementedPatterns.keys
        .where((id) => config.antiPatterns.keys.contains(id))
        .map<ObsoletePattern>((id) => _implementedPatterns[id]!(
              config.antiPatterns[id] as Map<String, Object>,
              config.metrics[id] as Map<String, Object>,
            )));
