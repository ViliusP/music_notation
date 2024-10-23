import 'package:flutter/widgets.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class NotationFont extends InheritedWidget {
  final FontMetadata value;

  const NotationFont({
    super.key,
    required this.value,
    required super.child,
  });

  static NotationFont? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NotationFont>();
  }

  @override
  bool updateShouldNotify(NotationFont oldWidget) {
    return value != oldWidget.value || value != oldWidget.value;
  }
}
