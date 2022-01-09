import 'package:dart_code_metrics/src/utils/yaml_utils.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

const _yamlContent = '''
code_checker:
  metrics:
    cyclomatic-complexity: 20
    number-of-methods: 8
  metrics-exclude:
    - test/**
  rules:
    - no-boolean-literal-compare
''';

void main() {
  test('yamlMapToDartMap returns a dart map', () {
    final configMap = yamlMapToDartMap(loadYamlNode(_yamlContent) as YamlMap);
    expect(configMap.keys.single, equals('code_checker'));

    final codeCheckerConfigMap =
        configMap['code_checker'] as Map<String, Object>;
    expect(
      codeCheckerConfigMap.keys,
      containsAll(<String>['metrics', 'metrics-exclude', 'rules']),
    );

    final metricsCodeCheckerConfigMap =
        codeCheckerConfigMap['metrics'] as Map<String, Object>;
    expect(
      metricsCodeCheckerConfigMap,
      containsPair('cyclomatic-complexity', 20),
    );
    expect(
      metricsCodeCheckerConfigMap,
      containsPair('number-of-methods', 8),
    );

    final metricsExcludeCodeCheckerConfigList =
        codeCheckerConfigMap['metrics-exclude'] as List<Object>;
    expect(metricsExcludeCodeCheckerConfigList, equals(['test/**']));
  });
}
