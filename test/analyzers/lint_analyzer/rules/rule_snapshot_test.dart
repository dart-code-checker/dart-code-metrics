import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_factory.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path;
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../helpers/file_resolver.dart';

Map<String, dynamic> _sourceLocationToJsonObject(SourceLocation location) =>
    <String, dynamic>{
      'offset': location.offset.toString(),
      'line': location.line.toString(),
      'column': location.column.toString(),
    };

Map<String, dynamic> _sourceSpanToJsonObject(SourceSpan span) =>
    <String, dynamic>{
      'start': _sourceLocationToJsonObject(span.start),
      'end': _sourceLocationToJsonObject(span.end),
    };

Map<String, dynamic>? _replacementToJsonObject(Replacement? replacement) =>
    replacement == null
        ? null
        : <String, dynamic>{
            'comment': replacement.comment,
            'replacement': replacement.replacement,
          };

Map<String, dynamic> _issueToJsonObject(Issue issue) => <String, dynamic>{
      'ruleId': issue.ruleId,
      'documentation': issue.documentation.toString(),
      'location': _sourceSpanToJsonObject(issue.location),
      'severity': issue.severity.toString(),
      'message': issue.message,
      'verboseMessage': issue.verboseMessage.toString(),
      'suggestion': _replacementToJsonObject(issue.suggestion),
    };

Future<void> main() async {
  final lintAnalyzerPath = path.join('test', 'analyzers', 'lint_analyzer');
  final snapshotsPath = path.join(lintAnalyzerPath, 'snapshots');
  final rulesListPath = path.join(lintAnalyzerPath, 'rules', 'rules_list');

  for (final rule in allRules) {
    final examplePaths = Glob('*.dart');
    for (final examplePath in examplePaths.listSync(
      root: path.join(rulesListPath, rule.id.replaceAll('-', '_'), 'examples'),
    )) {
      final unit = await FileResolver.resolve(examplePath.path);
      final issues = rule.check(unit);
      final issuesJson = const JsonEncoder.withIndent('  ')
          .convert(issues.map<Object>(_issueToJsonObject).toList());

      final snapshotPath = path.join(
        snapshotsPath,
        rule.id,
        '${path.basename(examplePath.path)}.json',
      );
      final snapshotDirectory = Directory(path.dirname(snapshotPath));
      if (!snapshotDirectory.existsSync()) {
        snapshotDirectory.createSync(recursive: true);
      }
      final snapshotFile = File(snapshotPath);
      // https://pub.dev/packages/goldenrod
      // Platform.environment['UPDATE_SNAPSHOTS'] == 'true'
      final updateMode = true;
      if (updateMode) {
        snapshotFile.writeAsStringSync(issuesJson);
      } else {
        test('Snapshot test for rule ${rule.id}', () {
          expect(issuesJson, snapshotFile.readAsStringSync());
        });
      }
    }
  }
}
