part of 'prefer_match_file_name.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final String pathToFile;

  final _declarations = <_NotMatchFileNameIssue>[];

  Iterable<_NotMatchFileNameIssue> get declarations => _declarations;

  _Visitor({required this.pathToFile}) : super();

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (getFileName(pathToFile) != _formatClassName(node.name.name)) {
      _declarations.add(_NotMatchFileNameIssue(
        node.name.name,
        pathToFile,
        node,
      ));
    }
  }

  String _formatClassName(String className) {
    final exp = RegExp('(?<=[a-z])[A-Z]');
    final result =
        className.replaceAllMapped(exp, (m) => '_${m.group(0)!}').toLowerCase();

    return result;
  }

  String getFileName(String filePath) =>
      filePath.split('/').last.split('.').first;
}

@immutable
class _NotMatchFileNameIssue extends IntlBaseIssue {
  final String? className;
  final String? fileName;

  const _NotMatchFileNameIssue(
    this.className,
    this.fileName,
    AstNode node,
  ) : super(node);

  static String getMessage() => 'File name does not match the class name';
}
