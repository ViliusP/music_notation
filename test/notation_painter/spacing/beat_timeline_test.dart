import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';

void main() {
  group("Divisions change", () {
    test("Simple case #1", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
      ], divisions: 2);

      final expected = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 4,
          lastAttributeOffset: 89.45,
        ),
        null,
        null,
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 4,
          lastAttributeOffset: 89.45,
        ),
        null,
        null,
        null,
      ], divisions: 4);
      expect(
        beatline.changeDivisions(4),
        expected,
      );
    });
    test("Non normal beatline", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
      ], divisions: 2);

      final expected = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 4,
          lastAttributeOffset: 89.45,
        ),
        null,
        null,
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 4,
          lastAttributeOffset: 89.45,
        ),
        null,
        null,
        null,
      ], divisions: 4);
      expect(
        beatline.changeDivisions(4),
        expected,
      );
    });
  });

  group("Beatline normalization", () {
    test("simple case #1", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
      ], divisions: 2);
      final expected = BeatTimeline(values: [
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        null,
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        null,
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        null,
        BeatTimelineValue(
            width: 18.65,
            leftOffset: 0,
            duration: 2,
            lastAttributeOffset: 89.45),
        null,
      ], divisions: 2);
      expect(beatline.normalize(), expected);
    });
    test("simple case #2", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
      ], divisions: 2);
      final expected = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
      ], divisions: 2);
      expect(beatline.normalize(), expected);
    });
    test("Partly normalized", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
      ], divisions: 2);
      final expected = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
      ], divisions: 2);
      expect(beatline.normalize(), expected);
    });
    test("Already normalized", () {
      final beatline = BeatTimeline(values: [
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
        BeatTimelineValue(
          width: 20,
          leftOffset: 0,
          duration: 2,
          lastAttributeOffset: 89.45,
        ),
        null,
      ], divisions: 2);
      expect(beatline.normalize(), beatline);
    });
  });
}
