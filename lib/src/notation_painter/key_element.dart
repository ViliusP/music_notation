import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    hide Key;
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart'
    as musicxml show Key;
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/key_accidental_painter.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

class KeySignatureAccidental extends StatelessWidget {
  final AccidentalValue type;

  Size get size => const Size(11, 30);

  const KeySignatureAccidental({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: KeyAccidentalPainter(
        Accidentals.accidentalFlat.codepoint,
      ),
    );
  }
}

class KeySignature extends StatelessWidget {
  static const _spaceBetweenAccidentals = 6.0;
  static const _verticalOffsetPerPosition =
      NotationLayoutProperties.staveSpace / 2;

  static const _sharpSequence = [
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.F, alter: 1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.C, alter: 1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.G, alter: 1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.D, alter: 1)),
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.A, alter: 1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.E, alter: 1)),
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.B, alter: 1)),
  ];

  static const _flatSequence = [
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.B, alter: -1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.E, alter: -1)),
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.A, alter: -1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.D, alter: -1)),
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.G, alter: -1)),
    (octave: 5, accidental: PitchedKeyAccidental(step: Step.C, alter: -1)),
    (octave: 4, accidental: PitchedKeyAccidental(step: Step.F, alter: -1)),
  ];

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
    for (var _ in accidentals) {
      Size accidentalSize = const KeySignatureAccidental(
        type: AccidentalValue.flat,
      ).size;

      offsets.add(leftOffset);
      leftOffset += accidentalSize.width + _spaceBetweenAccidentals;
    }
    return offsets;
  }

  ({ElementPosition lowest, ElementPosition highest})? get _range {
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

  Size get size {
    var tallestAccidental = 0.0;
    var width = 0.0;

    int range = _range!.highest.numeric - _range!.lowest.numeric;

    if (accidentals.isEmpty) {
      return const Size(0, 0);
    }

    for (var accidental in accidentals) {
      var accidentalPosition = _accidentalPosition(accidental);

      Size accidentalSize = const KeySignatureAccidental(
        type: AccidentalValue.flat,
      ).size;

      if (_range!.highest == accidentalPosition) {
        tallestAccidental = accidentalSize.height;
      }

      width += accidentalSize.width + _spaceBetweenAccidentals;
    }

    return Size(
      width - _spaceBetweenAccidentals,
      tallestAccidental * 1.30 + range * _verticalOffsetPerPosition,
    );
  }

  ElementPosition? get firstPosition => accidentals.firstOrNull != null
      ? _accidentalPosition(accidentals.first)
      : null;

  const KeySignature({
    super.key,
    required this.accidentals,
  });

  factory KeySignature.fromKeyData({Key? key, required musicxml.Key keyData}) {
    var accidentals = <({int octave, PitchedKeyAccidental accidental})>[];

    switch (keyData) {
      case TraditionalKey _:
        if (keyData.fifths == 0) {
          return const KeySignature(accidentals: []);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var (index, accidental) in accidentals.indexed) {
      var accidentalWidget = const KeySignatureAccidental(
        type: AccidentalValue.flat,
      );

      int fromLowest =
          _accidentalPosition(accidental).numeric - _range!.lowest.numeric;

      children.add(
        Positioned(
          bottom: ((fromLowest + 2) * _verticalOffsetPerPosition) - 3,
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
