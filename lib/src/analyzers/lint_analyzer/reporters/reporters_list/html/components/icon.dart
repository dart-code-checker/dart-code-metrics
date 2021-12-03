import 'package:html/dom.dart';

import '../models/icon_type.dart';

Element renderIcon(IconType type) {
  switch (type) {
    case IconType.complexity:
      return _renderComplexityIcon();
    case IconType.issue:
      return _renderIssueIcon();
  }
}

Element _renderComplexityIcon() => Element.tag('svg')
  ..attributes['xmlns'] = 'http://www.w3.org/2000/svg'
  ..attributes['viewBox'] = '0 0 32 32'
  ..append(
    Element.tag('path')
      ..attributes['d'] =
          'M16 3C8.832 3 3 8.832 3 16s5.832 13 13 13 13-5.832 13-13S23.168 3 16 3zm0 2c6.086 0 11 4.914 11 11s-4.914 11-11 11S5 22.086 5 16 9.914 5 16 5zm-1 5v2h2v-2zm0 4v8h2v-8z',
  );

Element _renderIssueIcon() => Element.tag('svg')
  ..attributes['xmlns'] = 'http://www.w3.org/2000/svg'
  ..attributes['viewBox'] = '0 0 24 24'
  ..append(
    Element.tag('path')
      ..attributes['d'] =
          'M12 1.016c-.393 0-.786.143-1.072.43l-9.483 9.482a1.517 1.517 0 000 2.144l9.483 9.485c.286.286.667.443 1.072.443s.785-.157 1.072-.443l9.485-9.485a1.517 1.517 0 000-2.144l-9.485-9.483A1.513 1.513 0 0012 1.015zm0 2.183L20.8 12 12 20.8 3.2 12 12 3.2zM11 7v6h2V7h-2zm0 8v2h2v-2h-2z',
  );
