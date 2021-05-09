import 'dart:io';

import 'package:meta/meta.dart';

import '../github_workflow_commands.dart';
import 'reporter.dart';

/// Creates report about issues in pull request based on GitHub Actions Workflow commands.
abstract class GitHubReporter extends Reporter {
  static const String id = 'github';

  static final commands = GitHubWorkflowCommands();

  @protected
  final IOSink output;

  const GitHubReporter(this.output);
}
