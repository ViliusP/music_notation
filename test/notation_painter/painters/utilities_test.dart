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
        bBoxNE: Coordinates(x: 1.492, y: 0.544),
        bBoxSW: Coordinates(x: 0.0, y: -0.536),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(19, 14)));
    });
    test("Half notehead calculated size should have correct size", () {
      // Whole notehead
      Size size = GlyphBBox(
        bBoxNE: Coordinates(x: 1.3, y: 0.528),
        bBoxSW: Coordinates(x: 0.0, y: -0.528),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(17, 14)));
    });
    test("Black notehead calculated size should have correct size", () {
      // Whole notehead
      Size size = GlyphBBox(
        bBoxNE: Coordinates(x: 1.3, y: 0.528),
        bBoxSW: Coordinates(x: 0.0, y: -0.532),
      ).toSize(defaultStaveSpace);

      expect(size, equals(Size(17, 14)));
    });
  });
}
