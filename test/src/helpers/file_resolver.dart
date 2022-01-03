import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:path/path.dart';

class FileResolver {
  static Future<InternalResolvedUnitResult> resolve(String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw ArgumentError(
        'Unable to find a file for the given path: $filePath',
      );
    }

    final path = normalize(file.absolute.path);

    final parseResult = await resolveFile2(path: path);
    if (parseResult is! ResolvedUnitResult) {
      throw ArgumentError(
        'Unable to correctly resolve file for given path: $path',
      );
    }

    return InternalResolvedUnitResult(
      path,
      parseResult.content,
      parseResult.unit,
      parseResult.lineInfo,
    );
  }
}
