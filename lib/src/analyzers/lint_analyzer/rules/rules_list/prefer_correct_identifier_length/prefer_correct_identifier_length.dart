import 'package:analyzer/dart/ast/ast.dart';

import '../../../../../utils/node_utils.dart';
import '../../../metrics/scope_visitor.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';

part 'visitor.dart';

const _defaultMinIdentifier = 3;
const _defaultMaxIdentifier = 30;

class PreferCorrectIdentifierLength extends CommonRule {
  static const String ruleId = 'prefer-correct-identifier-length';

  final int _minLength;
  final int _maxLength;

  final bool _checkFunctions;
  final bool _checkClassNames;
  final bool _checkIdentifiers;
  final bool _checkArguments;
  final bool _checkConstructors;
  final bool _checkMethods;
  final bool _checkGetters;
  final bool _checkSetters;

  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _minLength = _ConfigParser.parseMinIdentifierLength(config) ??
            _defaultMinIdentifier,
        _maxLength = _ConfigParser.parseMaxIdentifierLength(config) ??
            _defaultMaxIdentifier,
        _checkFunctions = _ConfigParser.parseCheckFunctionName(config) ?? true,
        _checkMethods = _ConfigParser.parseCheckMethodName(config) ?? true,
        _checkClassNames = _ConfigParser.parseCheckClassName(config) ?? true,
        _checkGetters = _ConfigParser.parseCheckGetters(config) ?? true,
        _checkSetters = _ConfigParser.parseCheckSetters(config) ?? true,
        _checkIdentifiers = _ConfigParser.parseCheckIdentifier(config) ?? true,
        _checkArguments = _ConfigParser.checkArgumentsName(config) ?? true,
        _checkConstructors = _ConfigParser.checkConstructorName(config) ?? true,
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct identifier length',
            brief: 'Warns when identifier name length very short or long.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issues = <Issue>[
      if (_checkArguments) ..._addArgumentIssues(source, visitor.argumentNodes),
      if (_checkClassNames) ..._addClassIssues(source, visitor.classNodes),
      if (_checkFunctions) ..._addFunctionIssues(source, visitor.functionNodes),
      if (_checkGetters) ..._addFunctionIssues(source, visitor.getterNodes),
      if (_checkSetters) ..._addFunctionIssues(source, visitor.setterNodes),
      if (_checkMethods) ..._addMethodIssues(source, visitor.methodNodes),
      if (_checkConstructors)
        ..._addConstructorIssues(source, visitor.constructorNodes),
      if (_checkIdentifiers)
        ..._addIdentifierIssues(source, visitor.variableNodes),
    ];

    return _issues;
  }

  Issue _createIssueWithMessage(
    SimpleIdentifier identifier,
    InternalResolvedUnitResult source,
    String message,
  ) =>
      createIssue(
        rule: this,
        location: nodeLocation(
          node: identifier,
          source: source,
          withCommentOrMetadata: true,
        ),
        message: message,
      );

  List<Issue> _addArgumentIssues(
    InternalResolvedUnitResult source,
    Iterable<FormalParameter> argumentsNode,
  ) {
    final issue = <Issue>[];

    for (final element in argumentsNode) {
      final message = _getNodeErrorMessage(
        element.declaredElement?.name ?? '',
        'function argument',
      );
      if (message != null) {
        issue.add(_createIssueWithMessage(
          element.identifier!,
          source,
          message,
        ));
      }
    }

    return issue;
  }

  List<Issue> _addClassIssues(
    InternalResolvedUnitResult source,
    Iterable<ClassDeclaration> classNode,
  ) {
    final issue = <Issue>[];

    for (final element in classNode) {
      final message = _getNodeErrorMessage(element.name.name, 'class');
      if (message != null) {
        issue.add(_createIssueWithMessage(element.name, source, message));
      }
    }

    return issue;
  }

  List<Issue> _addFunctionIssues(
    InternalResolvedUnitResult source,
    Iterable<FunctionDeclaration> functionNode,
  ) {
    final issue = <Issue>[];

    for (final element in functionNode) {
      final message = _getNodeErrorMessage(element.name.name, 'function');
      if (message != null) {
        issue.add(_createIssueWithMessage(element.name, source, message));
      }
    }

    return issue;
  }

  List<Issue> _addIdentifierIssues(
    InternalResolvedUnitResult source,
    Iterable<VariableDeclaration> variablesNode,
  ) {
    final issue = <Issue>[];

    for (final element in variablesNode) {
      final message = _getNodeErrorMessage(element.name.name, 'variable');
      if (message != null) {
        issue.add(_createIssueWithMessage(
          element.name,
          source,
          message,
        ));
      }
    }

    return issue;
  }

  List<Issue> _addMethodIssues(
    InternalResolvedUnitResult source,
    Iterable<MethodDeclaration> methodNode,
  ) {
    final issue = <Issue>[];

    for (final element in methodNode) {
      final message = _getNodeErrorMessage(element.name.name, 'method');
      if (message != null) {
        issue.add(_createIssueWithMessage(
          element.name,
          source,
          message,
        ));
      }
    }

    return issue;
  }

  List<Issue> _addConstructorIssues(
    InternalResolvedUnitResult source,
    Iterable<ConstructorDeclaration> constructorNode,
  ) {
    final issue = <Issue>[];

    for (final element in constructorNode) {
      final message =
          _getNodeErrorMessage(element.name?.name ?? '', 'constructor');
      if (message != null && message.isNotEmpty) {
        issue.add(_createIssueWithMessage(
          element.name!,
          source,
          message,
        ));
      }
    }

    return issue;
  }

  String? _getNodeErrorMessage(String name, String type) {
    final isShort = name.length < _minLength;
    final isLong = name.length > _maxLength;

    if (isShort) {
      return 'Too short $type name length.';
    }
    if (isLong) {
      return 'Too long $type name length.';
    }

    return null;
  }
}
