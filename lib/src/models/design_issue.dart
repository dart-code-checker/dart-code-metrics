import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

@immutable
class DesignIssue {
  final String patternId;
  final Uri patternDocumentation;
  final SourceSpanBase sourceSpan;
  final String message;
  final String recommendation;

  const DesignIssue({
    @required this.patternId,
    @required this.patternDocumentation,
    @required this.sourceSpan,
    @required this.message,
    this.recommendation,
  });
}
