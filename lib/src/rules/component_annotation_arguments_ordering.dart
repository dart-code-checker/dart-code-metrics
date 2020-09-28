import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class ComponentAnnotationArgumentsOrderingRule extends BaseRule {
  static const ruleId = 'component-annotation-arguments-ordering';
  static const _documentationUrl = 'https://git.io/JJ5HC';

  static const _warningMessage = 'should be before';

  final List<_ArgumentGroup> _groupsOrder;

  ComponentAnnotationArgumentsOrderingRule(
      {Map<String, Object> config = const {}})
      : _groupsOrder = _parseOrder(config),
        super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.style);

  @override
  Iterable<CodeIssue> check(
    CompilationUnit unit,
    Uri sourceUrl,
    String sourceContent,
  ) {
    final _visitor = _Visitor(_groupsOrder);

    final argumentsInfo = [
      for (final entry in unit.childEntities)
        if (entry is ClassDeclaration) ...entry.accept(_visitor),
    ];

    return argumentsInfo.where((info) => info.argumentOrder.isWrong).map(
          (info) => createIssue(
              this,
              'Arguments group ${info.argumentOrder.argumentGroup.name} $_warningMessage ${info.argumentOrder.previousArgumentGroup.name}',
              null,
              null,
              sourceUrl,
              sourceContent,
              unit.lineInfo,
              info.argument),
        );
  }

  static List<_ArgumentGroup> _parseOrder(Map<String, Object> config) {
    final order = config.containsKey('order') && config['order'] is Iterable
        ? List<String>.from(config['order'] as Iterable)
        : <String>[];

    return order.isEmpty
        ? _ArgumentGroup._groupsOrder
        : order
            .map(_ArgumentGroup.parseGroupName)
            .where((group) => group != null)
            .toList();
  }
}

class _Visitor extends SimpleAstVisitor<List<_ArgumentInfo>> {
  final List<_ArgumentGroup> _groupsOrder;

  _Visitor(this._groupsOrder);

  @override
  List<_ArgumentInfo> visitClassDeclaration(ClassDeclaration node) {
    final componentAnnotation =
        node.metadata.firstWhere(_isComponentAnnotation, orElse: () => null);

    return componentAnnotation != null
        ? _visitAnnotation(componentAnnotation)
        : [];
  }

  List<_ArgumentInfo> _visitAnnotation(Annotation node) {
    final _argumentsInfo = <_ArgumentInfo>[];

    final arguments = node.arguments.arguments.whereType<NamedExpression>();

    for (final argument in arguments) {
      final name = argument.name.label.name;
      final group = _ArgumentGroup.parseArgumentName(name);

      if (group != null && _groupsOrder.contains(group)) {
        _argumentsInfo.add(_ArgumentInfo(
          argument: argument,
          argumentOrder: _getOrder(group, name, _argumentsInfo),
        ));
      }
    }

    return _argumentsInfo;
  }

  _ArgumentOrder _getOrder(
    _ArgumentGroup group,
    String argumentName,
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
      node.name.name == 'Component' && node.atSign.type.lexeme == '@';
}

@immutable
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
    'change_detection',
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

  static _ArgumentGroup parseGroupName(String name) => _groupsOrder.firstWhere(
        (group) => group.name == name,
        orElse: () => null,
      );

  static _ArgumentGroup parseArgumentName(String name) =>
      _groupsOrder.firstWhere(
        (group) => group.arguments.contains(name),
        orElse: () => null,
      );
}

@immutable
class _ArgumentInfo {
  final NamedExpression argument;
  final _ArgumentOrder argumentOrder;

  const _ArgumentInfo({
    this.argument,
    this.argumentOrder,
  });
}

@immutable
class _ArgumentOrder {
  final bool isWrong;
  final _ArgumentGroup argumentGroup;
  final _ArgumentGroup previousArgumentGroup;

  const _ArgumentOrder({
    this.isWrong,
    this.argumentGroup,
    this.previousArgumentGroup,
  });
}
