import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

const epsilon = 0.001;

const noteheadBbox = GlyphBBox(
  bBoxNE: Point(0, 0.528),
  bBoxSW: Point(0, -0.532),
);
const noteheadSize = Size(1.3, 1.06);

const clefBBox = GlyphBBox(
  bBoxNE: Point(0, 4.448),
  bBoxSW: Point(0, -2.664),
);
const clefSize = Size(2.6, 7.112);

void main() {
  group("MeasureElement.heightAboveReference", () {
    test("Vertical extent of Clef G above it's own position should be correct",
        () {
      /// Clef G
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        alignment: clefBBox.toAlignment(),
      );
      expect(
        element.heightAboveReference(element.position),
        clefBBox.bBoxNE.y,
      );
    });
    test("Vertical extent of Clef G above staff should be correct", () {
      /// Clef G
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        alignment: clefBBox.toAlignment(),
      );

      expect(
        element.heightAboveReference(ElementPosition.staffTop),
        clefBBox.bBoxNE.y - (6 * 1 / 2),
      );
    });
    test(
      "Vertical extent of C4 notehead above staff should be zero",
      () {
        //  C4 notehead
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.C, octave: 4),
          size: noteheadSize,
          alignment: clefBBox.toAlignment(),
        );

        var actual = element.heightAboveReference(ElementPosition.staffTop);
        expect(actual, 0);
      },
    );
    test("Vertical extent of A5 notehead above staff should be correct", () {
      //  A5 notehead
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.A, octave: 5),
        size: noteheadSize,
        alignment: noteheadBbox.toAlignment(),
      );

      var actual = element.heightAboveReference(ElementPosition.staffTop);

      var expected = noteheadBbox.bBoxNE.y + (2 * 1 / 2);
      expect(actual, expected);
    });
  });

  group("MeasureElement.heightBelowReference", () {
    test("Vertical extent of Clef G below it's own position should be correct",
        () {
      /// Clef G
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        alignment: clefBBox.toAlignment(),
      );

      var actual = element.heightBelowReference(element.position);
      var expected = clefBBox.bBoxSW.y.abs();

      expect((actual - expected).abs() < epsilon, true);
    });

    test("Vertical extent of Clef G below staff should be correct", () {
      /// Clef G
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        alignment: clefBBox.toAlignment(),
      );

      var actual = element.heightBelowReference(ElementPosition.staffBottom);
      var expected = clefBBox.bBoxSW.y.abs() + (-2 * 1 / 2);

      expect((actual - expected).abs() < epsilon, true);
    });

    test(
      "Vertical extent of C4 notehead below staff should be correct (using bottom)",
      () {
        //  C4 notehead
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.C, octave: 4),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        var actual = element.heightBelowReference(ElementPosition.staffBottom);

        var expected = noteheadBbox.bBoxSW.y.abs() + (2 * 1 / 2);
        expect(actual, expected);
      },
    );

    test("Vertical extent of A5 notehead below staff should be zero", () {
      //  A5 notehead
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.A, octave: 5),
        size: noteheadSize,
        alignment: noteheadBbox.toAlignment(),
      );

      var actual = element.heightBelowReference(ElementPosition.staffBottom);

      var expected = 0;
      expect(actual, expected);
    });
  });

  group("MeasureElement.bound", () {
    test("Bounds (in positions) of Clef G should be correct", () {
      /// Clef G
      var element = MeasureElementLayoutData(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        alignment: clefBBox.toAlignment(),
      );

      expect(element.bounds.max, ElementPosition(step: Step.B, octave: 5));
      expect(element.bounds.min, ElementPosition(step: Step.A, octave: 3));
    });
    test(
      "Bounds (by top) (in positions) of A5 notehead should be correct",
      () {
        //  A5 notehead
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.A, octave: 5),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        expect(element.bounds.max, ElementPosition(step: Step.C, octave: 6));
        expect(element.bounds.min, ElementPosition(step: Step.F, octave: 5));
      },
    );

    test(
      "Bounds (by bottom) (in positions) of A5 notehead should be correct",
      () {
        //  A5 notehead
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.A, octave: 5),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        expect(element.bounds.max, ElementPosition(step: Step.C, octave: 6));
        expect(element.bounds.min, ElementPosition(step: Step.F, octave: 5));
      },
    );
  });

  group("MeasureElement.distanceToPosition", () {
    test(
      "Distance of notehead sides to same position should be same as alignment",
      () {
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.G, octave: 4),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        var pos = ElementPosition(step: Step.G, octave: 4);

        expect(
          element.distanceToPosition(pos, BoxSide.bottom),
          noteheadBbox.bBoxSW.y,
        );
        expect(
          element.distanceToPosition(pos, BoxSide.top),
          noteheadBbox.bBoxNE.y.abs(),
        );
      },
    );
  });
  group("MeasureElement.distance", () {
    test(
      "Distance between two same elements should be zero",
      () {
        var element = MeasureElementLayoutData(
          position: ElementPosition(step: Step.G, octave: 4),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        expect(element.distance(element, BoxSide.top), 0);
        expect(element.distance(element, BoxSide.bottom), 0);
      },
    );

    test(
      "Distance of betwween same noteheads should be stave space length",
      () {
        var element1 = MeasureElementLayoutData(
          position: ElementPosition(step: Step.G, octave: 4),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        var element2 = MeasureElementLayoutData(
          position: ElementPosition(step: Step.C, octave: 5),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        const staveSpacesBetweenPositions = -1.5;

        expect(
          element1.distance(element2, BoxSide.top),
          staveSpacesBetweenPositions,
        );
        expect(
          element1.distance(element2, BoxSide.bottom),
          staveSpacesBetweenPositions,
        );
      },
    );

    test(
      "Swapping elements should return same size but different sign",
      () {
        var element1 = MeasureElementLayoutData(
          position: ElementPosition(step: Step.G, octave: 4),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        var element2 = MeasureElementLayoutData(
          position: ElementPosition(step: Step.C, octave: 5),
          size: noteheadSize,
          alignment: noteheadBbox.toAlignment(),
        );

        expect(
          element1.distance(element2, BoxSide.top),
          -element2.distance(element1, BoxSide.top),
        );
        expect(
          element1.distance(element2, BoxSide.bottom),
          -element2.distance(element1, BoxSide.bottom),
        );
      },
    );
  });
}
