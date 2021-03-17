# Changelog

## Unreleased

* Set min SDK version to `2.9.0`
* Changed the support version range of the analyzer to `>=0.40.0 <0.42.0`
* Changed the support version range of the analyzer_plugin to `>=0.3.0 <0.5.0`

## 2.4.1

* Allow configuring output directory for HTML reporter
* Fixed bug with missing CSS files in HTML report directory

## 2.4.0

* Add static code diagnostic avoid-unused-parameters

## 2.3.2

* Add Gitlab Code Quality support in Code Climate report

## 2.3.1

* Changed the support version range of the analyzer to `>=0.39.3 <0.42.0`

## 2.3.0

* Add Maximum Nesting metric

## 2.2.0

* Add static code diagnostic prefer-trailing-comma

## 2.1.1

* Explained usage with Flutter in README.

## 2.1.0

* Add static code diagnostics no-equal-arguments, potential-null-dereference
* Improve HTML report

## 2.0.0

* Removed deprecated `AnalysisOptions.from` use `AnalysisOptions.fromMap` instead
* Removed deprecated `Config.linesOfCodeWarningLevel` use `Config.linesOfExecutableCodeWarningLevel` instead
* Removed deprecated `MetricsAnalysisRecorder.startRecordFile` and `MetricsAnalysisRecorder.endRecordFile` use `MetricsRecordsStore.recordFile` instead
* **Breaking Change:** `MetricsAnalyzer.runAnalysis` now accept array with folder paths
* Add static code anti-patterns long-parameter-list
* Set min SDK version to >=2.8.0.

## 1.10.0

* Add static code diagnostics no-equal-then-else
* Add static code anti-patterns long-method

## 1.9.0

* Add static code diagnostics provide-correct-intl-args, component-annotation-arguments-ordering

## 1.8.1

* Fix static code diagnostics member-ordering and prefer-conditional-expression

## 1.8.0

* Add static code diagnostics prefer-conditional-expressions, prefer-on-push-cd-strategy, member-ordering, no-object-declaration
* Improve static code diagnostic no-magic-number
* Set min analyzer 0.39.3

## 1.7.1

* Support analyzer_plugin 0.3.0

## 1.7.0

* Add experimental static code diagnostics binary-expression-operand-order, prefer-intl-name
* Add Number of Methods metric
* Drop dependency on resource
* Improve html report
* Set min SDK version to >=2.6.0.

## 1.6.0

* Add experimental static code diagnostics prefer-trailing-comma-for-collection, no-magic-number
* Support number of arguments metric in analyzer plugin
* Support excluding files from metrics calculation

## 1.5.1

* Improve code diagnostics double-literal-format, no-boolean-literal-compare
* Add experimental static code diagnostics newline-before-return, no-empty-block, avoid-preserve-whitespace-false
* Support cyclomatic complexity metric in analyzer plugin

## 1.5.0

* Add experimental static code diagnostics double-literal-format, no-boolean-literal-compare

## 1.4.0

* Drop dependency on built_collection
* Add set-exit-on-violation-level cli argument

## 1.3.1

* Fix get arguments count

## 1.3.0

* Add Number of Arguments metrics

## 1.2.1

* Validate root-folder argument
* Fix paths to analyze fail to validate with non-default root-folder
* Fix paths weren't validated to be inside root-folder
* Support factory constructors analysis

## 1.2.0

* Allow analyzing multiple directories

## 1.1.5

* Tweak console reporter

## 1.1.4

* Add some dartdocs
* Update readme
* Add library usage example

## 1.1.3

* Fix validate input arguments

## 1.1.2

* Improve CodeClimate report

## 1.1.1

* Added support extension methods

## 1.1.0

* Added support for CodeClimate

## 1.0.0

* Initial release
