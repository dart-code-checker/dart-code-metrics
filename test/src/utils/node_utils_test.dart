import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/utils/node_utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

class AnnotatedNodeMock extends Mock implements AnnotatedNode {}

class CompilationUnitMock extends Mock implements CompilationUnit {}

class LineInfoMock extends Mock implements LineInfo {}

class TokenMock extends Mock implements Token {}

void main() {
  group('nodeLocation returns information about node original code', () {
    const nodeComment = '/*comment*/';
    const nodeCode = 'code';
    const node = '$nodeComment$nodeCode';
    const preNodeCode = 'prefix ';
    const postNodeCode = ' postfix';

    const line = 2;

    const nodeOffset = preNodeCode.length;
    final nodeOffsetLineInfo = CharacterLocation(line, nodeOffset - line);

    const nodeEnd = nodeOffset + node.length;
    final nodeEndLineInfo = CharacterLocation(line, nodeEnd - line);

    const codeOffset = preNodeCode.length + nodeComment.length;
    final codeOffsetLineInfo = CharacterLocation(line, codeOffset - line);

    const sourcePath = '/source.dart';

    final lineInfoMock = LineInfoMock();
    when(() => lineInfoMock.getLocation(nodeOffset))
        .thenReturn(nodeOffsetLineInfo);
    when(() => lineInfoMock.getLocation(nodeEnd)).thenReturn(nodeEndLineInfo);
    when(() => lineInfoMock.getLocation(codeOffset))
        .thenReturn(codeOffsetLineInfo);

    final tokenMock = TokenMock();
    when(() => tokenMock.offset).thenReturn(codeOffset);
    when(() => tokenMock.end).thenReturn(nodeEnd);

    final nodeMock = AnnotatedNodeMock();
    when(() => nodeMock.firstTokenAfterCommentAndMetadata)
        .thenReturn(tokenMock);
    when(() => nodeMock.offset).thenReturn(nodeOffset);
    when(() => nodeMock.end).thenReturn(nodeEnd);

    final sourceStub = InternalResolvedUnitResult(
      sourcePath,
      '$preNodeCode$node$postNodeCode',
      CompilationUnitMock(),
      lineInfoMock,
    );

    test('without comment or metadata', () {
      final span = nodeLocation(node: nodeMock, source: sourceStub);

      expect(span.sourceUrl?.toFilePath(), equals(p.normalize(sourcePath)));

      expect(span.start.offset, equals(codeOffset));
      expect(span.start.line, equals(line));
      expect(span.start.column, equals(codeOffset - line));

      expect(span.end.offset, equals(nodeEnd));
      expect(span.end.line, equals(line));
      expect(span.end.column, equals(nodeEnd - line));

      expect(span.text, equals(nodeCode));
    });
    test('with comment or metadata', () {
      final span = nodeLocation(
        node: nodeMock,
        source: sourceStub,
        withCommentOrMetadata: true,
      );

      expect(
        span.start.sourceUrl?.toFilePath(),
        equals(p.normalize(sourcePath)),
      );
      expect(span.start.offset, equals(nodeOffset));
      expect(span.start.line, equals(line));
      expect(span.start.column, equals(nodeOffset - line));

      expect(span.end.sourceUrl?.toFilePath(), equals(p.normalize(sourcePath)));
      expect(span.end.offset, equals(nodeEnd));
      expect(span.end.line, equals(line));
      expect(span.end.column, equals(nodeEnd - line));

      expect(span.text, equals(node));
    });
  });
}
