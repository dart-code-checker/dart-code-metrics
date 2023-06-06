import '../../reporters/models/checkstyle_reporter.dart';
import '../../reporters/models/code_climate_reporter.dart';
import '../../reporters/models/console_reporter.dart';
import '../../reporters/models/github_reporter.dart';
import '../../reporters/models/html_reporter.dart';
import '../../reporters/models/json_reporter.dart';

/// Represents all flag names used by the CLI.
class FlagNames {
  static const exclude = 'exclude';
  static const noCongratulate = 'no-congratulate';
  static const reporter = 'reporter';
  static const rootFolder = 'root-folder';
  static const sdkPath = 'sdk-path';
  static const isMonorepo = 'monorepo';
  static const version = 'version';
  static const verbose = 'verbose';
  static const printConfig = 'print-config';
  static const disableMessage = 'disable-sunset-warning';

  static const consoleReporter = ConsoleReporter.id;
  static const consoleVerboseReporter = ConsoleReporter.verboseId;
  static const codeClimateReporter = CodeClimateReporter.id;
  static const checkstyleReporter = CheckstyleReporter.id;
  static const htmlReporter = HtmlReporter.id;
  static const jsonReporter = JsonReporter.id;
  static const githubReporter = GitHubReporter.id;
  static const gitlabCodeClimateReporter = CodeClimateReporter.alternativeId;

  static const reportFolder = 'output-directory';
  static const jsonReportPath = 'json-path';
  static const setExitOnViolationLevel = 'set-exit-on-violation-level';
  static const fatalStyle = 'fatal-style';
  static const fatalPerformance = 'fatal-performance';
  static const fatalWarnings = 'fatal-warnings';

  static const l10nClassPattern = 'class-pattern';

  static const fatalOnUnused = 'fatal-unused';
  static const fatalOnFound = 'fatal-found';
  static const deleteFiles = 'delete-files';
}
