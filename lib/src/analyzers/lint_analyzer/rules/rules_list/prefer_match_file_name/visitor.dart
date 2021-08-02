part of 'prefer_match_file_name.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <SimpleIdentifier>[];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _declarations.add(node.name);
  }

  Iterable<Issue> getIssueList(InternalResolvedUnitResult source) {
    final _issue = <Issue>[];
    final declaration = _declarations..sort(_compareByPrivateType);

    if (declaration.isNotEmpty &&
        !_hasMatchName(source.path, declaration.first.name)) {
      final issue = createIssue(
        rule: PreferMatchFileName(),
        location: nodeLocation(
          node: declaration.first,
          source: source,
          withCommentOrMetadata: true,
        ),
        message: _issueMessage,
      );

      _issue.add(issue);
    }

    return _issue;
  }

  bool _hasMatchName(String path, String className) {
    final classNameFormatted =
        className.replaceFirst('_', '').camelCaseToSnakeCase();

    return classNameFormatted == basenameWithoutExtension(path);
  }

  int _compareByPrivateType(SimpleIdentifier a, SimpleIdentifier b) {
    final isAPrivate = Identifier.isPrivateName(a.name);
    final isBPrivate = Identifier.isPrivateName(b.name);
    if (!isAPrivate && isBPrivate) {
      return -1;
    } else if (isAPrivate && !isBPrivate) {
      return 1;
    } else {
      return a.offset.compareTo(b.offset);
    }
  }
}
