// ignore_for_file: public_member_api_docs, comment_references
import '../models/file_record.dart';

/// Abstract reporter interface. Use [MetricsAnalysisRunner] to get analysis info to report
abstract class Reporter {
  Future<Iterable<String>> report(Iterable<FileRecord> records);
}
