// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../base_visitors/source_code_visitor.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferExtractingCallbacksRule extends FlutterRule {
  static const String ruleId = 'prefer-extracting-callbacks';

  static const _warningMessage =
      'Prefer extracting the callback to a separate widget method.';

  final Iterable<String> _ignoredArguments;
  final int? _allowedLineCount;

  PreferExtractingCallbacksRule([Map<String, Object> config = const {}])
      : _ignoredArguments = _ConfigParser.parseIgnoredArguments(config),
        _allowedLineCount = _ConfigParser.parseAllowedLineCount(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._allowedLineCountConfig] = _allowedLineCount;
    json[_ConfigParser._ignoredArgumentsConfig] = _ignoredArguments;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor =
        _Visitor(source.lineInfo, _ignoredArguments, _allowedLineCount);

    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map(
          (expression) => createIssue(
            rule: this,
            location: nodeLocation(
              node: expression,
              source: source,
            ),
            message: _warningMessage,
          ),
        )
        .toList(growable: false);
  }
}
