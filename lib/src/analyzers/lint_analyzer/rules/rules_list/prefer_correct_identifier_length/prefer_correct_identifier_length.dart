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

  final int? _minLength;
  final int? _maxLength;

  final bool? _isCheckFunction;
  final bool? _isCheckClass;
  final bool? _isCheckIdentifier;

  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _minLength = _ConfigParser.parseMinIdentifierLength(config),
        _maxLength = _ConfigParser.parseMaxIdentifierLength(config),
        _isCheckFunction = _ConfigParser.parseCheckFunctionName(config),
        _isCheckClass = _ConfigParser.parseCheckClassName(config),
        _isCheckIdentifier = _ConfigParser.parseCheckIdentifier(config),
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

    final _issue = <Issue>[];

    if (_isCheckClass ?? true) {
      visitor.classNode.map((element) {
        final message = _getNodeErrorMessage(element.name.name, 'class');
        if (message != null) {
          _issue.add(_createIssueWithMessage(element.name, source, message));
        }
      }).toList();
    }

    if (_isCheckFunction ?? true) {
      visitor.functionNode.map((element) {
        final message = _getNodeErrorMessage(element.name.name, 'function');
        if (message != null) {
          _issue.add(_createIssueWithMessage(element.name, source, message));
        }
      }).toList();
    }

    if (_isCheckIdentifier ?? true) {
      visitor.variablesNode.map((element) {
        final message = _getNodeErrorMessage(element.name.name, 'variable');
        if (message != null) {
          _issue.add(_createIssueWithMessage(element.name, source, message));
        }
      }).toList();
    }

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

  String? _getNodeErrorMessage(String name, String type) {
    final isShort = name.length < (_minLength ?? _defaultMinIdentifier);
    final isLong = name.length > (_maxLength ?? _defaultMaxIdentifier);

    if (isShort) {
      return 'Too short $type name length.';
    }
    if (isLong) {
      return 'Too long $type name length.';
    }

    return null;
  }
}
