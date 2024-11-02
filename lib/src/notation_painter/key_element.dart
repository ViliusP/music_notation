import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    hide Key;
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/key_accidental_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

const Map<AccidentalValue, SmuflGlyph> _accidentalSmuflMapping = {
  AccidentalValue.sharp: AccidentalsStandard.accidentalSharp,
  AccidentalValue.natural: AccidentalsStandard.accidentalNatural,
  AccidentalValue.flat: AccidentalsStandard.accidentalFlat,
  AccidentalValue.doubleSharp: AccidentalsStandard.accidentalDoubleFlat,
  AccidentalValue.sharpSharp: AccidentalsStandard.accidentalSharpSharp,
  AccidentalValue.flatFlat: AccidentalsStandard.accidentalDoubleFlat,
  AccidentalValue.naturalSharp: AccidentalsStandard.accidentalNaturalSharp,
  AccidentalValue.naturalFlat: AccidentalsStandard.accidentalNaturalSharp,
  AccidentalValue.quarterFlat: SmuflGlyph.accidentalQuarterToneFlatStein,
  AccidentalValue.quarterFharp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.threeQuartersFlat: SmuflGlyph.noteheadXBlack,
  AccidentalValue.threeQuartersSharp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharpDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharpUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.naturalDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.naturalUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flatDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flatUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.doubleSharpDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.doubleSharpUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flatFlatDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flatFlatUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.arrowDown: SmuflGlyph.noteheadXBlack,
  AccidentalValue.arrowUp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.tripleSharp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.tripleFlat: SmuflGlyph.noteheadXBlack,
  AccidentalValue.slashQuarterSharp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.slashSharp: SmuflGlyph.noteheadXBlack,
  AccidentalValue.slashFlat: SmuflGlyph.noteheadXBlack,
  AccidentalValue.doubleSlashFlat: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharp1: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharp2: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharp3: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sharp5: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flat1: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flat2: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flat3: SmuflGlyph.noteheadXBlack,
  AccidentalValue.flat4: SmuflGlyph.noteheadXBlack,
  AccidentalValue.sori: SmuflGlyph.noteheadXBlack,
  AccidentalValue.koron: SmuflGlyph.noteheadXBlack,
  AccidentalValue.other: SmuflGlyph.noteheadXBlack,
};

const _sharpSequence = [
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.F,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.C,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.G,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.D,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
        step: Step.A,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.E,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
        step: Step.B,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
];

const _flatSequence = [
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
      step: Step.B,
      alter: -1,
      accidental: KeyAccidental(value: AccidentalValue.flat),
    ),
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.E,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
        step: Step.A,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.D,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
        step: Step.G,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
  (
    octave: 5,
    accidental: PitchedKeyAccidental(
        step: Step.C,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
  (
    octave: 4,
    accidental: PitchedKeyAccidental(
        step: Step.F,
        alter: -1,
        accidental: KeyAccidental(value: AccidentalValue.flat))
  ),
];

class AccidentalElement extends StatelessWidget {
  final PitchedKeyAccidental accidental;
  final FontMetadata font;

  AlignmentPosition get alignmentPosition {
    AccidentalValue accidentalValue =
        accidental.accidental?.value ?? AccidentalValue.other;

    SmuflGlyph glyph = _accidentalSmuflMapping[accidentalValue]!;

    return AlignmentPosition(
      top: -NotationLayoutProperties.staveSpace *
          font.glyphBBoxes[glyph]!.bBoxNE.y,
      left: 0,
    );
  }

  Size get size => calculateSize(accidental, font);

  static Size calculateSize(
    PitchedKeyAccidental accidental,
    FontMetadata font,
  ) {
    SmuflGlyph glyph = _accidentalSmuflMapping[
        accidental.accidental?.value ?? AccidentalValue.other]!;

    Rect headRect = font.glyphBBoxes[glyph]!.toRect();
    return Size(headRect.width, headRect.height);
  }

  const AccidentalElement({
    super.key,
    required this.accidental,
    required this.font,
  });

  static String smufl(AccidentalValue? accidentalValue) {
    if (accidentalValue == null) return SmuflGlyph.noteheadXBlack.codepoint;
    return _accidentalSmuflMapping[accidentalValue]!.codepoint;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: KeyAccidentalPainter(
        accidental.accidental?.smufl ?? smufl(accidental.accidental?.value),
        font.glyphBBoxes[
            _accidentalSmuflMapping[accidental.accidental?.value]]!,
      ),
    );
  }
}

class KeySignature extends StatelessWidget implements MeasureWidget {
  static const _spaceBetweenAccidentals = 6.0;
  static const _offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

  final FontMetadata font;

