import '../lint_config.dart';
import 'anti_patterns_list/long_method.dart';
import 'anti_patterns_list/long_parameter_list.dart';
import 'models/pattern.dart';

typedef CreatePattern = Pattern Function(
  Map<String, Object> patternSettings,
  Map<String, Object> metricsThresholds,
);

final _implementedPatterns = <String, CreatePattern>{
  LongMethod.patternId: (settings, thresholds) =>
      LongMethod(patternSettings: settings, metricsThresholds: thresholds),
  LongParameterList.patternId: (settings, thresholds) => LongParameterList(
        patternSettings: settings,
        metricsThresholds: thresholds,
      ),
};

Iterable<Pattern> getPatternsById(LintConfig config) =>
    List.unmodifiable(_implementedPatterns.keys
        .where((id) => config.antiPatterns.keys.contains(id))
        .map<Pattern>((id) => _implementedPatterns[id]!(
              config.antiPatterns[id] as Map<String, Object>,
              config.metrics,
            )));
