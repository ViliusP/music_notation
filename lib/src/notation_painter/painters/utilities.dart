import 'dart:math';

import 'package:flutter/rendering.dart';

import 'package:music_notation/src/smufl/font_metadata.dart';

extension FontPainting on GlyphBBox {
  Rect toRect([double scale = 1]) {
    var (o1, o2) = toOffsets();
    o1 = o1.scale(scale, scale);
    o2 = o2.scale(scale, scale);
    return Rect.fromPoints(o1, o2);
  }

  Size toSize([double scale = 1]) {
    return toRect(scale).size;
  }

  /// This function takes a `GlyphBBox` object and converts its bounding box coordinates
  /// from the Cartesian coordinate system used by SMuFL to the Flutter coordinate system.
  /// The Flutter coordinate system has the Y-axis inverted relative to Cartesian coordinates:
  /// in Cartesian, Y increases upwards; in Flutter, Y increases downwards.
  ///
  /// Returns tuple, where
  /// `o1` (first value of [Offset]) represents the NW corner;
  /// `o2` (second value of [Offset]) represents the SE corner.
  (Offset, Offset) toOffsets() {
    Point<double> ne = bBoxNE;
    Point<double> sw = bBoxSW;

    // Calculate the north-west (NW) corner in Flutter's coordinate system.
    // - `sw.x` is used for the X-coordinate (left side in Cartesian),
    // - `-ne.y` is used for the Y-coordinate to flip the Y-axis (top in Cartesian).
    Offset o1 = Offset(sw.x, -ne.y);

    // Calculate the south-east (SE) corner in Flutter's coordinate system.
    // - `ne.x` is used for the X-coordinate (right side in Cartesian),
    // - `-sw.y` is used for the Y-coordinate to flip the Y-axis (bottom in Cartesian).
    Offset o2 = Offset(ne.x, -sw.y);

    return (o1, o2);
  }
}
