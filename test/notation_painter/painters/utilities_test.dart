import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

void main() {
  group("Notehead sizes (Leland font) at staff height 50/4", () {
    double staffHeight = 50;
    double defaultStaveSpace = staffHeight / 4;

    test("Whole notehead calculated size should have correct size", () {
      // Whole notehead
      Size size = GlyphBBox(
        bBoxNE: Point(1.492, 0.544),
        bBoxSW: Point(0.0, -0.536),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(18.6, 13.5)));
    });
    test("Half notehead calculated size should have correct size", () {
      // Whole notehead
      Size size = GlyphBBox(
        bBoxNE: Point(1.3, 0.528),
        bBoxSW: Point(0.0, -0.528),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(16.3, 13.2)));
    });
    test("Black notehead calculated size should have correct size", () {
      // Whole notehead
      Size size = GlyphBBox(
        bBoxNE: Point(1.3, 0.528),
        bBoxSW: Point(0.0, -0.532),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(16.3, 13.3)));
    });
  });
}
