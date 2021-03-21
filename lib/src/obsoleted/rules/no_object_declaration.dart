// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

class NoObjectDeclarationRule extends Rule {
  static const String ruleId = 'no-object-declaration';
  static const _documentationUrl = 'https://git.io/JJwmY';

  static const _warningMessage =
      'Avoid Object type declaration in class member';

  NoObjectDeclarationRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.members
        .map(
          (member) => createIssue(
            this,
            nodeLocation(
              node: member,
              source: source,
              withCommentOrMetadata: true,
            ),
            _warningMessage,
            null,
          ),
        )
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _members = <ClassMember>[];

  Iterable<ClassMember> get members => _members;

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    super.visitFieldDeclaration(node);

    if (_hasObjectType(node.fields.type)) {
      _members.add(node);
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if (_hasObjectType(node.returnType)) {
      _members.add(node);
    }
  }

  bool _hasObjectType(TypeAnnotation type) =>
      type?.type?.isDartCoreObject ??
      (type is TypeName && type.name.name == 'Object');
}
