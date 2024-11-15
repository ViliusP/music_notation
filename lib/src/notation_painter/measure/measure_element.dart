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

  /// Optional positioning and alignment information for precise element placement.
  AlignmentPosition get alignmentPosition;

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
  final double? left;

  /// Horizontal offset from the right side of the element’s bounding box, aligning the
  /// element horizontally, typically at the visual or optical center.
  final double? right;

  const AlignmentPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
  })  : assert(
          (top == null) != (bottom == null),
          'Either top or bottom must be null, but not both.',
        ),
        assert(
          (left == null) != (right == null),
          'Either left or right must be null, but not both.',
        );
}

class AligmentPositioned extends Positioned {
  AligmentPositioned({
    super.key,
    required AlignmentPosition position,
    required super.child,
  }) : super(
          bottom: position.bottom,
          top: position.top,
          left: position.left,
          right: position.right,
        );
}

/// A mixin for calculating bounding boxes of elements positioned above or below
/// the staff, particularly useful for handling elements like ledger lines.
extension MeasureElementDimensions on MeasureWidget {
  /// Calculates a bounding box for elements extending below the staff,
  /// with consideration for the element's position and vertical alignment offset.
  Rect boxBelowStaff() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double belowStaffLength = 0;

    double distanceToStaffBottom =
        offsetPerPosition * ElementPosition.staffBottom.numeric;

    if (alignmentPosition.top != null) {
      belowStaffLength = [
        -offsetPerPosition * position.numeric,
        distanceToStaffBottom,
        size.height,
        alignmentPosition.top!,
      ].sum;
    }

    if (alignmentPosition.bottom != null) {
      belowStaffLength = [
        -offsetPerPosition * position.numeric,
        distanceToStaffBottom,
        -alignmentPosition.bottom!,
      ].sum;
    }

    belowStaffLength = [0.0, belowStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, belowStaffLength));
  }

  /// Calculates a bounding box for elements extending above the staff,
  /// considering the element's position and vertical alignment offset.
  Rect boxAboveStaff() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double aboveStaffLength = 0;

    double distanceToStaffTop =
        offsetPerPosition * ElementPosition.staffTop.numeric;

    if (alignmentPosition.top != null) {
      aboveStaffLength = [
        offsetPerPosition * position.numeric,
        -alignmentPosition.top!,
        -distanceToStaffTop,
      ].sum;
    }

    if (alignmentPosition.bottom != null) {
      aboveStaffLength = [
        offsetPerPosition * position.numeric,
        -distanceToStaffTop,
        size.height,
        alignmentPosition.bottom!,
      ].sum;
    }

    aboveStaffLength = [0.0, aboveStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, aboveStaffLength));
  }
}
