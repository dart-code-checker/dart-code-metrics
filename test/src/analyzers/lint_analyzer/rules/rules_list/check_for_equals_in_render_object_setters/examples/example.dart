class RenderObject {}

class RenderBox extends RenderObject {}

class SomeRenderBox extends RenderBox {
  int _page;
  int get page => _page;
  set page(int value) {
    if (value == _page) {
      return;
    }
    _page = value;
    markNeedsLayout();
  }

  double get overflowSpacing => _overflowSpacing;
  double _overflowSpacing;
  set overflowSpacing(double value) {
    assert(value != null);
    if (_overflowSpacing == value) return;

    _overflowSpacing = value;
    markNeedsLayout();
  }

  double _dividerWidth;
  double get dividerWidth => _dividerWidth;
  // LINT
  set dividerWidth(double value) {
    _dividerWidth = value;
    markNeedsLayout();
  }

  double _dividerHeight;
  double get dividerHeight => _dividerHeight;
  // LINT
  set dividerHeight(double value) {
    if (_dividerHeight == _dividerWidth) {
      return;
    }

    _dividerHeight = value;
    markNeedsLayout();
  }

  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.none;
  set clipBehavior(Clip value) {
    assert(value != null);
    if (value == _clipBehavior) {
      return;
    }
    _clipBehavior = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  double get spacing => _spacing;
  double _spacing;
  // LINT
  set spacing(double value) {
    _spacing = value;

    if (_spacing == value) {
      return;
    }
    markNeedsLayout();
  }

  bool get opaque => _opaque;
  bool _opaque;
  set opaque(bool value) {
    if (_opaque != value) {
      _opaque = value;
      markNeedsPaint();
    }
  }

  void markNeedsLayout() {}

  void markNeedsPaint() {}

  void markNeedsSemanticsUpdate() {}
}

enum Clip { none }
