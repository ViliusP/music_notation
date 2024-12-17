import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

class MeasureElementPosition {
  /// Position of the musical element within the measure, using an [ElementPosition]
  /// object to define note pitch and octave. This allows accurate placement on the staff.
  final ElementPosition position;

  /// Optional positioning and alignment information for precise element placement
  /// within its own container.
  final AlignmentOffset offset;

  const MeasureElementPosition({required this.position, required this.offset});
}

class MeasureElementLayoutData extends MeasureElementPosition {
  const MeasureElementLayoutData({
    required this.size,
    required super.position,
    required super.offset,
  });

  /// The size of the element, in stave spaces, defining its width and height
  /// within the measure.
  final Size size;

  /// TODO CHECK
  /// Calculates how much does elements extent above [reference] and below [reference] position.
  /// If reference is not given, the lowest position will be considered as reference position.
  ///
  /// Results are in stave staves
  static NumericalRange<double> columnVerticalRange(
    List<MeasureElementLayoutData> elements, [
    ElementPosition? reference,
  ]) {
    if (elements.isEmpty) {
      return NumericalRange<double>(0.0, 0.0);
    }
    ElementPosition ref;
    if (reference != null) {
      ref = reference;
    } else {
      ref = columnPositionalRange(elements)!.min;
    }

    var bottoms = elements.map(
      (e) => e.distanceToPosition(ref, BoxSide.bottom),
    );
    var tops = elements.map(
      (e) => e.distanceToPosition(ref, BoxSide.top),
    );

    return NumericalRange<double>(bottoms.min, tops.max);
  }

  /// TODO CHECK
  ///
  /// Maximum and minimun values of [elements] position.
  static PositionalRange? columnPositionalRange(
    List<MeasureElementLayoutData> elements,
  ) {
    if (elements.isEmpty) {
      return null;
    }
    var positions = elements.map((e) => e.position);
    var min = positions.min;
    var max = positions.max;

    return PositionalRange(min, max);
  }

  /// TODO CHECK
  ///
  /// Positions needed to fully fit column bound in container.
  /// Do not mix with [columnPositionalRange].
  static PositionalRange? columnPositionalBounds(
    List<MeasureElementLayoutData> elements,
  ) {
    if (elements.isEmpty) {
      return null;
    }
    var ranges = elements.map((e) => e.bounds);
    var min = ranges.map((range) => range.min).min;
    var max = ranges.map((range) => range.max).max;

    return PositionalRange(min, max);
  }
}

abstract class MeasureWidget extends Widget
    implements MeasureElementLayoutData {
  const MeasureWidget({super.key});
}

extension MeasureElementDimensions on MeasureElementLayoutData {
  /// The bounds represents the vertical positions of an element within a layout system,
  /// with the positions adjusted based on the element's position, alignment and size.
  PositionalRange get bounds {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    double extentAbove = heightAboveReference(position);
    int positionsAbove = (extentAbove / spacePerPosition).ceil();
    ElementPosition top = position + positionsAbove;

    double extentBelow = heightBelowReference(position);
    int positionsBelow = (extentBelow / spacePerPosition).ceil();

    ElementPosition bottom = position - positionsBelow;

    return PositionalRange(top, bottom);
  }

  double _distanceToBottom(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = position.numeric - reference.numeric;
    double distanceToReference = interval * spacePerPosition;

    return distanceToReference + offset.bottom;
  }

  /// Vertical Distance from [reference] position to provided vertical [side] of element.
  /// Negative values means that [side] of [MeasureElementData] is positioned below [reference].
  ///
  /// Results are provided in stave spaces
  double distanceToPosition(ElementPosition reference, BoxSide side) {
    return switch (side) {
      BoxSide.top => _distanceToBottom(reference) + size.height,
      BoxSide.bottom => _distanceToBottom(reference),
    };
  }

  /// Vertical distance from element [side] to [reference] element [side].
  /// Negative values means that [side] of element is below [reference] element [side].
  double distance(MeasureElementLayoutData reference, BoxSide side) {
    ElementPosition upperBound = reference.bounds.max;
    return distanceToPosition(upperBound, side) -
        reference.distanceToPosition(upperBound, side);
  }

  /// Calculates the height of the bounding box for elements extending above
  /// the [reference] position, considering the element's [position] and vertical alignment [offset].
  double heightAboveReference(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = reference.numeric - position.numeric;
    double distanceToReference = interval * spacePerPosition;

    // The height of the element extending above its own alignment offset.
    // A positive value means the element is entirely below its alignment axis.
    double extentAbove = offset.top.limit(top: 0);
    extentAbove = extentAbove.abs();

    double aboveReference = extentAbove - distanceToReference;

    // If the value is negative, the element's top is below the reference,
    // meaning nothing extends above the reference, so the height is 0.
    return [0.0, aboveReference].max;
  }

  /// Calculates the height of the bounding box for elements extending below
  /// the [reference] position, considering the element's position and [position] alignment [offset].
  double heightBelowReference(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = reference.numeric - position.numeric;
    double distanceToReference = interval * spacePerPosition;

    // The height of the element extending below its own alignment offset.
    // A positive value means the element is entirely above its alignment axis.
    double extentBelow = offset.bottom.limit(top: 0);
    extentBelow = extentBelow.abs();

    double belowReference = extentBelow + distanceToReference;

    // If the value is negative, the element's bottom is above the reference,
    // meaning nothing extends below the reference, so the height is 0.
    return [0.0, belowReference].max;
  }
}

enum BoxSide {
  top,
  bottom,
}
