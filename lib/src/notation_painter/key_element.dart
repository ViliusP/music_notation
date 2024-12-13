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
  AccidentalValue.threeQuartersFlat:
      AccidentalsSteinZimmermann.accidentalNarrowReversedFlatAndFlat,
  AccidentalValue.threeQuartersSharp:
      AccidentalsSteinZimmermann.accidentalThreeQuarterTonesSharpStein,
  AccidentalValue.sharpDown:
      Accidentals24EDOArrows.accidentalQuarterToneSharpArrowDown,
  AccidentalValue.sharpUp:
      Accidentals24EDOArrows.accidentalThreeQuarterTonesSharpArrowUp,
  AccidentalValue.naturalDown:
      Accidentals24EDOArrows.accidentalQuarterToneFlatNaturalArrowDown,
  AccidentalValue.naturalUp:
      Accidentals24EDOArrows.accidentalQuarterToneSharpNaturalArrowUp,
  AccidentalValue.flatDown:
      Accidentals24EDOArrows.accidentalThreeQuarterTonesFlatArrowDown,
  AccidentalValue.flatUp:
      Accidentals24EDOArrows.accidentalQuarterToneFlatArrowUp,
  AccidentalValue.doubleSharpDown:
      Accidentals24EDOArrows.accidentalThreeQuarterTonesSharpArrowDown,
  AccidentalValue.doubleSharpUp:
      Accidentals24EDOArrows.accidentalFiveQuarterTonesSharpArrowUp,
  AccidentalValue.flatFlatDown:
      Accidentals24EDOArrows.accidentalFiveQuarterTonesFlatArrowDown,
  AccidentalValue.flatFlatUp:
      Accidentals24EDOArrows.accidentalThreeQuarterTonesFlatArrowUp,
  AccidentalValue.arrowDown: Accidentals24EDOArrows.accidentalArrowDown,
  AccidentalValue.arrowUp: Accidentals24EDOArrows.accidentalArrowUp,
  AccidentalValue.tripleSharp: AccidentalsStandard.accidentalTripleSharp,
  AccidentalValue.tripleFlat: AccidentalsStandard.accidentalTripleFlat,
  AccidentalValue.slashQuarterSharp:
      AccidentalsAEU.accidentalKucukMucennebSharp,
  AccidentalValue.slashSharp: AccidentalsAEU.accidentalBuyukMucennebSharp,
  AccidentalValue.slashFlat: AccidentalsAEU.accidentalBakiyeFlat,
  AccidentalValue.doubleSlashFlat: AccidentalsAEU.accidentalBuyukMucennebFlat,
  AccidentalValue.sharp1: Accidentals53EDOTurkish.accidental1CommaSharp,
  AccidentalValue.sharp2: Accidentals53EDOTurkish.accidental2CommaSharp,
  AccidentalValue.sharp3: Accidentals53EDOTurkish.accidental3CommaSharp,
  AccidentalValue.sharp5: Accidentals53EDOTurkish.accidental5CommaSharp,
  AccidentalValue.flat1: Accidentals53EDOTurkish.accidental1CommaFlat,
  AccidentalValue.flat2: Accidentals53EDOTurkish.accidental2CommaFlat,
  AccidentalValue.flat3: Accidentals53EDOTurkish.accidental3CommaFlat,
  AccidentalValue.flat4: Accidentals53EDOTurkish.accidental4CommaFlat,
  AccidentalValue.sori: AccidentalsPersian.accidentalSori,
  AccidentalValue.koron: AccidentalsPersian.accidentalKoron,
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

  AlignmentOffset get offset => AlignmentOffset(
        top: -font.glyphBBoxes[_glyph]!.bBoxNE.y,
        left: 0,
      );

  SmuflGlyph get _glyph {
    return _accidentalSmuflMapping[type] ?? SmuflGlyph.noteheadXBlack;
  }

  GlyphBBox get _bBox => font.glyphBBoxes[_glyph]!;

  Size get size => _bBox.toSize();

  const AccidentalElement({
    super.key,
    required this.type,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: size.scaledByContext(context),
      painter: SimpleGlyphPainter(
        _glyph.codepoint,
        _bBox,
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

  AlignmentOffset get offset {
    if (accidentals.isEmpty) return AlignmentOffset(left: 0, top: 0);
    SmuflGlyph glyph = _accidentalSmuflMapping[
        accidentals.first.accidental?.value ?? AccidentalValue.other]!;

    double top = -font.glyphBBoxes[glyph]!.bBoxNE.y;

    return AlignmentOffset(
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
    int fifthsToShow = fifths; // ???
    if (fullCancel == true) {
      fifthsToShow = fifthsBefore!;
    }

    accidentals = fifthsToShow >= 0 ? _sharpSequence : _flatSequence;

    fifthsToShow = fifthsToShow.abs();

    if (fullCancel == true) {
      return accidentals
          .map((x) => x.toNatural())
          .toList()
          .sublist(0, fifthsToShow);
    }

    return accidentals.sublist(0, fifthsToShow);
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
      ).size;

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

  Size get size {
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
      ).size;

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
      size: size.scaledByContext(context),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: children,
      ),
    );
  }
}
