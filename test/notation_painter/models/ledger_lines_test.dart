import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';

void main() {
  group("LedgerLines.fromElementPosition", () {
    test("No ledger lines for notes within or adjacent to the staff", () {
      expect(
        LedgerLines.fromElementPosition(ElementPosition.staffMiddle),
        isNull,
      );
      expect(
        LedgerLines.fromElementPosition(ElementPosition.staffBottom),
        isNull,
      );
      expect(LedgerLines.fromElementPosition(ElementPosition.staffTop), isNull);
    });

    test("Single ledger line below the staff", () {
      final result = LedgerLines.fromElementPosition(
        ElementPosition.firstLedgerBelow,
      );
      expect(result, isNotNull);
      expect(result!.count, equals(1));
      expect(result.start, equals(LedgerPlacement.center));
      expect(result.direction, equals(LedgerDrawingDirection.up));
    });

    test("Single ledger line above the staff", () {
      final result = LedgerLines.fromElementPosition(
        ElementPosition.firstLedgerAbove,
      );
      expect(result, isNotNull);
      expect(result!.count, equals(1));
      expect(result.start, equals(LedgerPlacement.center));
      expect(result.direction, equals(LedgerDrawingDirection.down));
    });

    test("Two ledger lines below the staff", () {
      final result = LedgerLines.fromElementPosition(
        ElementPosition.secondLedgerBelow,
      );
      expect(result, isNotNull);
      expect(result!.count, equals(2));
      expect(result.start, equals(LedgerPlacement.center));
      expect(result.direction, equals(LedgerDrawingDirection.up));
    });

    test("Two ledger lines above the staff", () {
      final result = LedgerLines.fromElementPosition(
        ElementPosition.secondLedgerAbove,
      );
      expect(result, isNotNull);
      expect(result!.count, equals(2));
      expect(result.start, equals(LedgerPlacement.center));
      expect(result.direction, equals(LedgerDrawingDirection.down));
    });

    test("Note D3 ledger lines", () {
      const d3 = ElementPosition(step: Step.D, octave: 3);
      final result = LedgerLines.fromElementPosition(d3);
      expect(result, isNotNull);
      expect(result!.count, equals(4));
      expect(result.start, equals(LedgerPlacement.center));
      expect(result.direction, equals(LedgerDrawingDirection.up));
    });

    test("Note F6 ledger lines", () {
      const f6 = ElementPosition(step: Step.F, octave: 6);
      final result = LedgerLines.fromElementPosition(f6);
      expect(result, isNotNull);
      expect(result!.count, equals(3));
      expect(result.start, equals(LedgerPlacement.below));
      expect(result.direction, equals(LedgerDrawingDirection.down));
    });

    test("Note B3 ledger lines", () {
      const lowPosition = ElementPosition(step: Step.B, octave: 3);
      final result = LedgerLines.fromElementPosition(lowPosition);
      expect(result, isNotNull);
      expect(result!.count, equals(1));
      expect(result.start, equals(LedgerPlacement.above));
      expect(result.direction, equals(LedgerDrawingDirection.up));
    });
  });
}
