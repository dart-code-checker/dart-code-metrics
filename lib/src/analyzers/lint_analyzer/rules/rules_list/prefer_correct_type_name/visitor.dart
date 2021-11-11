part of 'prefer_correct_type_name_rule.dart';

class _Visitor extends ScopeVisitor {
  final _nodes = <SimpleIdentifier>[];
  final _Validator validator;

  _Visitor(this.validator);

  Iterable<SimpleIdentifier> get nodes => _nodes;

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    super.visitEnumDeclaration(node);

    if (!validator.isValid(node.name.name)) {
      _nodes.add(node.name);
    }
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    super.visitExtensionDeclaration(node);

    if (node.name != null && !validator.isValid(node.name!.name)) {
      _nodes.add(node.name!);
    }
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    super.visitMixinDeclaration(node);

    if (!validator.isValid(node.name.name)) {
      _nodes.add(node.name);
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    if (!validator.isValid(node.name.name)) {
      _nodes.add(node.name);
    }
  }
}
