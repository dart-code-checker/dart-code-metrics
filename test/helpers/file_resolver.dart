import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/analyzers/models/internal_resolved_unit_result.dart';
import 'package:path/path.dart';

class FileResolver {
  static Future<InternalResolvedUnitResult> resolve(
    String filePath,
  ) async {
    final path = normalize(File(filePath).absolute.path);
    final sourceUrl = Uri.parse(path);
    final parseResult = await resolveFile2(path: path) as ResolvedUnitResult;

    return InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content!,
      parseResult.unit!,
      parseResult.lineInfo,
    );
  }
}
