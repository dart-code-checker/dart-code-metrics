import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'lint_analysis_config.dart';
import 'models/issue.dart';
import 'models/lint_file_report.dart';
import 'models/severity.dart';
import 'rules/models/rule.dart';
import 'rules/rules_factory.dart';

class LintAnalysisOptionsValidator {
  static LintFileReport? validateOptions(
    LintAnalysisConfig config,
    String rootFolder,
  ) {
    final path = config.analysisOptionsPath;
    final file = path != null && File(path).existsSync() ? File(path) : null;
    if (file == null) {
      return null;
    }

    final fileContent = file.readAsStringSync();
    final node = loadYamlNode(fileContent);
    final rulesList = _getRulesList(node);
    if (rulesList == null) {
      return null;
    }

    final parsedRulesById = config.codeRules.fold(
      <String, Rule>{},
      (rules, rule) => rules..putIfAbsent(rule.id, () => rule),
    );

    final issues = _validateForIssues(rulesList, parsedRulesById);
    if (issues.isNotEmpty) {
      final filePath = file.path;
      final relativePath = relative(filePath, from: rootFolder);

      return LintFileReport.onlyIssues(
        path: file.path,
        relativePath: relativePath,
        issues: issues,
      );
    }

    return null;
  }

  static List<_RuleWithSpan>? _getRulesList(YamlNode node) {
    if (node is YamlMap) {
      final rules =
          (node['dart_code_metrics'] as YamlMap?)?['rules'] as YamlNode?;
      if (rules is YamlList) {
        return rules.nodes
            // ignore: avoid_types_on_closure_parameters
            .map((Object? rule) {
              if (rule is YamlMap) {
                final key = rule.nodes.keys.first as Object?;
                if (key is YamlScalar && key.value is String) {
                  return _RuleWithSpan(
                    key.value as String,
                    key.span,
                    hasConfig: true,
                  );
                }
              }

              if (rule is YamlScalar && rule.value is String) {
                return _RuleWithSpan(
                  rule.value as String,
                  rule.span,
                  hasConfig: false,
                );
              }

              return null;
            })
            .whereNotNull()
            .toList();
      }
    }

    return null;
  }

  static SourceSpan _copySpanWithOffset(SourceSpan span) => SourceSpan(
        SourceLocation(
          span.start.offset,
          sourceUrl: span.start.sourceUrl,
          line: span.start.line + 1,
          column: span.start.column + 1,
        ),
        SourceLocation(
          span.end.offset,
          sourceUrl: span.end.sourceUrl,
          line: span.end.line + 1,
          column: span.end.column + 1,
        ),
        span.text,
      );

  static List<Issue> _validateForIssues(
    List<_RuleWithSpan> rulesList,
    Map<String, Rule> parsedRulesById,
  ) {
    final ids = allRuleIds.toSet();
    final issues = <Issue>[];

    for (final rule in rulesList) {
      if (!ids.contains(rule.ruleName)) {
        issues.add(
          Issue(
            ruleId: 'unknown-config',
            severity: Severity.warning,
            message:
                "'${rule.ruleName}' is not recognized as a valid rule name.",
            documentation: Uri.parse('https://dcm.dev/docs/rules'),
            location: _copySpanWithOffset(rule.span),
          ),
        );
      }

      final parsedRule = parsedRulesById[rule.ruleName];
      if (parsedRule != null && parsedRule.requiresConfig && !rule.hasConfig) {
        issues.add(
          Issue(
            ruleId: 'requires-config',
            severity: Severity.warning,
            message:
                "'${rule.ruleName}' requires a config to produce any diagnostics.",
            documentation: Uri.parse('https://dcm.dev/docs/rules'),
            location: _copySpanWithOffset(rule.span),
          ),
        );
      }
    }

    return issues;
  }
}

class _RuleWithSpan {
  final String ruleName;
  final SourceSpan span;
  final bool hasConfig;

  const _RuleWithSpan(this.ruleName, this.span, {required this.hasConfig});
}
