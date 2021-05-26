import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/analyzers/models/internal_resolved_unit_result.dart';
import 'package:path/path.dart';

class FileResolver {
  static Future<InternalResolvedUnitResult> resolve(
    String filePath,
  ) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw StateError('Unable to find a file for the given path: $filePath');
    }

    final path = normalize(file.absolute.path);
    final sourceUrl = Uri.parse(path);

    final parseResult = await resolveFile2(path: path);
    if (parseResult is! ResolvedUnitResult) {
      throw ArgumentError("$path can't resolve");
    }

    return InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content!,
      parseResult.unit!,
      parseResult.lineInfo,
    );
  }
}
