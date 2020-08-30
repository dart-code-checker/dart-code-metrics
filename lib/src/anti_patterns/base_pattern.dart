import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../models/config.dart';
import '../models/design_issue.dart';

abstract class BasePattern {
  final String id;
  final Uri documentation;

  const BasePattern({
    @required this.id,
    @required this.documentation,
  });

  Iterable<DesignIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent, Config config);
}
