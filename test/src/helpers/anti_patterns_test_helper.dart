import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:test/test.dart';

import 'file_resolver.dart';

class AntiPatternTestHelper {
  static Future<InternalResolvedUnitResult> resolveFromFile(
    String filePath,
  ) async {
    final fullPath =
        'test/analyzers/lint_analyzer/anti_patterns/anti_patterns_list/$filePath';

    return FileResolver.resolve(fullPath);
  }

  static void verifyInitialization({
    required Iterable<Issue> issues,
    required String antiPatternId,
    required Severity severity,
  }) {
    expect(issues.every((issue) => issue.ruleId == antiPatternId), isTrue);
    expect(issues.every((issue) => issue.severity == severity), isTrue);
  }

  static void verifyIssues({
    required Iterable<Issue> issues,
    Iterable<int>? startOffsets,
    Iterable<int>? startLines,
    Iterable<int>? startColumns,
    Iterable<int>? endOffsets,
    Iterable<String>? messages,
    Iterable<String>? verboseMessage,
  }) {
    if (startOffsets != null) {
      expect(
        issues.map((issue) => issue.location.start.offset),
        equals(startOffsets),
        reason: 'incorrect start offset',
      );
    }

    if (startLines != null) {
      expect(
        issues.map((issue) => issue.location.start.line),
        equals(startLines),
        reason: 'incorrect start line',
      );
    }

    if (startColumns != null) {
      expect(
        issues.map((issue) => issue.location.start.column),
        equals(startColumns),
        reason: 'incorrect start column',
      );
    }

    if (endOffsets != null) {
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals(endOffsets),
        reason: 'incorrect end offset',
      );
    }

    if (messages != null) {
      expect(
        issues.map((issue) => issue.message),
        equals(messages),
        reason: 'incorrect message',
      );
    }

    if (verboseMessage != null) {
      expect(
        issues.map((issue) => issue.verboseMessage),
        equals(verboseMessage),
        reason: 'incorrect verbose message',
      );
    }
  }
}
