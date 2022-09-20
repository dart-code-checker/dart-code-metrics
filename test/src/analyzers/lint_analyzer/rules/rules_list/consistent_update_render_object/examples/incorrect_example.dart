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
  // LINT
  void updateRenderObject(BuildContext context, _RenderMenuItem renderObject) {}
}

class _ColorFilterRenderObject extends RenderBox {
  int value;

  _ColorFilterRenderObject(this.value);
}

// LINT
class ColorFiltered extends SingleChildRenderObjectWidget {
  const ColorFiltered({required this.value});

  final int value;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ColorFilterRenderObject(colorFilter);
}

enum TextDirection { rtl, ltr }

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
  // LINT
  void updateRenderObject(
    BuildContext context,
    _RenderDecoration renderObject,
  ) {
    renderObject
      ..expands = expands
      ..textDirection = textDirection;
  }
}
