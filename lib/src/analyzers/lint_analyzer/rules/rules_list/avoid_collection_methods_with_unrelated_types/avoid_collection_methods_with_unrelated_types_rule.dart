// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/visitor.dart';

import '../../../lint_utils.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';

part 'visitor.dart';

class AvoidCollectionMethodsWithUnrelatedTypesRule extends CommonRule {
  static const String ruleId = 'avoid-collection-methods-with-unrelated-types';

  static const _warning = 'Avoid collection methods with unrelated types.';

  AvoidCollectionMethodsWithUnrelatedTypesRule([Map<String, Object> config = const {}])
      : super(
    id: ruleId,
    severity: readSeverity(config, Severity.warning),
    excludes: readExcludes(config),
  );

  // TODO
}
