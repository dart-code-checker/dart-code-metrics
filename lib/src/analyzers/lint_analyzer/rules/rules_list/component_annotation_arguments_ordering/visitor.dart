part of 'component_annotation_arguments_ordering_rule.dart';

class _Visitor extends SimpleAstVisitor<List<_ArgumentInfo>> {
  final List<_ArgumentGroup> _groupsOrder;

  _Visitor(this._groupsOrder);

  @override
  List<_ArgumentInfo> visitClassDeclaration(ClassDeclaration node) {
    final componentAnnotation =
        node.metadata.firstWhereOrNull(_isComponentAnnotation);

    return componentAnnotation != null
        ? _visitAnnotation(componentAnnotation)
        : [];
  }

  List<_ArgumentInfo> _visitAnnotation(Annotation node) {
    final argumentsInfo = <_ArgumentInfo>[];

    final arguments = node.arguments?.arguments.whereType<NamedExpression>();

    if (arguments != null) {
      for (final argument in arguments) {
        final name = argument.name.label.name;
        final group = _ArgumentGroup.parseArgumentName(name);

        if (group != null && _groupsOrder.contains(group)) {
          argumentsInfo.add(_ArgumentInfo(
            argument: argument,
            argumentOrder: _getOrder(group, argumentsInfo),
          ));
        }
      }
    }

    return argumentsInfo;
  }

  _ArgumentOrder _getOrder(
    _ArgumentGroup group,
    Iterable<_ArgumentInfo> argumentsInfo,
  ) {
    if (argumentsInfo.isNotEmpty) {
      final lastArgumentOrder = argumentsInfo.last.argumentOrder;
      final hasSameGroup = lastArgumentOrder.argumentGroup == group;

      final previousArgumentGroup = hasSameGroup
          ? lastArgumentOrder.previousArgumentGroup
          : lastArgumentOrder.argumentGroup;

      return _ArgumentOrder(
        argumentGroup: group,
        previousArgumentGroup: previousArgumentGroup,
        isWrong: (hasSameGroup && lastArgumentOrder.isWrong) ||
            _isCurrentGroupBefore(lastArgumentOrder.argumentGroup, group),
      );
    }

    return _ArgumentOrder(isWrong: false, argumentGroup: group);
  }

  bool _isCurrentGroupBefore(
    _ArgumentGroup lastArgumentGroup,
    _ArgumentGroup argumentGroup,
  ) =>
      _groupsOrder.indexOf(lastArgumentGroup) >
      _groupsOrder.indexOf(argumentGroup);

  bool _isComponentAnnotation(Annotation node) =>
      node.name.name == 'Component' && node.atSign.type == TokenType.AT;
}

class _ArgumentGroup {
  final String name;
  final Iterable<String> arguments;

  static const selector = _ArgumentGroup._(
    'selector',
    ['selector'],
  );
  static const templates = _ArgumentGroup._(
    'templates',
    ['template', 'templateUrl'],
  );
  static const styles = _ArgumentGroup._(
    'styles',
    ['styles', 'styleUrls'],
  );
  static const directives = _ArgumentGroup._(
    'directives',
    ['directives', 'directiveTypes'],
  );
  static const pipes = _ArgumentGroup._(
    'pipes',
    ['pipes'],
  );
  static const providers = _ArgumentGroup._(
    'providers',
    ['providers', 'viewProviders'],
  );
  static const encapsulation = _ArgumentGroup._(
    'encapsulation',
    ['encapsulation'],
  );
  static const visibility = _ArgumentGroup._(
    'visibility',
    ['visibility'],
  );
  static const exports = _ArgumentGroup._(
    'exports',
    ['exports', 'exportAs'],
  );
  static const changeDetection = _ArgumentGroup._(
    'change-detection',
    ['changeDetection'],
  );

  static const _groupsOrder = [
    selector,
    templates,
    styles,
    directives,
    pipes,
    providers,
    encapsulation,
    visibility,
    exports,
    changeDetection,
  ];

  const _ArgumentGroup._(this.name, this.arguments);

  static _ArgumentGroup? parseGroupName(String name) =>
      _groupsOrder.firstWhereOrNull((group) => group.name == name);

  static _ArgumentGroup? parseArgumentName(String name) =>
      _groupsOrder.firstWhereOrNull((group) => group.arguments.contains(name));
}

class _ArgumentInfo {
  final NamedExpression argument;
  final _ArgumentOrder argumentOrder;

  const _ArgumentInfo({
    required this.argument,
    required this.argumentOrder,
  });
}

class _ArgumentOrder {
  final bool isWrong;
  final _ArgumentGroup argumentGroup;
  final _ArgumentGroup? previousArgumentGroup;

  const _ArgumentOrder({
    required this.isWrong,
    required this.argumentGroup,
    this.previousArgumentGroup,
  });
}
