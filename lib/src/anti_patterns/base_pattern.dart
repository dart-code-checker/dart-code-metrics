import 'package:code_checker/analysis.dart';
import 'package:meta/meta.dart';

import '../config/config.dart';
import '../models/scoped_function_declaration.dart';

abstract class BasePattern {
  final String id;
  final Uri documentation;

  const BasePattern({
    @required this.id,
    @required this.documentation,
  });

  Iterable<Issue> check(
    ProcessedFile source,
    Iterable<ScopedFunctionDeclaration> functions,
    Config config,
  );
}
