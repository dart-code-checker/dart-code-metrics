class RenderObject {}

class RenderBox extends RenderObject {}

class Widget {}

class BuildContext {}

abstract class RenderObjectWidget extends Widget {
  const RenderObjectWidget();

  @protected
  RenderObject createRenderObject(BuildContext context);

  @protected
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {}
}

abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {}

class _RenderMenuItem extends RenderBox {
  bool value;

  _RenderMenuItem(this.value);
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({required this.value});

  final bool value;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(value);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMenuItem renderObject) {
    renderObject.value = value;
  }
}

class _ColorFilterRenderObject extends RenderBox {
  int value;

  _ColorFilterRenderObject(this.value);
}

class ColorFiltered extends SingleChildRenderObjectWidget {
  const ColorFiltered({required this.value});

  final int value;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ColorFilterRenderObject(colorFilter);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _ColorFilterRenderObject).value = value;
  }
}

enum TextDirection { rtl, ltr }

class _RenderChildOverflowBox extends RenderBox {
  TextDirection textDirection;

  _RenderChildOverflowBox({required this.textDirection});
}

class _ChildOverflowBox extends SingleChildRenderObjectWidget {
  const _ChildOverflowBox();

  @override
  _RenderChildOverflowBox createRenderObject(BuildContext context) {
    return _RenderChildOverflowBox(
      textDirection: TextDirection.ltr,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderChildOverflowBox renderObject,
  ) {
    renderObject.textDirection = TextDirection.ltr;
  }
}

class _RenderDecoration extends RenderBox {
  TextDirection textDirection;
  bool isFocused;
  bool expands;

  _RenderDecoration({
    required this.textDirection,
    required this.isFocused,
    required this.expands,
  });
}

class _Decorator extends RenderObjectWidget {
  const _Decorator({
    required this.textDirection,
    required this.isFocused,
    required this.expands,
  });

  final TextDirection textDirection;
  final bool isFocused;
  final bool expands;

  @override
  _RenderDecoration createRenderObject(BuildContext context) {
    return _RenderDecoration(
      textDirection: textDirection,
      isFocused: isFocused,
      expands: expands,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderDecoration renderObject,
  ) {
    renderObject
      ..expands = expands
      ..isFocused = isFocused
      ..textDirection = textDirection;
  }
}

class _RenderCupertinoTextSelectionToolbarShape extends RenderBox {
  int anchor;
  bool isAbove;
  Widget child;

  _RenderCupertinoTextSelectionToolbarShape(
    this.anchor,
    this.isAbove,
    this.child,
  );
}

class _CupertinoTextSelectionToolbarShape
    extends SingleChildRenderObjectWidget {
  const _CupertinoTextSelectionToolbarShape({
    required this.anchor,
    required this.isAbove,
    this.child,
  });

  final int anchor;

  final bool isAbove;

  final Widget child;

  @override
  _RenderCupertinoTextSelectionToolbarShape createRenderObject(
    BuildContext context,
  ) =>
      _RenderCupertinoTextSelectionToolbarShape(
        anchor,
        isAbove,
        null,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderCupertinoTextSelectionToolbarShape renderObject,
  ) {
    renderObject
      ..anchor = _anchor
      ..isAbove = _isAbove;
  }
}

class RenderIntrinsicHeight extends RenderBox {}

class IntrinsicHeight extends SingleChildRenderObjectWidget {
  const IntrinsicHeight();

  @override
  RenderIntrinsicHeight createRenderObject(BuildContext context) =>
      RenderIntrinsicHeight();
}

class RenderObjectElement {}

class ListWheelElement extends RenderObjectElement {}

class RenderListWheelViewport extends RenderBox {
  ListWheelElement childManager;
  double overAndUnderCenterOpacity;
  double itemExtent;

  RenderListWheelViewport({
    required this.childManager,
    required this.overAndUnderCenterOpacity,
    required this.itemExtent,
  });
}

class ListWheelViewport extends RenderObjectWidget {
  final double overAndUnderCenterOpacity;

  final double itemExtent;

  const ListWheelViewport(this.itemExtent, this.overAndUnderCenterOpacity);

  @override
  ListWheelElement createElement() => ListWheelElement();

  @override
  RenderListWheelViewport createRenderObject(BuildContext context) {
    final ListWheelElement childManager = context as ListWheelElement;
    return RenderListWheelViewport(
      childManager: childManager,
      overAndUnderCenterOpacity: overAndUnderCenterOpacity,
      itemExtent: itemExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderListWheelViewport renderObject,
  ) {
    renderObject
      ..overAndUnderCenterOpacity = overAndUnderCenterOpacity
      ..itemExtent = itemExtent;
  }
}
