import 'package:html/dom.dart';

Element renderSummaryMetric(String name, String value,
        {bool withViolation = false}) =>
    Element.tag('div')
      ..classes.addAll(
          ['metrics-total', if (withViolation) 'metrics-total--violations'])
      ..append(Element.tag('span')
        ..classes.add('metrics-total__label')
        ..text = '$name : ')
      ..append(Element.tag('span')
        ..classes.add('metrics-total__count')
        ..text = value);
