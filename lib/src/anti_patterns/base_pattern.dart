import 'package:meta/meta.dart';

import '../models/config.dart';
import '../models/design_issue.dart';
import '../models/source.dart';

abstract class BasePattern {
  final String id;
  final Uri documentation;

  const BasePattern({
    @required this.id,
    @required this.documentation,
  });

  Iterable<DesignIssue> check(Source source, Config config);
}
