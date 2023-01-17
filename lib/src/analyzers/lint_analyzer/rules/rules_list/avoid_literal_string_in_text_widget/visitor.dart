part of 'avoid_literal_string_in_text_widget_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {

  final _literalStringInTextWidget = <StringLiteral>[];

  Iterable<StringLiteral> get literalStringInTextWidget => _literalStringInTextWidget;

  @override
  void visitStringLiteral(StringLiteral node) {
    if(_shouldIgnore(node) || node.stringValue == null){
      return;
    }
    _literalStringInTextWidget.add(node);
  }

  bool _shouldIgnore(AstNode origNode) {
    AstNode? node = origNode;
    AstNode? nodeChild;
    AstNode? nodeChildChild;

    for (; node != null; nodeChildChild = nodeChild, nodeChild = node, node = node.parent) {
      try {
        if (node is ImportDirective || node is PartDirective || node is PartOfDirective) {
          return true;
        }

        if (node.parent == null) {
          return true;
        }
        if (node.parent is ReturnStatement || node.parent is AssignmentExpression) {
          return true;
        }

        if(node.parent!.parent is MethodInvocation) {
          return true;
        }

        if (node.parent is ArgumentList && node.parent!.parent is InstanceCreationExpression) {
          final constructorName = (node.parent!.parent as InstanceCreationExpression).constructorName.toString();
          if (constructorName.contains('Text')) {
            return false;
          }
        }

        // if (node is StringLiteral && node.stringValue!.contains(RegExp(r'([\u4e00-\u9fa5]+)')) == false) {
        //   return true;
        // }

        if (node is Annotation) {
          return true;
        }
      } catch (e) {}
    }

    return true;
  }
}
