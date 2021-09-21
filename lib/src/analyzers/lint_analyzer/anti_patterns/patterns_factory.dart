import '../lint_config.dart';
import 'anti_patterns_list/long_method.dart';
import 'anti_patterns_list/long_parameter_list.dart';
import 'models/pattern.dart';

typedef CreatePattern = Pattern Function(
  Map<String, Object> patternSettings,
  Map<String, Object> metricstTresholds,
);

final _implementedPatterns = <String, CreatePattern>{
  LongMethod.patternId: (settings, tresholds) =>
      LongMethod(patternSettings: settings, metricstTresholds: tresholds),
  LongParameterList.patternId: (settings, tresholds) => LongParameterList(
        patternSettings: settings,
        metricstTresholds: tresholds,
      ),
};

Iterable<Pattern> get allPatterns =>
    _implementedPatterns.keys.map((id) => _implementedPatterns[id]!({}, {}));

Iterable<Pattern> getPatternsById(LintConfig config) =>
    List.unmodifiable(_implementedPatterns.keys
        .where((id) => config.antiPatterns.keys.contains(id))
        .map<Pattern>((id) => _implementedPatterns[id]!(
              config.antiPatterns[id] as Map<String, Object>,
              config.metrics,
            )));
