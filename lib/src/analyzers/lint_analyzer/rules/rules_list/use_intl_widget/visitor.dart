part of 'use_intl_widget_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final FlutterRule rule;
  final InternalResolvedUnitResult source;
  _Visitor({required this.rule, required this.source});

  final _issues = <Issue>[];

  Iterable<Issue> get issues => _issues;

  @override
  void visitConstructorName(ConstructorName node) {
    final constructorName = node.toString();

    if (constructorName == 'Border.only' ||
        constructorName == 'BorderRadius.only' ||
        constructorName == 'BorderRadius.horizontal' ||
        constructorName == 'Positioned' ||
        constructorName == 'Positioned.fill' ||
        constructorName == 'EdgeInsets' ||
        constructorName == 'EdgeInsets.only' ||
        constructorName == 'EdgeInsets.fromLTRB') {
      var shouldFix = false;
      final parent = node.parent;
      if (parent is! InstanceCreationExpression) {
        return;
      }

      for (final element in parent.argumentList.arguments) {
        if (element is! NamedExpression) {
          return;
        }

        var label = element.name.toString();
        if (label == 'left:') {
          label = 'start:';
          shouldFix = true;
        }
        if (label == 'right:') {
          label = 'end:';
          shouldFix = true;
        }
      }
      if (!shouldFix) {
        return;
      }

      // final constructorNameType = node.type2.toString();
      // _issues.add(createIssue(
      //   rule: rule,
      //   location: nodeLocation(
      //     node: node,
      //     source: source,
      //   ),
      //   message: 'RTL:Use ${constructorNameType}Directional instead',
      // ));
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    final prefix = node.prefix.name;
    if ('Alignment' == prefix) {
      var shouldFix = false;
      var fixResult = node.toString().replaceFirst(prefix, "${prefix}Directional");
      if (node.identifier.name.contains('Left')) {
        fixResult = fixResult.replaceFirst('Left', 'Start');
        shouldFix = true;
      }

      if (node.identifier.name.contains('Right')) {
        fixResult = fixResult.replaceFirst('Right', 'End');
        shouldFix = true;
      }

      if (!shouldFix) {
        return;
      }

      _issues.add(createIssue(
        rule: rule,
        location: nodeLocation(
          node: node,
          source: source,
        ),
        message: 'RTL:Use ${prefix}Directional instead',
      ));
    }
  }
}
