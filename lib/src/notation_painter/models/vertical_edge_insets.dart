import 'package:flutter/widgets.dart';

class VerticalEdgeInsets extends EdgeInsets {
  const VerticalEdgeInsets({
    required super.top,
    required super.bottom,
  }) : super.only();

  VerticalEdgeInsets increase({double? top, double? bottom}) {
    return VerticalEdgeInsets(
      top: this.top + (top ?? 0),
      bottom: this.bottom + (bottom ?? 0),
    );
  }
}
