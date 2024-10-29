import 'package:flutter/widgets.dart';

/// DebugSettings is an InheritedWidget that provides debugging options
/// for painting bounding boxes of musical elements in a widget tree.
/// This allows child widgets to access and react to the debug settings,
/// such as whether to paint the bounding box below or above the staff.
class DebugSettings extends InheritedWidget {
  /// Flag for whether to paint the bounding box below the staff.
  /// This flag can be used by child widgets to determine if they should render
  /// visual debugging information below the musical staff.
  final bool paintBBoxBelowStaff;

  /// Flag for whether to paint the bounding box above the staff.
  /// This flag can be used by child widgets to determine if they should render
  /// visual debugging information above the musical staff.
  final bool paintBBoxAboveStaff;

  /// Constructor for the DebugSettings InheritedWidget.
  /// The `child` parameter is required and represents the widget subtree that
  /// will inherit these debug settings.
  ///
  /// `paintBBoxBelopStaff` and `paintBBoxAboveStaff` are optional flags that default
  /// to `false`. They control whether the bounding boxes for musical elements
  /// are painted below or above the staff.
  const DebugSettings({
    super.key,
    this.paintBBoxBelowStaff = false,
    this.paintBBoxAboveStaff = false,
    required super.child, // Required child widget subtree
  });

  /// Provides an easy way to access DebugSettings from any descendant widget.
  /// It uses Flutter's context to retrieve the closest instance of DebugSettings
  /// in the widget tree. If no DebugSettings are found, it returns `null`.
  ///
  /// Example usage:
  /// ```dart
  /// final debugSettings = DebugSettings.of(context);
  /// if (debugSettings?.paintBBoxAboveStaff ?? false) {
  ///   // Do something with the above-staff bounding box setting
  /// }
  /// ```
  static DebugSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DebugSettings>();
  }

  /// Determines whether the widget should notify its descendants when
  /// the debug settings change. This ensures that if either of the flags
  /// (`paintBBoxBelopStaff` or `paintBBoxAboveStaff`) changes,
  /// the affected widgets in the subtree will be rebuilt.
  @override
  bool updateShouldNotify(DebugSettings oldWidget) {
    // Notify descendants if either of the debug flags has changed
    return paintBBoxBelowStaff != oldWidget.paintBBoxBelowStaff ||
        paintBBoxAboveStaff != oldWidget.paintBBoxAboveStaff;
  }
}
