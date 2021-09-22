import 'package:meta/meta.dart';

import 'lint_file_report.dart';

@immutable
class LintReport {
  final Iterable<LintFileReport> files;

  const LintReport(this.files);
}
