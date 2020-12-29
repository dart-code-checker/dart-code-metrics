import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/analysis.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class NoObjectDeclarationRule extends BaseRule {
  static const String ruleId = 'no-object-declaration';
  static const _documentationUrl = 'https://git.io/JJwmY';

  static const _warningMessage =
      'Avoid Object type declaration in class member';

  NoObjectDeclarationRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity:
              Severity.fromJson(config['severity'] as String) ?? Severity.style,
        );

  @override
  Iterable<Issue> check(ProcessedFile source) {
    final _visitor = _Visitor();

    source.parsedContent.visitChildren(_visitor);

    return _visitor.members
        .map(
          (member) => createIssue(
            this,
            _warningMessage,
            null,
            null,
            source.url,
            source.content,
            source.parsedContent.lineInfo,
            member,
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
