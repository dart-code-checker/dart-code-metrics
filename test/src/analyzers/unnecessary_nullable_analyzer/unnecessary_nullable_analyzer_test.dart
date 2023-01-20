import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_code_metrics/src/analyzers/unnecessary_nullable_analyzer/models/unnecessary_nullable_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unnecessary_nullable_analyzer/reporters/reporters_list/console/unnecessary_nullable_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_config.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group(
    'UnnecessaryNullableAnalyzer',
    () {
      const analyzer = UnnecessaryNullableAnalyzer();
      const rootDirectory = '';
      const analyzerExcludes = [
        'test/resources/unnecessary_nullable_analyzer/generated/**',
      ];
      final folders = [
        normalize(
          File('test/resources/unnecessary_nullable_analyzer').absolute.path,
        ),
      ];

      group('run analysis', () {
        late final Iterable<UnnecessaryNullableFileReport> result;

        setUpAll(() async {
          final config =
              _createConfig(analyzerExcludePatterns: analyzerExcludes);

          result = await analyzer.runCliAnalysis(
            folders,
            rootDirectory,
            config,
          );
        });

        test('should report 3 files and not report excluded file', () {
          expect(result, hasLength(3));
        });

        test('should analyze nullable class parameters', () async {
          final report = result.firstWhere((report) =>
              report.path.endsWith('nullable_class_parameters.dart'));

          expect(report.issues, hasLength(2));

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'AlwaysUsedAsNonNullable');
          expect(firstIssue.declarationType, 'constructor');
          expect(firstIssue.parameters.toString(), '(this.anotherValue)');
          expect(firstIssue.location.line, 11);
          expect(firstIssue.location.column, 3);

          final secondIssue = report.issues.last;
          expect(secondIssue.declarationName, 'NamedNonNullable');
          expect(secondIssue.declarationType, 'constructor');
          expect(secondIssue.parameters.toString(), '(this.value)');
          expect(secondIssue.location.line, 24);
          expect(secondIssue.location.column, 3);
        });

        test('should analyze nullable method parameters', () async {
          final report = result.firstWhere(
            (report) => report.path.endsWith('nullable_method_parameters.dart'),
          );

          expect(report.issues, hasLength(2));

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'alwaysNonNullable');
          expect(firstIssue.declarationType, 'method');
          expect(firstIssue.parameters.toString(), '(String? anotherValue)');
          expect(firstIssue.location.line, 9);
          expect(firstIssue.location.column, 3);

          final secondIssue = report.issues.last;
          expect(secondIssue.declarationName, 'multipleParametersWithNamed');
          expect(secondIssue.declarationType, 'method');
          expect(
            secondIssue.parameters.toString(),
            '(String? value, required String? name)',
          );
          expect(secondIssue.location.line, 18);
          expect(secondIssue.location.column, 3);
        });

        test('should analyze nullable function parameters', () async {
          final report = result.firstWhere(
            (report) =>
                report.path.endsWith('nullable_function_parameters.dart'),
          );

          expect(report.issues, hasLength(3));

          final firstIssue = report.issues.first;
          expect(firstIssue.declarationName, 'alwaysNonNullableDoSomething');
          expect(firstIssue.declarationType, 'function');
          expect(firstIssue.parameters.toString(), '(String? anotherValue)');
          expect(firstIssue.location.line, 6);
          expect(firstIssue.location.column, 1);

          final secondIssue = report.issues.elementAt(1);
          expect(secondIssue.declarationName, 'multipleParametersWithNamed');
          expect(secondIssue.declarationType, 'function');
          expect(
            secondIssue.parameters.toString(),
            '(String? value, required String? name)',
          );
          expect(secondIssue.location.line, 17);
          expect(secondIssue.location.column, 1);

          final thirdIssue = report.issues.elementAt(2);
          expect(thirdIssue.declarationName, 'multipleParametersWithOptional');
          expect(thirdIssue.declarationType, 'function');
          expect(
            thirdIssue.parameters.toString(),
            '(String? value, String? name)',
          );
          expect(thirdIssue.location.line, 25);
          expect(thirdIssue.location.column, 1);
        });

        test(
          'should analyze ignored parameters and report no issues',
          () async {
            final report = result.firstWhereOrNull((report) =>
                report.path.endsWith('nullable_widget_key_parameters.dart'));

            expect(report, isNull);
          },
        );
      });

      test('should return a reporter', () {
        final reporter = analyzer.getReporter(name: 'console', output: stdout);

        expect(reporter, isA<UnnecessaryNullableConsoleReporter>());
      });
    },
    testOn: 'posix',
  );
}

UnnecessaryNullableConfig _createConfig({
  Iterable<String> analyzerExcludePatterns = const [],
}) =>
    UnnecessaryNullableConfig(
      excludePatterns: const [],
      analyzerExcludePatterns: analyzerExcludePatterns,
      isMonorepo: false,
      shouldPrintConfig: false,
    );
