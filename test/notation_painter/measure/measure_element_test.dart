import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';

const epsilon = 0.01;

const noteheadOffset = AlignmentOffset(top: -0.528, bottom: -0.532, left: 0);
const noteheadSize = Size(1.3, 1.056);

const clefOffset = AlignmentOffset(top: -4.448, bottom: -2.664, left: 0);
const clefSize = Size(2.6, 7.1);

void main() {
  group("MeasureElement.heightAboveReference", () {
    test("Vertical extent of Clef G above it's own position should be correct",
        () {
      /// Clef G
      var element = MeasureElement(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        offset: clefOffset,
        duration: 0,
        child: SizedBox(),
      );

      expect(
        element.heightAboveReference(element.position),
        -element.offset.top,
      );
    });
    test("Vertical extent of Clef G above staff should be correct", () {
      /// Clef G
      var element = MeasureElement(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        offset: clefOffset,
        duration: 0,
        child: SizedBox(),
      );

      expect(
        element.heightAboveReference(ElementPosition.staffTop),
        -element.offset.top - (6 * 1 / 2),
      );
    });
    test(
      "Vertical extent of C4 notehead above staff should be zero",
      () {
        //  C4 notehead
        var element = MeasureElement(
          position: ElementPosition(step: Step.C, octave: 4),
          size: noteheadSize,
          offset: noteheadOffset,
          duration: 0,
          child: SizedBox(),
        );

        var actual = element.heightAboveReference(ElementPosition.staffTop);
        expect(actual, 0);
      },
    );
    test("Vertical extent of A5 notehead above staff should be correct", () {
      //  A5 notehead
      var element = MeasureElement(
        position: ElementPosition(step: Step.A, octave: 5),
        size: noteheadSize,
        offset: noteheadOffset,
        duration: 0,
        child: SizedBox(),
      );

      var actual = element.heightAboveReference(ElementPosition.staffTop);

      var expected = -element.offset.top + (2 * 1 / 2);
      expect((actual - expected).abs() < epsilon, true);
    });
  });

  group("MeasureElement.heightBelowReference", () {
    test("Vertical extent of Clef G below it's own position should be correct",
        () {
      /// Clef G
      var element = MeasureElement(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        offset: clefOffset,
        duration: 0,
        child: SizedBox(),
      );

      var actual = element.heightBelowReference(element.position);
      var expected = element.offset.height + element.offset.top;
      expect((actual - expected).abs() < epsilon, true);
    });
    test("Vertical extent of Clef G below staff should be correct", () {
      /// Clef G
      var element = MeasureElement(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        offset: clefOffset,
        duration: 0,
        child: SizedBox(),
      );

      var actual = element.heightBelowReference(ElementPosition.staffBottom);
      var expected = element.offset.height + element.offset.top + (-2 * 1 / 2);
      expect((actual - expected).abs() < epsilon, true);
    });

    test(
      "Vertical extent of C4 notehead below staff should be correct (using bottom)",
      () {
        //  C4 notehead
        var element = MeasureElement(
          position: ElementPosition(step: Step.C, octave: 4),
          size: noteheadSize,
          offset: noteheadOffset,
          duration: 0,
          child: SizedBox(),
        );

        var actual = element.heightBelowReference(ElementPosition.staffBottom);

        var expected = -element.offset.bottom + (2 * 1 / 2);
        expect(actual, expected);
      },
    );

    test("Vertical extent of A5 notehead below staff should be zero", () {
      //  A5 notehead
      var element = MeasureElement(
        position: ElementPosition(step: Step.A, octave: 5),
        size: noteheadSize,
        offset: noteheadOffset,
        duration: 0,
        child: SizedBox(),
      );

      var actual = element.heightBelowReference(ElementPosition.staffBottom);

      var expected = 0;
      expect(actual, expected);
    });
  });

  group("MeasureElement.bound", () {
    test("Bounds (in positions) of Clef G should be correct", () {
      /// Clef G
      var element = MeasureElement(
        position: ElementPosition(step: Step.G, octave: 4),
        size: clefSize,
        offset: clefOffset,
        duration: 0,
        child: SizedBox(),
      );

      expect(element.bounds.max, ElementPosition(step: Step.B, octave: 5));
      expect(element.bounds.min, ElementPosition(step: Step.A, octave: 3));
    });
    test(
      "Bounds (by top) (in positions) of A5 notehead should be correct",
      () {
        //  A5 notehead
        var element = MeasureElement(
          position: ElementPosition(step: Step.A, octave: 5),
          size: noteheadSize,
          offset: noteheadOffset,
          duration: 0,
          child: SizedBox(),
        );

        expect(element.bounds.max, ElementPosition(step: Step.C, octave: 6));
        expect(element.bounds.min, ElementPosition(step: Step.F, octave: 5));
      },
    );

    test(
      "Bounds (by bottom) (in positions) of A5 notehead should be correct",
      () {
        //  A5 notehead
        var element = MeasureElement(
          position: ElementPosition(step: Step.A, octave: 5),
          size: noteheadSize,
          offset: noteheadOffset,
          duration: 0,
          child: SizedBox(),
        );

        expect(element.bounds.max, ElementPosition(step: Step.C, octave: 6));
        expect(element.bounds.min, ElementPosition(step: Step.F, octave: 5));
      },
    );
  });
}
