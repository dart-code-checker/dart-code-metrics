// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidLiteralStringInTextWidgetRule extends FlutterRule {
  static const String ruleId = 'avoid-literal-string-in-text-widget';

  static const _warningMessage = 'Literal string "_raw_" is not allowed, use R.string instead';

  AvoidLiteralStringInTextWidgetRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.error),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.literalStringInTextWidget
        .map((node) => createIssue(
              rule: this,
              location: nodeLocation(
                node: node,
                source: source,
              ),
              message: _warningMessage.replaceFirst('_raw_', node.stringValue ?? ''),
            ))
        .toList(growable: false);
  }
}
