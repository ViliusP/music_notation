import 'package:flutter/material.dart';

class InheritedPadding extends InheritedWidget {
  final double top;
  final double bottom;

  const InheritedPadding({
    super.key,
    required this.top,
    required this.bottom,
    required super.child,
  });

  static InheritedPadding? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPadding>();
  }

  @override
  bool updateShouldNotify(InheritedPadding oldWidget) {
    return top != oldWidget.top || bottom != oldWidget.bottom;
  }
}
