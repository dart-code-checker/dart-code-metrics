// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/dart_types_utils.dart';
import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';
import '../common_config.dart';

part 'config_parser.dart';
part 'visit_declaration.dart';
part 'visitor.dart';

class AvoidReturningWidgetsRule extends FlutterRule {
  static const String ruleId = 'avoid-returning-widgets';

  static const _warningMessage = 'Avoid returning widgets from a function.';
  static const _getterWarningMessage = 'Avoid returning widgets from a getter.';
  static const _globalFunctionWarningMessage =
      'Avoid returning widgets from a global function.';

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;
  final bool _allowNullable;

  AvoidReturningWidgetsRule([Map<String, Object> config = const {}])
      : _ignoredNames = _ConfigParser.getIgnoredNames(config),
        _ignoredAnnotations = _ConfigParser.getIgnoredAnnotations(config),
        _allowNullable = _ConfigParser.getAllowNullable(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._ignoredNamesConfig] = _ignoredNames.toList();
    json[_ConfigParser._ignoredAnnotationsConfig] =
        _ignoredAnnotations.toList();
    json[_ConfigParser._allowNullable] = _allowNullable;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor =
        _Visitor(_ignoredNames, _ignoredAnnotations, _allowNullable);

    source.unit.visitChildren(visitor);

    return [
      ...visitor.invocations.map((invocation) => createIssue(
            rule: this,
            location: nodeLocation(
              node: invocation,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _warningMessage,
          )),
      ...visitor.getters.map((getter) => createIssue(
            rule: this,
            location: nodeLocation(
              node: getter,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _getterWarningMessage,
          )),
      ...visitor.globalFunctions.map((globalFunction) => createIssue(
            rule: this,
            location: nodeLocation(
              node: globalFunction,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _globalFunctionWarningMessage,
          )),
    ];
  }
}
