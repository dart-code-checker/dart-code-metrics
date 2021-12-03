import 'package:html/dom.dart';

import '../../../../../../utils/string_extensions.dart';
import '../../../../models/issue.dart';
import '../../../../models/severity.dart';

Element renderIssueDetailsTooltip(Issue issue) {
  final title = issue.severity != Severity.none
      ? '${issue.severity.toString().capitalize()}: ${issue.ruleId}'
      : issue.ruleId;

  final tooltip = Element.tag('div')
    ..classes.add('metrics-source-code__tooltip')
    ..append(Element.tag('div')
      ..classes.add('metrics-source-code__tooltip-title')
      ..text = title)
    ..append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-section')
      ..text = issue.message);

  if (issue.verboseMessage != null) {
    tooltip.append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-section')
      ..text = issue.verboseMessage);
  }

  tooltip.append(Element.tag('p')
    ..classes.add('metrics-source-code__tooltip-section')
    ..append(Element.tag('a')
      ..classes.add('metrics-source-code__tooltip-link')
      ..attributes['href'] = issue.documentation.toString()
      ..attributes['target'] = '_blank'
      ..attributes['rel'] = 'noopener noreferrer'
      ..attributes['title'] = 'Open documentation'
      ..text = 'Open documentation'));

  return tooltip;
}
