import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

/// An abstract base class representing a musical element within a measure,
/// including properties for positioning, size, and alignment.
abstract class MeasureWidget extends Widget {
  /// Position of the musical element within the measure, using an [ElementPosition]
  /// object to define note pitch and octave. This allows accurate placement on the staff.
  ElementPosition get position;

  /// The size of the element, defining its width and height within the measure.
  Size get size;

  /// Deprecated!
  ///
  /// The offset of the element's position within its parent container or measure.
  /// This defines how much the element is shifted vertically from its default position.
  ///
  /// Measurement is defined from the element bounding box top.
  double get verticalAlignmentAxisOffset;

  /// Deprecated!
  ///
  /// The alignment offset from the left side of the element's rectangle.
  /// It represents the axis point for aligning the element with others,
  /// typically being the middle of most elements but adjustable for visual alignment.
  double get alignmentOffset;

  /// Optional positioning and alignment information for precise element placement.
  AlignmentPosition? get alignmentPosition;

  /// Constant constructor for the [MeasureWidget] base class.
  const MeasureWidget({super.key});
}

/// Defines specific alignment offsets for musical elements, used for vertical and
/// horizontal positioning within their container.
class AlignmentPosition {
  /// Vertical offset from the top of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=0`. If null, alignment is based on [bottom].
  final double? top;

  /// Vertical offset from the bottom of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=container.height`. If null, alignment is based on [top].
  final double? bottom;

  /// Horizontal offset from the left side of the element’s bounding box, aligning the
  /// element horizontally, typically at the visual or optical center.
  final double left;

  const AlignmentPosition({
    this.top,
    this.bottom,
    required this.left,
  }) : assert(
          (top == null) != (bottom == null),
          'Either top or bottom must be null, but not both.',
        );
}

/// A mixin for calculating bounding boxes of elements positioned above or below
/// the staff, particularly useful for handling elements like ledger lines.
extension MeasureElementDimensions on MeasureWidget {
  /// Calculates a bounding box for elements extending below the staff,
  /// with consideration for the element's position and vertical alignment offset.
  Rect boxBelowStaff() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double distanceToStaffBottom =
        offsetPerPosition * ElementPosition.staffBottom.numeric;

    double belowStaffLength = [
      -offsetPerPosition * position.numeric,
      distanceToStaffBottom,
      size.height,
      -verticalAlignmentAxisOffset,
    ].sum;

    belowStaffLength = [0.0, belowStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, belowStaffLength));
  }

  /// Calculates a bounding box for elements extending above the staff,
  /// considering the element's position and vertical alignment offset.
  Rect boxAboveStaff() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double distanceToStaffTop =
        offsetPerPosition * ElementPosition.staffTop.numeric;

    double aboveStaffLength = [
      offsetPerPosition * position.numeric,
      verticalAlignmentAxisOffset,
      -distanceToStaffTop,
    ].sum;

    aboveStaffLength = [0.0, aboveStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, aboveStaffLength));
  }
}
