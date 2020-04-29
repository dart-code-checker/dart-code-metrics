import 'package:analyzer/dart/analysis/results.dart';

bool isSupported(AnalysisResult result) =>
    result.path != null &&
    result.path.endsWith('.dart') &&
    !result.path.endsWith('.g.dart');
