// ignore_for_file: public_member_api_docs, deprecated_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../utils/node_utils.dart';

class UnusedFilesVisitor extends GeneralizingAstVisitor<void> {
  final String currentFilePath;
  final bool ignoreExports;

  final _paths = <String>[];

  Iterable<String> get paths => _paths;

  UnusedFilesVisitor(this.currentFilePath, {required this.ignoreExports});

  @override
  void visitUriBasedDirective(UriBasedDirective node) {
    final absolutePath = node.uriSource?.fullName;

    if (absolutePath != null) {
      _paths.add(absolutePath);
    }

    if (node is NamespaceDirective) {
      for (final config in node.configurations) {
        final path = config.uriSource?.fullName;

        if (path != null) {
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
    if (isEntrypoint(node.name.name, node.metadata)) {
      _paths.add(currentFilePath);
    }
  }
}
