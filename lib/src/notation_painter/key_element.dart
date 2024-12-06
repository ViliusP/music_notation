import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    hide Key;

import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/octaved_key_accidental.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

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

final _sharpSequence = [
  OctavedKeyAccidental.fromParent(
    octave: 5,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.F,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 5,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.C,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 5,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.G,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 5,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.D,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 4,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.A,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 5,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.E,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
  OctavedKeyAccidental.fromParent(
    octave: 4,
    keyAccidental: const PitchedKeyAccidental(
        step: Step.B,
        alter: 1,
        accidental: KeyAccidental(value: AccidentalValue.sharp)),
  ),
];

final _flatSequence = [
  OctavedKeyAccidental.fromParent(
    keyAccidental: PitchedKeyAccidental(
      step: Step.B,
      alter: -1,
      accidental: KeyAccidental(value: AccidentalValue.flat),
    ),
    octave: 4,
  ),
  OctavedKeyAccidental.fromParent(
      octave: 5,
      keyAccidental: PitchedKeyAccidental(
          step: Step.E,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
  OctavedKeyAccidental.fromParent(
      octave: 4,
      keyAccidental: PitchedKeyAccidental(
          step: Step.A,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
  OctavedKeyAccidental.fromParent(
      octave: 5,
      keyAccidental: PitchedKeyAccidental(
          step: Step.D,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
  OctavedKeyAccidental.fromParent(
      octave: 4,
      keyAccidental: PitchedKeyAccidental(
          step: Step.G,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
  OctavedKeyAccidental.fromParent(
      octave: 5,
      keyAccidental: PitchedKeyAccidental(
          step: Step.C,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
  OctavedKeyAccidental.fromParent(
      octave: 4,
      keyAccidental: PitchedKeyAccidental(
          step: Step.F,
          alter: -1,
          accidental: KeyAccidental(value: AccidentalValue.flat))),
];

class AccidentalElement extends StatelessWidget {
  final AccidentalValue type;
  final FontMetadata font;

  AlignmentPosition get alignmentPosition => calculateAlignmentPosition(
        type,
        font,
      );

  static AlignmentPosition calculateAlignmentPosition(
    AccidentalValue accidental,
    FontMetadata font,
  ) {
    SmuflGlyph glyph = _accidentalSmuflMapping[accidental]!;

    return AlignmentPosition(
      top: -font.glyphBBoxes[glyph]!.bBoxNE.y,
      left: 0,
    );
  }

  Size get baseSize => calculateSize(type, font);

  static Size calculateSize(
    AccidentalValue accidental,
    FontMetadata font,
  ) {
    SmuflGlyph glyph = _accidentalSmuflMapping[accidental]!;

    return font.glyphBBoxes[glyph]!.toSize(1);
  }

  const AccidentalElement({
    super.key,
    required this.type,
    required this.font,
  });

  static String smufl(AccidentalValue? accidentalValue) {
    if (accidentalValue == null) return SmuflGlyph.noteheadXBlack.codepoint;
    return _accidentalSmuflMapping[accidentalValue]!.codepoint;
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: baseSize.scaledByContext(context),
      painter: SimpleGlyphPainter(
        smufl(type),
        font.glyphBBoxes[_accidentalSmuflMapping[type]]!,
        layoutProperties.staveSpace,
      ),
    );
  }
}

class KeySignatureElement extends StatelessWidget {
  final int fifths;
  final int? fifthsBefore;
  final FontMetadata font;
  final Clef? clef;

  static const _baseSpaceBetweenAccidentals = 0.25;

  AlignmentPosition get alignmentPosition {
    if (accidentals.isEmpty) return AlignmentPosition(left: 0, top: 0);
    SmuflGlyph glyph = _accidentalSmuflMapping[
        accidentals.first.accidental?.value ?? AccidentalValue.other]!;

    double top = -font.glyphBBoxes[glyph]!.bBoxNE.y;

    return AlignmentPosition(
      top: top,
      left: 0,
    );
  }

  /// Returns how many keys are canceled.
  int get cancelCount {
    int? lastFifths = fifthsBefore;

    if (lastFifths == null) return 0;

    return lastFifths.abs() - fifths.abs();
  }

  /// Returns `true` if keys are fully canceled.
  /// Returns `null` if there is no cancel.
  bool? get fullCancel {
    int? lastFifths = fifthsBefore;

    if (lastFifths == null) return null;

    return lastFifths != 0 && fifths == 0;
  }

  List<OctavedKeyAccidental> get accidentals {
    var accidentals = <OctavedKeyAccidental>[];
    int fifthsA = fifths;
    if (fullCancel == true) {
      fifthsA = fifthsBefore!;
    }

    accidentals = fifthsA >= 0 ? _sharpSequence : _flatSequence;

    if (fullCancel == true) {
      return accidentals
          .map((x) => x.toNatural())
          .toList()
          .sublist(0, fifthsA.abs());
    }

    return accidentals.sublist(0, fifthsA.abs());
  }

  List<double> get _leftOffsets {
    var leftOffset = 0.0;
    if (accidentals.isEmpty) {
      return [];
    }
    var offsets = <double>[];
    for (var accidental in accidentals) {
      Size accidentalSize = AccidentalElement(
        type: accidental.accidental?.value ?? AccidentalValue.other,
        font: font,
      ).baseSize;

      offsets.add(leftOffset);
      leftOffset += accidentalSize.width + _baseSpaceBetweenAccidentals;
    }
    return offsets;
  }

  ({ElementPosition lowest, ElementPosition highest}) get _range {
    ElementPosition? lowestAccidental;
    ElementPosition? highestAccidental;

    for (var accidental in accidentals) {
      var accidentalPosition = accidental.position;

      if (lowestAccidental == null || lowestAccidental > accidentalPosition) {
        lowestAccidental = accidentalPosition;
      }

      if (highestAccidental == null || highestAccidental < accidentalPosition) {
        highestAccidental = accidentalPosition;
      }
    }

    return (
      lowest: lowestAccidental ?? ElementPosition.staffMiddle,
      highest: highestAccidental ?? ElementPosition.staffMiddle,
    );
  }

  Size get baseSize {
    if (accidentals.isEmpty) {
      return const Size(0, 0);
    }

    var width = 0.0;

    int range = _range.highest.numeric - _range.lowest.numeric;
    double height = range * .5;
    for (var (i, accidental) in accidentals.indexed) {
      Size accidentalSize = AccidentalElement(
        type: accidental.accidental?.value ?? AccidentalValue.other,
        font: font,
      ).baseSize;

      if (i == 0) {
        height += accidentalSize.height;
      }

      width += accidentalSize.width + _baseSpaceBetweenAccidentals;
    }

    // Remove last width
    width = width - _baseSpaceBetweenAccidentals;

    return Size(width, height);
  }

  int get _transposeInterval {
    switch (clef?.sign) {
      case ClefSign.F:
        return -2;
      default:
    }
    return 0;
  }

  ElementPosition get _position => _range.highest;

  // TODO: fix
  ElementPosition get position => _position.transpose(_transposeInterval);

  const KeySignatureElement({
    required this.font,
    required this.fifths,
    required this.fifthsBefore,
    this.clef,
    super.key,
  });

  factory KeySignatureElement.traditional({
    required TraditionalKey key,
    required TraditionalKey? keyBefore,
    required Clef? clef,
    required FontMetadata font,
  }) {
    return KeySignatureElement(
      fifths: key.fifths,
      fifthsBefore: keyBefore?.fifths,
      clef: clef,
      font: font,
    );
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    var children = <Widget>[];

    int highestAccidentalPosition = _range.highest.numeric;

    for (var (index, accidental) in accidentals.indexed) {
      var accidentalWidget = AccidentalElement(
        type: accidental.accidental?.value ?? AccidentalValue.other,
        font: font,
      );

      int distanceFromHighest =
          highestAccidentalPosition - accidental.position.numeric;

      children.add(
        Positioned(
          top: distanceFromHighest * layoutProperties.spacePerPosition,
          child: Padding(
            padding: EdgeInsets.only(
              left: _leftOffsets[index].scaledByContext(context),
            ),
            child: accidentalWidget,
          ),
        ),
      );
    }

    return SizedBox.fromSize(
      size: baseSize.scaledByContext(context),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }
}
