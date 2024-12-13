import 'package:flutter/widgets.dart';

/// An inherited widget providing debugging options for rendering musical notation,
/// including options to paint bounding boxes and additional imaginary stave lines
/// for vertical alignment testing.
class DebugSettings extends InheritedWidget {
  /// If `true`, paints a bounding box below the staff for debugging layout alignment.
  final bool paintBBoxBelowStaff;

  /// If `true`, paints a bounding box above the staff for debugging layout alignment.
  final bool paintBBoxAboveStaff;

  /// Specifies where to render additional stave lines for debugging purposes,
  /// aiding in the vertical alignment of notes, especially on ledger lines.
  final ExtraStaveLines extraStaveLines;

  /// Number of extra stave lines to render, controlled by the `extraStaveLines` setting.
  final int extraStaveLineCount;

  /// Defines if beat guide is drawn onto staff.
  final bool beatMarker;

  /// Defines how many [beatMarker]s are drawn per quarter note.
  ///
  /// For example:
  /// `2` - beat marker will be render every eight note.
  /// `0.25` beat marker will appear every whole note.
  final double beatMarkerMultiplier;

  final Set<AlignmentDebugOption> alignmentDebugOptions;

  /// Creates a [DebugSettings] widget with specified debugging options.
  ///
  /// The [child] widget subtree inherits these debug settings. The [paintBBoxBelowStaff]
  /// and [paintBBoxAboveStaff] flags control whether to render bounding boxes below
  /// or above the staff, respectively. The [extraStaveLines] and [extraStaveLineCount]
  /// parameters control the rendering of additional imaginary stave lines.
  const DebugSettings({
    super.key,
    this.paintBBoxBelowStaff = false,
    this.paintBBoxAboveStaff = false,
    this.extraStaveLines = ExtraStaveLines.none,
    this.extraStaveLineCount = 0,
    this.beatMarker = false,
    this.beatMarkerMultiplier = 1,
    this.alignmentDebugOptions = const {},
    required super.child,
  });

  /// Retrieves the closest instance of [DebugSettings] in the widget tree using [context].
  ///
  /// Example:
  /// ```dart
  /// final debugSettings = DebugSettings.of(context);
  /// if (debugSettings?.paintBBoxAboveStaff ?? false) {
  ///   // Handle above-staff bounding box rendering.
  /// }
  /// ```
  static DebugSettings? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DebugSettings>();
  }

  /// Determines if widgets in the subtree should be rebuilt when the debug settings change.
  @override
  bool updateShouldNotify(DebugSettings oldWidget) {
    return paintBBoxBelowStaff != oldWidget.paintBBoxBelowStaff ||
        paintBBoxAboveStaff != oldWidget.paintBBoxAboveStaff ||
        extraStaveLines != oldWidget.extraStaveLines ||
        extraStaveLineCount != oldWidget.extraStaveLineCount;
  }
}

/// Options for rendering extra imaginary stave lines to aid in vertical alignment debugging,
/// such as positioning notes on ledger lines.
enum ExtraStaveLines {
  /// No additional stave lines are rendered.
  none,

  /// Renders extra stave lines above the staff.
  above,

  /// Renders extra stave lines below the staff.
  below,

  /// Renders extra stave lines above and below the staff.
  double,
}

enum AlignmentDebugOption {
  /// Draws only top alignment line.
  top,

  /// Draws only effective top alignment line.
  topEffective,

  /// Draws only bottom alignment line.
  bottom,

  /// Draws only effective bottom alignment line.
  bottomEffective,
}
