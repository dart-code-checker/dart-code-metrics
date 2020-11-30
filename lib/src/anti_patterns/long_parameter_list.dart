import 'package:meta/meta.dart';

import '../config/config.dart';
import '../models/design_issue.dart';
import '../models/scoped_function_declaration.dart';
import '../models/source.dart';
import '../utils/metrics_analyzer_utils.dart';
import 'base_pattern.dart';
import 'pattern_utils.dart';

class LongParameterList extends BasePattern {
  static const String patternId = 'long-parameter-list';
  static const _documentationUrl = 'https://git.io/JUGrU';

  LongParameterList()
      : super(id: patternId, documentation: Uri.parse(_documentationUrl));

  @override
  Iterable<DesignIssue> check(
    Source source,
    Iterable<ScopedFunctionDeclaration> functions,
    Config config,
  ) =>
      functions
          .where((function) =>
              getArgumentsCount(function) >
              config.numberOfArgumentsWarningLevel)
          .map((function) => createIssue(
                this,
                _compileMessage(args: getArgumentsCount(function)),
                _compileRecommendationMessage(
                    maximumArguments: config.numberOfArgumentsWarningLevel),
                source,
                function.declaration,
              ))
          .toList();

  String _compileMessage({@required int args}) =>
      'Long Parameter List. This method require $args arguments.';

  String _compileRecommendationMessage({@required int maximumArguments}) =>
      "Based on configuration of this package, we don't recommend writing a method with argument count more than $maximumArguments.";
}
