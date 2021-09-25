import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_l10n_file_report.dart';

@immutable
class UnusedL10nJsonReporter extends JsonReporter<UnusedL10nFileReport> {
  const UnusedL10nJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(Iterable<UnusedL10nFileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    final nowTime = DateTime.now();
    final reportTime = DateTime(
      nowTime.year,
      nowTime.month,
      nowTime.day,
      nowTime.hour,
      nowTime.minute,
      nowTime.second,
    );

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': reportTime.toString(),
    });

    output.write(encodedReport);
  }
}
