import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

class MeasureElementPosition {
  /// Position of the musical element within the measure, using an [ElementPosition]
  /// object to define note pitch and octave. This allows accurate placement on the staff.
  final ElementPosition position;

  /// Defines specific alignment offsets for musical elements, used for vertical and
  /// horizontal positioning within their container.
  final Alignment alignment;

  const MeasureElementPosition({
    required this.position,
    required this.alignment,
  });
}

class MeasureElementLayoutData extends MeasureElementPosition {
  const MeasureElementLayoutData({
    required this.size,
    required super.position,
    required super.alignment,
  });

  /// The size of the element, in stave spaces, defining its width and height
  /// within the measure.
  final Size size;

  static double calculateSingleAxisAlignment(double a, double b, Axis axis) {
    final midpoint = (a + b) / 2;
    final halfDistance = (a - b).abs() / 2;
    final shift = midpoint / halfDistance;

    // Because of Flutter vertical coordinates increases downward.
    return switch (axis) {
      Axis.vertical => shift,
      Axis.horizontal => -shift,
    };
  }

  // /// Returns value from [-1, 1].
  // static double calculateVerticalAlignment(
  //   List<MeasureElementLayoutData> children,
  //   ElementPosition position,
  // ) {
  //   return
  // }
}

abstract class MeasureWidget extends Widget
    implements MeasureElementLayoutData {
  const MeasureWidget({super.key});
}

extension MeasureElementDimensions on MeasureElementLayoutData {
  double get _halfHeight => size.height / 2;
  double get _topHeight => _halfHeight + (alignment.y * _halfHeight);
  double get _bottomHeight => _halfHeight - (alignment.y * _halfHeight);

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

  double _distanceToBottom(
    ElementPosition reference,
    double heightPerPosition,
  ) {
    int interval = position.numeric - reference.numeric;
    double distanceToReference = interval * heightPerPosition;

    return distanceToReference - _bottomHeight;
  }

  /// Vertical Distance from [reference] position to provided vertical [side] of element.
  /// Negative values means that [side] of element is positioned below [reference].
  ///
  /// Results are provided in stave spaces
  double distanceToPosition(
    ElementPosition reference,
    BoxSide side,
    double heightPerPosition,
  ) {
    var distanceToBotttom = _distanceToBottom(reference, heightPerPosition);
    return switch (side) {
      BoxSide.top => distanceToBotttom + size.height,
      BoxSide.bottom => distanceToBotttom,
    };
  }

  /// Vertical distance from element [side] to [reference] element [side].
  /// Negative values means that [side] of element is below [reference] element [side].
  double distance(
    MeasureElementLayoutData reference,
    BoxSide side,
    double heightPerPosition,
  ) {
    ElementPosition upperBound = reference.bounds.max;
    return distanceToPosition(upperBound, side, heightPerPosition) -
        reference.distanceToPosition(upperBound, side, heightPerPosition);
  }

  /// Calculates the height of the bounding box for elements extending above
  /// the [reference] position, considering the element's [position] and vertical alignment [offset].
  double heightAboveReference(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = reference.numeric - position.numeric;
    double distanceToReference = interval * spacePerPosition;

    // The height of the element extending above its own alignment offset.
    // A positive value means the element is entirely below its alignment axis.
    double extentAbove = _topHeight;
    extentAbove = extentAbove.limit(bottom: 0);

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

    double extentBelow = _bottomHeight;

    double belowReference = extentBelow + distanceToReference;

    // If the value is negative, the element's bottom is above the reference,
    // meaning nothing extends below the reference, so the height is 0.
    return [0.0, belowReference].max;
  }
}

extension MeasureList<T> on List<MeasureElementLayoutData> {
  // /// TODO CHECK
  // /// Calculates how much does elements extent above [reference] and below [reference] position.
  // /// If reference is not given, the lowest position will be considered as reference position.
  // ///
  // /// Results are in stave staves
  NumericalRange<double> columnVerticalRange(
    double heightPerPosition, [
    ElementPosition? reference,
  ]) {
    if (isEmpty) {
      return NumericalRange<double>(0.0, 0.0);
    }
    ElementPosition ref;
    if (reference != null) {
      ref = reference;
    } else {
      ref = this.columnPositionalRange()!.min;
    }

    var bottoms = map(
      (e) => e.distanceToPosition(ref, BoxSide.bottom, heightPerPosition),
    );
    var tops = map(
      (e) => e.distanceToPosition(ref, BoxSide.top, heightPerPosition),
    );

    return NumericalRange<double>(bottoms.min, tops.max);
  }

  /// TODO CHECK
  ///
  /// Maximum and minimun values of [elements] position.
  PositionalRange? columnPositionalRange() {
    if (isEmpty) {
      return null;
    }
    var positions = map((e) => e.position);
    var min = positions.min;
    var max = positions.max;

    return PositionalRange(min, max);
  }

  /// TODO CHECK
  ///
  /// Positions needed to fully fit column bound in container.
  /// Do not mix with [columnPositionalRange].
  PositionalRange? columnPositionalBounds() {
    if (isEmpty) {
      return null;
    }
    var ranges = map((e) => e.bounds);
    var min = ranges.map((range) => range.min).min;
    var max = ranges.map((range) => range.max).max;

    return PositionalRange(min, max);
  }
}

enum BoxSide {
  top,
  bottom,
}