  @override
  AlignmentPosition get alignmentPosition {
    SmuflGlyph glyph = _accidentalSmuflMapping[
        accidentals.first.accidental.accidental?.value ??
            AccidentalValue.other]!;

    double top = -NotationLayoutProperties.staveSpace *
        font.glyphBBoxes[glyph]!.bBoxNE.y;

    return AlignmentPosition(
      top: top,
      left: 0,
    );
  }

  static ElementPosition _accidentalPosition(
      ({int octave, PitchedKeyAccidental accidental}) value) {
    return ElementPosition(step: value.accidental.step, octave: value.octave);
  }

  final List<({int octave, PitchedKeyAccidental accidental})> accidentals;

  List<double> get _leftOffsets {
    var leftOffset = 0.0;
    if (accidentals.isEmpty) {
      return [];
    }
    var offsets = <double>[];
    for (var accidental in accidentals) {
      Size accidentalSize = AccidentalElement(
        accidental: accidental.accidental,
        font: font,
      ).size;

      offsets.add(leftOffset);
      leftOffset += accidentalSize.width + _spaceBetweenAccidentals;
    }
    return offsets;
  }

  ({ElementPosition lowest, ElementPosition highest}) get _range {
    ElementPosition? lowestAccidental;
    ElementPosition? highestAccidental;

    for (var accidental in accidentals) {
      var accidentalPosition = _accidentalPosition(accidental);

      if (lowestAccidental == null || lowestAccidental > accidentalPosition) {
        lowestAccidental = accidentalPosition;
      }

      if (highestAccidental == null || highestAccidental < accidentalPosition) {
        highestAccidental = accidentalPosition;
      }
    }

    return (lowest: lowestAccidental!, highest: highestAccidental!);
  }

  @override
  Size get size {
    if (accidentals.isEmpty) {
      return const Size(0, 0);
    }

    var width = 0.0;

    int range = _range.highest.numeric - _range.lowest.numeric;
    double height = range * _offsetPerPosition;
    for (var (i, accidental) in accidentals.indexed) {
      Size accidentalSize = AccidentalElement(
        accidental: accidental.accidental,
        font: font,
      ).size;

      if (i == 0) {
        height += accidentalSize.height;
      }

      width += accidentalSize.width + _spaceBetweenAccidentals;
    }

    // Remove last width
    width = width - _spaceBetweenAccidentals;

    return Size(width, height);
  }

  int get _transposeInterval {
    switch (notationContext.clef?.sign) {
      case ClefSign.F:
        return -2;
      default:
    }
    return 0;
  }

  ElementPosition get _position => _range.highest;

  // TODO: fix
  @override
  ElementPosition get position => _position.transpose(_transposeInterval);

  final NotationContext notationContext;

  const KeySignature({
    super.key,
    required this.accidentals,
    required this.notationContext,
    required this.font,
  });

  factory KeySignature.fromKeyData({
    Key? key,
    required musicxml.Key keyData,
    required NotationContext notationContext,
    required FontMetadata font,
  }) {
    var accidentals = <({int octave, PitchedKeyAccidental accidental})>[];

    switch (keyData) {
      case TraditionalKey _:
        if (keyData.fifths == 0) {
          return KeySignature(
            accidentals: [],
            notationContext: NotationContext(
              divisions: null,
              clef: null,
              time: null,
            ),
            font: font,
          );
        }
        if (kDebugMode && keyData.octaves.isNotEmpty) {
          // ignore: avoid_print
          print("key-octave is not currently supported.");
        }
        if (kDebugMode && keyData.cancel != null) {
          // ignore: avoid_print
          print("cancel is not currently supported.");
        }

        if (kDebugMode && keyData.mode != null) {
          // ignore: avoid_print
          print("mode is not currently supported.");
        }

        int fifths = keyData.fifths.abs();
        accidentals = keyData.fifths >= 0 ? _sharpSequence : _flatSequence;
        accidentals = accidentals.sublist(0, fifths);

        break;
      case NonTraditionalKey _:
        throw UnimplementedError(
          "Non traditional key is not implemented in renderer yet",
        );
    }

    return KeySignature(
      key: key,
      accidentals: accidentals,
      notationContext: notationContext,
      font: font,
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    int highestAccidentalPosition = _range.highest.numeric;

    for (var (index, accidental) in accidentals.indexed) {
      var accidentalWidget = AccidentalElement(
        accidental: accidental.accidental,
        font: font,
      );

      int distanceFromHighest =
          highestAccidentalPosition - _accidentalPosition(accidental).numeric;

      children.add(
        Positioned(
          top: distanceFromHighest * _offsetPerPosition,
          child: Padding(
            padding: EdgeInsets.only(
              left: _leftOffsets[index],
            ),
            child: accidentalWidget,
          ),
        ),
      );
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }
}
