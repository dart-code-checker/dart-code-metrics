# Changelog

## 4.0.0

* Add static code diagnostics `always-remove-listener`, `avoid-wrapping-in-padding`, `avoid-unnecessary-setstate` and `prefer-extracting-callbacks`.
* Improve static code diagnostic `avoid-returning-widgets`.
* Remove deprecated `Lines of Executable Code` metric, use `Source lines of Code` instead.
* Changed the supported `analyzer` version to `^1.7.0`.
* Introduce `analyze` and `check-unused-files` commands.
* Improves plugin stability.

## 4.0.0-dev.5

* Add static code diagnostic `prefer-extracting-callbacks`.

## 4.0.0-dev.4

* Fix check unused files for files that are listed in the analyzer exclude section

## 4.0.0-dev.3

* Fix plugin integration null reference.

## 4.0.0-dev.2

* Switch on absolute path in plugin mode for compatibility with LSP mode.

## 4.0.0-dev.1

* Add static code diagnostics `always-remove-listener`, `avoid-wrapping-in-padding` and `avoid-unnecessary-setstate`.
* Improve static code diagnostic `avoid-returning-widgets`.
* Remove deprecated `Lines of Executable Code` metric, use `Source lines of Code` instead.
* Changed the supported `analyzer` version to `^1.7.0`.
* Introduce `analyze` and `check-unused-files` commands.

## 3.3.6

* Fix analyzer plugin quick fix action performs on wrong file for file with `part of`.

## 3.3.5

* Improve static code diagnostic `avoid-unused-parameters`.

## 3.3.4

* Fix GitHub reporter

## 3.3.3

* Improve static code diagnostic `member-ordering-extended`.

## 3.3.2

* Temporary lock `meta` package upper bound range to `1.3.x` version.

## 3.3.1

* Temporary lock `analyzer` package upper bound range to `1.5.x` version.

## 3.3.0

* Improve static code diagnostics `no-equal-arguments`, `no-magic-numbers`, `member-ordering-extended`.

## 3.2.3

* Fix anti-patterns, metrics and rules documentation url.

## 3.2.2

* Update deprecation version for `Lines of Executable Code` `ConsoleReporter`, `MetricsAnalysisRunner`, `MetricsAnalyzer`, `MetricsRecordsBuilder` and `MetricsRecordsStore`.

## 3.2.1

* Remove unnecessary scan by `Lines of Executable Code`.

## 3.2.0

* Deprecate `ConsoleReporter`, `MetricsAnalysisRunner`, `MetricsAnalyzer`, `MetricsRecordsBuilder` and `MetricsRecordsStore`.
* Improve static code diagnostics `avoid-returning-widgets`.

## 3.2.0-dev.1

* Add static code diagnostics `avoid-non-null-assertion`,  `avoid-late-keyword`.
* Improve static code diagnostics `no-equal-arguments`, `no-magic-number`.
* Migrate all rule tests to `resolveFile`.

## 3.1.0

* Add excludes for a separate rule.
* Add static code diagnostic `avoid-returning-widgets`.
* Improve static code diagnostic `no-boolean-literal-compare`.
* Add `Source lines of Code` metric.

## 3.0.0

* Rename all rules config items from snake_case to kebab-case with backward compatibility.
* Rework `JSON` report format.
* Stable null safety release.

## 3.0.0-nullsafety.2

* Changed the supported `analyzer` version to `^1.4.0`.
* Changed the supported `analyzer_plugin` version to `^0.6.0`.

## 3.0.0-nullsafety.0

* Set min `SDK` version to `2.12.0`.
* Changed the supported `analyzer` version to `^1.3.0`.
* Changed the supported `analyzer_plugin` version to `^0.5.0`.
* Remove obsolete rule `prefer-trailing-comma-for-collection`, `potential-null-dereference`.
* Rename cli arguments:
  * `ignore-files` to `exclude`
  * `maximum-nesting` to `maximum-nesting-level`
  * `number-of-arguments` to `number-of-parameters`
* Update README.
* Add static code diagnostic `member-ordering-extended`.

