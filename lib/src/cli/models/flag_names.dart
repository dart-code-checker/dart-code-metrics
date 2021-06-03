import '../../reporters/models/code_climate_reporter.dart';
import '../../reporters/models/console_reporter.dart';
import '../../reporters/models/github_reporter.dart';
import '../../reporters/models/html_reporter.dart';
import '../../reporters/models/json_reporter.dart';

class FlagNames {
  static const reporter = 'reporter';
  static const exclude = 'exclude';
  static const rootFolder = 'root-folder';

  static const consoleReporter = ConsoleReporter.id;
  static const consoleVerboseReporter = ConsoleReporter.verboseId;
  static const codeClimateReporter = CodeClimateReporter.id;
  static const htmlReporter = HtmlReporter.id;
  static const jsonReporter = JsonReporter.id;
  static const githubReporter = GitHubReporter.id;
  static const gitlabCodeClimateReporter = CodeClimateReporter.alternativeId;

  static const reportFolder = 'output-directory';
  static const setExitOnViolationLevel = 'set-exit-on-violation-level';
}
