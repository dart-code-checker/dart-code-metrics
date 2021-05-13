import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/analyzers/models/internal_resolved_unit_result.dart';
import 'package:path/path.dart';

Future<void> ensureHaveValidLineEndings(String path) async {
  final hasCarriageReturnChar =
      (await File(path).readAsBytes()).buffer.asUint8List().contains(0x0d);

  if (hasCarriageReturnChar) {
    throw Exception('''

File: "$path"

============================================================================
All rule test input dart code files must use only LF line ending characters.
The file contains Windows line ending character(s) so rule tests may fail.
============================================================================
''');
  }
}

class FileResolver {
  static Future<InternalResolvedUnitResult> resolve(
    String filePath,
  ) async {
    final path = normalize(File(filePath).absolute.path);
    final sourceUrl = Uri.parse(path);

    await ensureHaveValidLineEndings(path);

    // ignore: deprecated_member_use
    final parseResult = await resolveFile(path: path) as ResolvedUnitResult;

    return InternalResolvedUnitResult(
      sourceUrl,
      parseResult.content!,
      parseResult.unit!,
      parseResult.lineInfo,
    );
  }
}
