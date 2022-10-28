// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../utils/node_utils.dart';

class UnusedFilesVisitor extends GeneralizingAstVisitor<void> {
  final String currentFilePath;
  final bool ignoreExports;

  final _paths = <String>[];

  Iterable<String> get paths => _paths;

  UnusedFilesVisitor(this.currentFilePath, {required this.ignoreExports});

  @override
  void visitUriBasedDirective(UriBasedDirective node) {
    final absolutePath = _getAbsolutePath(node);
    if (absolutePath != null) {
      _paths.add(absolutePath);
    }

    if (node is NamespaceDirective) {
      for (final config in node.configurations) {
        final uri = config.resolvedUri;
        if (uri is DirectiveUriWithSource) {
          final path = uri.source.fullName;
          _paths.add(path);
        }
      }
    }

    if (!ignoreExports &&
        node is ExportDirective &&
        !_paths.contains(currentFilePath)) {
      _paths.add(currentFilePath);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (isEntrypoint(node.name.lexeme, node.metadata)) {
      _paths.add(currentFilePath);
    }
  }

  String? _getAbsolutePath(UriBasedDirective node) {
    if (node is ImportDirective) {
      // ignore: deprecated_member_use
      return node.element2?.importedLibrary?.source.fullName;
    }

    if (node is ExportDirective) {
      // ignore: deprecated_member_use
      return node.element2?.exportedLibrary?.source.fullName;
    }

    if (node is PartDirective) {
      // ignore: deprecated_member_use
      final uri = node.element2?.uri;
      if (uri is DirectiveUriWithSource) {
        return uri.source.fullName;
      }
    }

    return null;
  }
}
