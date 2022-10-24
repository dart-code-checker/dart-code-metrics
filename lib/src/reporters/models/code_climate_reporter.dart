import 'dart:io';

import 'package:meta/meta.dart';

import 'file_report.dart';
import 'reporter.dart';

// Code Climate Engine Specification https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md

/// Creates reports in Code Climate format widely understood by various CI and analysis tools
abstract class CodeClimateReporter<T extends FileReport, P>
    extends Reporter<T, P> {
  static const String id = 'codeclimate';
  static const String alternativeId = 'gitlab';

  @protected
  final IOSink output;

  /// If true will report in GitLab Code Quality format.
  @protected
  final bool gitlabCompatible;

  const CodeClimateReporter(
    this.output, {
    this.gitlabCompatible = false,
  });
}
