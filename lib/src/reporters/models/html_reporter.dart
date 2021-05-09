import 'dart:io';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../../analyzers/models/file_report.dart';
import 'reporter.dart';

/// HTML-doc reporter
abstract class HtmlReporter extends Reporter {
  @protected
  final String reportFolder;

  const HtmlReporter(this.reportFolder);

  @mustCallSuper
  @override
  Future<void> report(Iterable<FileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    createReportDirectory();
    await copyResources();
  }

  void createReportDirectory() {
    final reportDirectory = Directory(reportFolder);
    if (reportDirectory.existsSync()) {
      reportDirectory.deleteSync(recursive: true);
    }
    reportDirectory.createSync(recursive: true);
  }

  Future<void> copyResources() async {
    const resources = [
      'package:dart_code_metrics/src/reporters/resources/variables.css',
      'package:dart_code_metrics/src/reporters/resources/normalize.css',
      'package:dart_code_metrics/src/reporters/resources/base.css',
      'package:dart_code_metrics/src/reporters/resources/main.css',
    ];

    for (final resource in resources) {
      final resolvedUri = await Isolate.resolvePackageUri(Uri.parse(resource));
      if (resolvedUri != null) {
        final fileWithExtension = p.split(resolvedUri.toString()).last;
        File.fromUri(resolvedUri)
            .copySync(p.join(reportFolder, fileWithExtension));
      }
    }
  }
}
