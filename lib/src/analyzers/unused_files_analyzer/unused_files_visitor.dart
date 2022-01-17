// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../utils/node_utils.dart';

class UnusedFilesVisitor extends GeneralizingAstVisitor<void> {
  final String _currentFilePath;

  final _paths = <String>[];

  Iterable<String> get paths => _paths;

  UnusedFilesVisitor(this._currentFilePath);

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

    if (node is ExportDirective && !_paths.contains(_currentFilePath)) {
      _paths.add(_currentFilePath);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (isEntrypoint(node.name.name, node.metadata)) {
      _paths.add(_currentFilePath);
    }
  }
}
