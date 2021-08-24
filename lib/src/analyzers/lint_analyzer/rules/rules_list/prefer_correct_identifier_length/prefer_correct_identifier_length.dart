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
  final bool _checkClassName;
  final bool _checkIdentifiers;
  final bool _checkArguments;
  final bool _checkConstructor;
  final bool _checkMethod;
  final bool _checkGetters;
  final bool _checkSetters;

  //Мы сделали проверку длинны финкций, классов, аргументы,
  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _minLength = _ConfigParser.parseMinIdentifierLength(config) ??
            _defaultMinIdentifier,
        _maxLength = _ConfigParser.parseMaxIdentifierLength(config) ??
            _defaultMaxIdentifier,
        _checkFunctions = _ConfigParser.parseCheckFunctionName(config) ?? true,
        _checkMethod = _ConfigParser.parseCheckMethodName(config) ?? true,
        _checkClassName = _ConfigParser.parseCheckClassName(config) ?? true,
        _checkGetters = _ConfigParser.parseCheckGetters(config) ?? true,
        _checkSetters = _ConfigParser.parseCheckSetters(config) ?? true,
        _checkIdentifiers = _ConfigParser.parseCheckIdentifier(config) ?? true,
        _checkArguments = _ConfigParser.checkArgumentsName(config) ?? true,
        _checkConstructor = _ConfigParser.checkConstructorName(config) ?? true,
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct identifier length',
            brief: 'Warns when identifier name length very short.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issue = <Issue>[
      if (_checkArguments) ..._addArguments(source, visitor.argumentNode),
      if (_checkClassName) ..._addClassIssue(source, visitor.classNode),
      if (_checkFunctions) ..._addFunctionIssue(source, visitor.functionNode),
      if (_checkGetters) ..._addFunctionIssue(source, visitor.getters),
      if (_checkSetters) ..._addFunctionIssue(source, visitor.setters),
      if (_checkMethod) ..._addMethodIssue(source, visitor.methodNode),
      if (_checkConstructor)
        ..._addConstructors(source, visitor.constructorNode),
      if (_checkIdentifiers)
        ..._addIdentifierIssue(source, visitor.variablesNode),
    ];

    return _issue;
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

  List<Issue> _addArguments(
    InternalResolvedUnitResult source,
    Iterable<FormalParameter> argumentsNode,
  ) {
    final issue = <Issue>[];
    argumentsNode.map((element) {
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
    }).toList();

    return issue;
  }

  List<Issue> _addClassIssue(
    InternalResolvedUnitResult source,
    Iterable<ClassDeclaration> classNode,
  ) {
    final issue = <Issue>[];

    classNode.map((element) {
      final message = _getNodeErrorMessage(element.name.name, 'class');
      if (message != null) {
        issue.add(_createIssueWithMessage(element.name, source, message));
      }
    }).toList();

    return issue;
  }

  List<Issue> _addFunctionIssue(
    InternalResolvedUnitResult source,
    Iterable<FunctionDeclaration> functionNode,
  ) {
    final issue = <Issue>[];

    functionNode.map((element) {
      final message = _getNodeErrorMessage(element.name.name, 'function');
      if (message != null) {
        issue.add(_createIssueWithMessage(element.name, source, message));
      }
    }).toList();

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

  List<Issue> _addIdentifierIssue(
    InternalResolvedUnitResult source,
    Iterable<VariableDeclaration> variablesNode,
  ) {
    final issue = <Issue>[];

    variablesNode.map((element) {
      final message = _getNodeErrorMessage(element.name.name, 'variable');
      if (message != null) {
        issue.add(_createIssueWithMessage(
          element.name,
          source,
          message,
        ));
      }
    }).toList();

    return issue;
  }

  List<Issue> _addMethodIssue(
    InternalResolvedUnitResult source,
    Iterable<MethodDeclaration> methodNode,
  ) {
    final issue = <Issue>[];

    methodNode.map((element) {
      final message = _getNodeErrorMessage(element.name.name, 'method');
      if (message != null) {
        issue.add(_createIssueWithMessage(
          element.name,
          source,
          message,
        ));
      }
    }).toList();

    return issue;
  }

  List<Issue> _addConstructors(
    InternalResolvedUnitResult source,
    Iterable<ConstructorDeclaration> constructorNode,
  ) {
    final issue = <Issue>[];

    constructorNode.map((element) {
      final message =
          _getNodeErrorMessage(element.name?.name ?? '', 'constructor');
      if (message != null && message.isNotEmpty) {
        issue.add(_createIssueWithMessage(
          element.name!,
          source,
          message,
        ));
      }
    }).toList();

    return issue;
  }
}
