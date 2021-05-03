// @TestOn('vm')
// import 'package:analyzer/dart/analysis/results.dart';
// import 'package:dart_code_metrics/src/analyzer_plugin/plugin_utils.dart';
// import 'package:glob/glob.dart';
// import 'package:test/test.dart';
// import 'package:mocktail/mocktail.dart';

// class AnalysisResultMock extends Mock implements AnalysisResult {}

// void main() {
//   group('isExcluded checks passed path to exclude', () {
//     test('UNIX style paths', () {
//       final excludes = [
//         '/home/user/project/.dart_tool/**',
//         '/home/user/project/packages/**',
//         '/home/user/project/src/exclude_me.dart',
//       ].map((item) => Glob(item));

//       final result = AnalysisResultMock();
//       when(() => result.path)
//           .thenReturn('/home/user/project/src/exclude_me.dart');

//       expect(isExcluded(result, excludes), isTrue);
//     });

//     test('Windows style paths', () {
//       final excludes = [
//         'c:/Users/dmitry/Development/.dart_tool/**',
//         'c:/Users/dmitry/Development/packages/**',
//         'c:/Users/dmitry/Development/src/exclude_me.dart',
//       ].map((item) => Glob(item));

//       final result = AnalysisResultMock();
//       when(() => result.path)
//           .thenReturn(r'c:\Users\dmitry\Development/src/exclude_me.dart');

//       expect(isExcluded(result, excludes), isTrue);
//     });
//   });

//   group('prepareExcludes returns array of Glob with absolute path in', () {
//     const patterns = ['.dart_tool/**', 'packages/**', 'src/exclude_me.dart'];
//     test('UNIX', () {
//       final exludes = prepareExcludes(patterns, '/home/user/project');

//       expect(
//         exludes.map((exclude) => exclude.pattern),
//         equals([
//           '/home/user/project/.dart_tool/**',
//           '/home/user/project/packages/**',
//           '/home/user/project/src/exclude_me.dart',
//         ]),
//       );
//     });

//     test('Windows', () {
//       final exludes = prepareExcludes(patterns, r'c:\Users\dmitry\Development');

//       expect(
//         exludes.map((exclude) => exclude.pattern),
//         equals([
//           'c:/Users/dmitry/Development/.dart_tool/**',
//           'c:/Users/dmitry/Development/packages/**',
//           'c:/Users/dmitry/Development/src/exclude_me.dart',
//         ]),
//       );
//     });
//   });
// }
