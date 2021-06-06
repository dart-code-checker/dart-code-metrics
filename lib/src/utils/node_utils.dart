import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:source_span/source_span.dart';

import '../analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';

/// Returns [SourceSpan] with information about original code for [node] from [source]
SourceSpan nodeLocation({
  required SyntacticEntity node,
  required InternalResolvedUnitResult source,
  bool withCommentOrMetadata = false,
}) {
  final offset = !withCommentOrMetadata && node is AnnotatedNode
      ? node.firstTokenAfterCommentAndMetadata.offset
      : node.offset;
  final end = node.end;
  final sourceUrl = Uri.file(source.path);

  final offsetLocation = source.lineInfo.getLocation(offset);
  final endLocation = source.lineInfo.getLocation(end);

  return SourceSpan(
    SourceLocation(
      offset,
      sourceUrl: sourceUrl,
      line: offsetLocation.lineNumber,
      column: offsetLocation.columnNumber,
    ),
    SourceLocation(
      end,
      sourceUrl: sourceUrl,
      line: endLocation.lineNumber,
      column: endLocation.columnNumber,
    ),
    source.content.substring(offset, end),
  );
}
