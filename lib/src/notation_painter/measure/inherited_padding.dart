import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';

class InheritedPadding extends InheritedWidget {
  final VerticalEdgeInsets padding;

  const InheritedPadding({
    super.key,
    required this.padding,
    required super.child,
  });

  static InheritedPadding? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPadding>();
  }

  @override
  bool updateShouldNotify(InheritedPadding oldWidget) {
    return padding != oldWidget.padding || padding != oldWidget.padding;
  }
}
