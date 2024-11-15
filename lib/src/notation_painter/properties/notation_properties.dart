import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

class NotationProperties extends InheritedWidget {
  final NotationLayoutProperties layout;

  const NotationProperties({
    super.key,
    required this.layout,
    required super.child,
  });

  /// Retrieves the closest instance of [NotationProperties] in the widget tree using [context].
  ///
  /// Example:
  /// ```dart
  /// final properties = NotationProperties.of(context);
  /// if (properties?.value ?? false) {
  ///   // Handle property
  /// }
  /// ```
  static NotationProperties? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NotationProperties>();
  }

  /// Determines if widgets in the subtree should be rebuilt when the properties change.
  @override
  bool updateShouldNotify(NotationProperties oldWidget) {
    return layout != oldWidget.layout;
  }
}
