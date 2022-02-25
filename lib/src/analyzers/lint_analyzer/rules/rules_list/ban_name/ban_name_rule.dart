// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/visitor.dart';

import '../../../lint_utils.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';

part 'visitor.dart';

class BanNameRule extends CommonRule {
  static const String ruleId = 'ban-name';

  BanNameRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );
}
