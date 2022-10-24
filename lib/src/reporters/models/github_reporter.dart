import 'dart:io';

import 'package:meta/meta.dart';

import '../github_workflow_commands.dart';
import 'file_report.dart';
import 'reporter.dart';

/// Creates report about issues in pull request based on GitHub Actions Workflow commands.
abstract class GitHubReporter<T extends FileReport, P> extends Reporter<T, P> {
  static const String id = 'github';

  static final commands = GitHubWorkflowCommands();

  @protected
  final IOSink output;

  const GitHubReporter(this.output);
}
