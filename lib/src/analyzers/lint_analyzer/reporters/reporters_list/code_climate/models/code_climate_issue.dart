import 'code_climate_issue_category.dart';
import 'code_climate_issue_location.dart';
import 'code_climate_issue_severity.dart';

/// Represents a Code Climate issue.
class CodeClimateIssue {
  static const String type = 'issue';

  final String checkName;
  final String description;
  final Iterable<CodeClimateIssueCategory> categories;
  final CodeClimateIssueLocation location;
  final CodeClimateIssueSeverity severity;
  final String fingerprint;

  const CodeClimateIssue({
    required this.checkName,
    required this.description,
    required this.categories,
    required this.location,
    required this.severity,
    required this.fingerprint,
  });

  /// Converts the issue to JSON format.
  Map<String, Object> toJson() => {
        'type': type,
        'check_name': checkName,
        'description': description,
        'categories':
            categories.map((category) => category.toString()).toList(),
        'location': location.toJson(),
        'severity': severity.toString(),
        'fingerprint': fingerprint,
      };
}
