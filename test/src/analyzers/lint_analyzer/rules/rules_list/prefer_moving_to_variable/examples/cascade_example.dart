void main() {
  final cyclomaticValues = Element.tag('td')
    ..classes.add('metrics-source-code__complexity');

  final tooltip = Element.tag('div')
    ..classes.add('metrics-source-code__tooltip')
    ..append(Element.tag('div')
      ..classes.add('metrics-source-code__tooltip-title')
      ..text = title)
    ..append(Element.tag('p')
      ..classes.add('metrics-source-code__tooltip-section')
      ..text = issue.message);

  final html = Element.tag('html')
    ..attributes['lang'] = 'en'
    ..append(Element.tag('head')
      ..append(Element.tag('title')..text = 'Metrics report')
      ..append(Element.tag('meta')..attributes['charset'] = 'utf-8')
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = 'variables.css')
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = 'normalize.css')
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = 'base.css')
      ..append(Element.tag('link')
        ..attributes['rel'] = 'stylesheet'
        ..attributes['href'] = 'main.css'))
    ..append(Element.tag('body')
      ..append(Element.tag('h1')
        ..classes.add('metric-header')
        ..text = 'All files')
      ..append(_generateTable('Directory', tableRecords)));
}

class Element {
  final String localName;

  final nodes = <Element>[];

  Set<String> get classes => <String>{};

  String text;

  LinkedHashMap<Object, String> attributes = LinkedHashMap();

  Element.tag(this.localName);

  void append(Element node) => nodes.add(node);
}
