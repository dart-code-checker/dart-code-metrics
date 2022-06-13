import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/context_root.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:dart_code_metrics/src/utils/analyzer_utils.dart';
import 'package:glob/glob.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class AnalysisContextMock extends Mock implements AnalysisContext {}

class ContextRootMock extends Mock implements ContextRoot {}

class FolderMock extends Mock implements Folder {}

void main() {
  group('getFilePaths', () {
    const folderPath = 'file_paths_folder';
    const rootFolder = 'test/resources';

    final folder = FolderMock();
    final contextRoot = ContextRootMock();
    final context = AnalysisContextMock();

    setUp(() {
      when(() => folder.path).thenReturn('test/resources');
      when(() => contextRoot.root).thenReturn(folder);
      when(() => context.contextRoot).thenReturn(contextRoot);
    });

    test(
      'should return paths to the files',
      () {
        const excludes = <Glob>[];

        final filePaths =
            getFilePaths([folderPath], context, rootFolder, excludes).toList()
              ..sort();

        expect(filePaths, hasLength(3));

        const startPath = '$rootFolder/$folderPath';

        final firstPath = filePaths.first;
        expect(firstPath, '$startPath/first_file.dart');

        final secondPath = filePaths.elementAt(1);
        expect(secondPath, '$startPath/inner_folder/first_inner_file.dart');

        final thirdPath = filePaths.last;
        expect(thirdPath, '$startPath/second_file.dart');
      },
      testOn: 'posix',
    );

    test(
      'should return paths to the files without excluded',
      () {
        final excludes = [Glob('**/second_file.dart')];

        final filePaths =
            getFilePaths([folderPath], context, rootFolder, excludes).toList()
              ..sort();

        expect(filePaths, hasLength(2));

        const startPath = '$rootFolder/$folderPath';

        final firstPath = filePaths.first;
        expect(firstPath, '$startPath/first_file.dart');

        final secondPath = filePaths.last;
        expect(secondPath, '$startPath/inner_folder/first_inner_file.dart');
      },
      testOn: 'posix',
    );

    test(
      'should normalize file path if root path has relative parts',
      () {
        const rootFolder = 'test/resources/./';
        final excludes = [Glob('**/first*file.dart')];

        final filePaths =
            getFilePaths([folderPath], context, rootFolder, excludes).toList()
              ..sort();

        expect(filePaths, hasLength(1));

        final firstPath = filePaths.first;
        expect(firstPath, 'test/resources/file_paths_folder/second_file.dart');
        expect(firstPath, isNot(contains(rootFolder)));
      },
      testOn: 'posix',
    );
  });
}