## 2.5.0

* Backport static code diagnostics `member-ordering-extended`, `avoid-returning-widgets`.
* Backport fix excludes on Windows OS.

## 2.4.1

* Allow configuring output directory for `HTML` reporter.
* Fixed bug with missing CSS files in `HTML` report directory.

## 2.4.0

* Add static code diagnostic `avoid-unused-parameters`.

## 2.3.2

* Add Gitlab Code Quality support in `Code Climate` report.

## 2.3.1

* Changed the support version range of the `analyzer` to `>=0.39.3 <0.42.0`.

## 2.3.0

* Add `Maximum Nesting` metric.

## 2.2.0

* Add static code diagnostic `prefer-trailing-comma`.

## 2.1.1

* Explained usage with Flutter in README.

## 2.1.0

* Add static code diagnostics `no-equal-arguments`, `potential-null-dereference`.
* Improve `HTML` report.

## 2.0.0

* Removed deprecated `AnalysisOptions.from` use `AnalysisOptions.fromMap` instead.
* Removed deprecated `Config.linesOfCodeWarningLevel` use `Config.linesOfExecutableCodeWarningLevel` instead.
* Removed deprecated `MetricsAnalysisRecorder.startRecordFile` and `MetricsAnalysisRecorder.endRecordFile` use `MetricsRecordsStore.recordFile` instead.
* **Breaking Change:** `MetricsAnalyzer.runAnalysis` now accept array with folder paths.
* Add static code anti-patterns `long-parameter-list`.
* Set min `SDK` version to `>=2.8.0`.

## 1.10.0

* Add static code diagnostics `no-equal-then-else`.
* Add static code anti-patterns `long-method`.

## 1.9.0

* Add static code diagnostics `provide-correct-intl-args`, `component-annotation-arguments-ordering`.

## 1.8.1

* Fix static code diagnostics `member-ordering` and `prefer-conditional-expression`.

## 1.8.0

* Add static code diagnostics `prefer-conditional-expressions`, `prefer-on-push-cd-strategy`, `member-ordering`, `no-object-declaration`.
* Improve static code diagnostic `no-magic-number`.
* Set min `analyzer` to `0.39.3`.

## 1.7.1

* Support `analyzer_plugin` version `0.3.0`.

## 1.7.0

* Add experimental static code diagnostics `binary-expression-operand-order`, `prefer-intl-name`.
* Add `Number of Methods` metric.
* Drop dependency on `resource`.
* Improve `HTML` report.
* Set min `SDK` version to `>=2.6.0`.

## 1.6.0

* Add experimental static code diagnostics `prefer-trailing-comma-for-collection`, `no-magic-number`.
* Support `Number of Arguments` metric in analyzer plugin.
* Support excluding files from metrics calculation.

## 1.5.1

* Improve code diagnostics `double-literal-format`, `no-boolean-literal-compare`.
* Add experimental static code diagnostics `newline-before-return`, `no-empty-block`, `avoid-preserve-whitespace-false`.
* Support `Cyclomatic Complexity` metric in analyzer plugin

## 1.5.0

* Add experimental static code diagnostics `double-literal-format`, `no-boolean-literal-compare`.

## 1.4.0

* Drop dependency on `built_collection`.
* Add `set-exit-on-violation-level` cli argument.

## 1.3.1

* Fix get arguments count.

## 1.3.0

* Add `Number of Arguments` metrics.

## 1.2.1

* Validate root-folder argument.
* Fix paths to analyze fail to validate with non-default root-folder.
* Fix paths weren't validated to be inside root-folder.
* Support factory constructors analysis.

## 1.2.0

* Allow analyzing multiple directories.

## 1.1.5

* Tweak console reporter.

## 1.1.4

* Add some dartdocs.
* Update README.
* Add library usage example.

## 1.1.3

* Fix validate input arguments.

## 1.1.2

* Improve `Code Climate` report.

## 1.1.1

* Added support extension methods.

## 1.1.0

* Added support for `Code Climate`.

## 1.0.0

* Initial release.
