import 'package:flutter/rendering.dart';

/// A custom painter that draws guiding lines within a box, based on provided guides.
///
/// The guides can be either horizontal or vertical, and each has a reference point
/// (left, right, middle for vertical; top, bottom, middle for horizontal) and an offset.
class BoxGuidePainter extends CustomPainter {
  /// A list of guides that define which lines to draw within the box.
  final List<CustomGuide> guides;

  /// Constructs a [BoxGuidePainter] with a specified list of guides.
  const BoxGuidePainter(this.guides);

  /// Paint object for drawing lines with a constant color and width.
  static final Paint _linePainter = Paint()
    ..color = Color.fromRGBO(255, 0, 0, 1)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    for (var guide in guides) {
      if (guide is VerticalGuide) {
        double dx = _calculateDx(guide, size.width);
        _drawVerticalLine(canvas, dx, size, _linePainter);
      } else if (guide is HorizontalGuide) {
        double dy = _calculateDy(guide, size.height);
        _drawHorizontalLine(canvas, dy, size, _linePainter);
      }
    }
  }

  /// Draws a vertical line on the canvas at the specified x-coordinate.
  void _drawVerticalLine(Canvas canvas, double dx, Size size, Paint paint) {
    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
  }

  /// Draws a horizontal line on the canvas at the specified y-coordinate.
  void _drawHorizontalLine(Canvas canvas, double dy, Size size, Paint paint) {
    canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
  }

  /// Calculates the x-coordinate for a vertical guide based on its reference point.
  double _calculateDx(VerticalGuide guide, double width) {
    switch (guide.reference) {
      case VerticalLineRef.left:
        return guide.offset;
      case VerticalLineRef.right:
        return width - guide.offset;
      case VerticalLineRef.middle:
        return width / 2 + guide.offset;
    }
  }

  /// Calculates the y-coordinate for a horizontal guide based on its reference point.
  double _calculateDy(HorizontalGuide guide, double height) {
    switch (guide.reference) {
      case HorizontalLineRef.top:
        return guide.offset;
      case HorizontalLineRef.bottom:
        return height - guide.offset;
      case HorizontalLineRef.middle:
        return height / 2 + guide.offset;
    }
  }

  @override
  bool shouldRepaint(BoxGuidePainter oldDelegate) {
    return oldDelegate.guides != guides;
  }

  @override
  bool shouldRebuildSemantics(BoxGuidePainter oldDelegate) => false;
}

/// Enum for grouping different sets of debug lines as options.
enum DebugLines {
  /// Lines that represent the bounding box.
  boundingBox([
    VerticalGuide(offset: 0, reference: VerticalLineRef.left),
    VerticalGuide(offset: 0, reference: VerticalLineRef.right),
    HorizontalGuide(offset: 0, reference: HorizontalLineRef.top),
    HorizontalGuide(offset: 0, reference: HorizontalLineRef.bottom),
  ]),

  /// A single vertical line at the middle.
  middleVerticaLine([
    VerticalGuide(offset: 0, reference: VerticalLineRef.middle),
  ]),

  /// A single horizontal line at the middle.
  middleHorizontalLine([
    HorizontalGuide(offset: 0, reference: HorizontalLineRef.middle),
  ]);

  /// List of guides associated with each debug line set.
  const DebugLines(this.guides);

  final List<CustomGuide> guides;
}

/// Enum for referencing positions of vertical lines.
enum VerticalLineRef {
  left, // The left side of the box
  right, // The right side of the box
  middle // The middle of the box
}

/// Enum for referencing positions of horizontal lines.
enum HorizontalLineRef {
  top, // The top side of the box
  bottom, // The bottom side of the box
  middle // The middle of the box
}

/// Base class for custom guides, which defines the offset for a guide line.
///
/// Both [VerticalGuide] and [HorizontalGuide] extend this class.
sealed class CustomGuide {
  /// Offset from the specified reference (e.g., left, right, top, bottom).
  final double offset;

  const CustomGuide({required this.offset});
}

/// A custom guide for vertical lines within the box.
class VerticalGuide extends CustomGuide {
  /// Reference point for the vertical line (left, right, or middle).
  final VerticalLineRef reference;

  const VerticalGuide({
    required super.offset,
    required this.reference,
  });
}

/// A custom guide for horizontal lines within the box.
class HorizontalGuide extends CustomGuide {
  /// Reference point for the horizontal line (top, bottom, or middle).
  final HorizontalLineRef reference;

  const HorizontalGuide({
    required super.offset,
    required this.reference,
  });
}
