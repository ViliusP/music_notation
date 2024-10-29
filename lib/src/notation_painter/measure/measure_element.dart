import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

/// An abstract base class for a measure widget that represents a musical element
/// with properties related to its positioning, size, and alignment within a measure.
abstract class MeasureWidget extends Widget {
  /// The position of the musical element within the measure, represented by an `ElementPosition` object.
  /// This includes information such as the step (A-G) and octave, allowing precise
  /// definition and comparison of the element's position on the musical staff.
  /// It enables accurate placement of elements according to the diatonic scale.
  ElementPosition get position;

  /// The size of the element, defining its width and height within the measure.
  Size get size;

  /// The offset of the element's position within its parent container or measure.
  /// This defines how much the element is shifted vertically from its default position.
  ///
  /// Measurement is defined from the element bounding box top.
  double get verticalAlignmentAxisOffset;

  /// The alignment offset from the left side of the element's rectangle.
  /// It represents the axis point for aligning the element with others,
  /// typically being the middle of most elements but adjustable for visual alignment.
  double get alignmentOffset;

  /// A constant constructor for the [MeasureWidget] to ensure that subclasses can be instantiated
  /// with constant expressions if all their fields are constant.
  const MeasureWidget({super.key});
}

/// A mixin that provides methods related to element dimensions and positioning on the musical staff.
/// This mixin can be applied to any class that extends [MeasureWidget] and provides the necessary properties.
extension MeasureElemenetDimensions on MeasureWidget {
  /// Calculates the rectangular box below the staff where the element might be positioned.
  /// This is particularly useful for elements that extend below the musical staff, like ledger lines.
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

  Rect boxAboveStaff() {
    const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    double distanceToStaffTop =
        offsetPerPosition * ElementPosition.staffTop.numeric;

    double aboveStaffLength = [
      offsetPerPosition * position.numeric,
      verticalAlignmentAxisOffset,
      -distanceToStaffTop
    ].sum;

    aboveStaffLength = [0.0, aboveStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, aboveStaffLength));
  }
}
