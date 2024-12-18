import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

class RestElement extends StatelessWidget {
  final NoteTypeValue type;

  final AugmentationDots? dots;

  final ElementPosition position;

  final FontMetadata font;

  final String? voice;

  factory RestElement.fromNote({
    required Note note,
    required Clef? clef,
    required FontMetadata font,
  }) {
    AugmentationDots? dots;
    if (note.dots.isNotEmpty) {
      dots = AugmentationDots(count: note.dots.length, font: font);
    }

    return RestElement._(
      type: _determineType(note),
      font: font,
      dots: dots,
      position: _determinePosition(note, clef),
      voice: note.editorialVoice.voice,
      isMeasure: (note.form as Rest).measure == true,
    );
  }

  const RestElement._({
    required this.type,
    required this.position,
    required this.font,
    this.dots,
    this.voice,
    this.isMeasure = false,
  });

  Alignment get alignment {
    if (dots == null) return _bBox.toAlignment();

    var range = [
      MeasureElementLayoutData(
        size: dots!.size,
        position: position + _dotsPositionIncrease,
        alignment: dots!.alignment,
      ),
      MeasureElementLayoutData(
        size: _bBox.toSize(),
        position: position,
        alignment: _bBox.toAlignment(),
      ),
    ].columnVerticalRange(
      NotationLayoutProperties.baseSpacePerPosition,
      position,
    );

    return Alignment(
        0,
        MeasureElementLayoutData.calculateSingleAxisAlignment(
          range.min,
          range.max,
          Axis.vertical,
        ));
  }

  GlyphBBox get _bBox {
    return font.glyphBBoxes[_glyph]!;
  }

  int get _dotsPositionIncrease => switch (position.numeric % 2 == 0) {
        true => 1,
        false => 0,
      };

  final bool isMeasure;

  Size get size {
    Size restSize = _bBox.toSize();
    if (dots == null) return restSize;
    Rect dotRect = Offset.zero & dots!.size;
    dotRect = dotRect.shift(Offset(
      restSize.width + AugmentationDots.defaultBaseOffset,
      _dotsVerticalOffset,
    ));

    return (Offset.zero & restSize).expandToInclude(dotRect).size;
  }

  double get _dotsVerticalOffset {
    Size restSize = _bBox.toSize();
    Rect dotRect = Offset.zero & dots!.size;

    return restSize.height / 2 -
        dotRect.height / 2 +
        -_dotsPositionIncrease * 1 / 2;
  }

  SmuflGlyph get _glyph => _determineGlyph(type, position);

  static NoteTypeValue _determineType(Note note) {
    NoteTypeValue? type = note.type?.value;

    NoteForm noteForm = note.form;
    if ((noteForm as Rest).measure == true) {
      type = NoteTypeValue.whole;
    }
    return type ?? NoteTypeValue.quarter;
  }

  static SmuflGlyph _determineGlyph(NoteTypeValue type, ElementPosition pos) {
    bool hasLedgerLines = !pos.betweenLedgers;

    return switch (type) {
      NoteTypeValue.n1024th => SmuflGlyph.rest1024th,
      NoteTypeValue.n512th => SmuflGlyph.rest512th,
      NoteTypeValue.n256th => SmuflGlyph.rest256th,
      NoteTypeValue.n128th => SmuflGlyph.rest128th,
      NoteTypeValue.n64th => SmuflGlyph.rest64th,
      NoteTypeValue.n32nd => SmuflGlyph.rest32nd,
      NoteTypeValue.n16th => SmuflGlyph.rest16th,
      NoteTypeValue.eighth => SmuflGlyph.rest8th,
      NoteTypeValue.quarter => SmuflGlyph.restQuarter,
      NoteTypeValue.half when hasLedgerLines => SmuflGlyph.restHalfLegerLine,
      NoteTypeValue.half => SmuflGlyph.restHalf,
      NoteTypeValue.whole when hasLedgerLines => SmuflGlyph.restWholeLegerLine,
      NoteTypeValue.whole => SmuflGlyph.restWhole,
      NoteTypeValue.breve => SmuflGlyph.restDoubleWhole,
      NoteTypeValue.long => SmuflGlyph.restLonga,
      NoteTypeValue.maxima => SmuflGlyph.restMaxima,
    };
  }

  static ElementPosition _determinePosition(Note note, Clef? clef) {
    Step? step = (note.form as Rest).displayStep;
    int? octave = (note.form as Rest).displayOctave;

    if (step != null && octave != null) {
      ElementPosition pos = ElementPosition(step: step, octave: octave);
      if (clef != null) {
        pos = pos.transpose(clef.transposeInterval);
      }
      return pos;
    }

    switch (_determineType(note)) {
      case NoteTypeValue.n1024th:
      case NoteTypeValue.n512th:
      case NoteTypeValue.n256th:
      case NoteTypeValue.n128th:
      case NoteTypeValue.n64th:
      case NoteTypeValue.n32nd:
      case NoteTypeValue.n16th:
      case NoteTypeValue.eighth:
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
        return const ElementPosition(step: Step.B, octave: 4);
      case NoteTypeValue.whole:
        return const ElementPosition(step: Step.D, octave: 5);
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return const ElementPosition(step: Step.E, octave: 5); // TODO: adjust
    }
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Stack(
        children: [
          if (dots != null)
            Positioned(
              top: _dotsVerticalOffset
                  .scaledByContext(context)
                  .clamp(0, double.maxFinite),
              right: 0,
              child: dots!,
            ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CustomPaint(
              size: _bBox.toRect(layoutProperties.staveSpace).size,
              painter: SimpleGlyphPainter(
                _glyph.codepoint,
                _bBox,
                layoutProperties.staveSpace,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// /// Calculates the appropriate [NoteTypeValue] based on the given note's [duration]
// /// and the [divisions] specified by the time signature.
// ///
// /// The function determines the [duration] of the note relative to the [divisions]
// /// and matches it to a corresponding [NoteTypeValue] based on predefined
// /// ratio ranges. If no exact match is found, the closest [NoteTypeValue] is selected.
// /// If the note duration significantly exceeds the [divisions], it defaults to [NoteTypeValue.maxima].
// static NoteTypeValue calculateNoteType(double duration, double divisions) {
//   // Calculate the ratio of note's duration to divisions
//   final ratio = duration / divisions;

//   // Define a map that relates ratio ranges to NoteTypeValue
//   final ratioToNoteTypeMap = {
//     1 / 256: NoteTypeValue.n1024th,
//     1 / 128: NoteTypeValue.n512th,
//     1 / 64: NoteTypeValue.n256th,
//     1 / 32: NoteTypeValue.n128th,
//     1 / 16: NoteTypeValue.n64th,
//     1 / 8: NoteTypeValue.n32nd,
//     1 / 4: NoteTypeValue.n16th,
//     1 / 2: NoteTypeValue.eighth,
//     1 / 1: NoteTypeValue.quarter,
//     2: NoteTypeValue.half,
//     4: NoteTypeValue.whole,
//     8: NoteTypeValue.breve,
//     16: NoteTypeValue.long,
//     32: NoteTypeValue.maxima,
//   };

//   // Find the appropriate NoteTypeValue based on the ratio
//   NoteTypeValue? noteType;
//   ratioToNoteTypeMap.forEach((ratioRange, type) {
//     if (ratio <= ratioRange) {
//       noteType = type;
//       return;
//     }
//   });

//   // Default to maxima if the note duration is larger than 8 times the divisions
//   noteType ??= NoteTypeValue.maxima;

//   return noteType!;
// }

// /// Determines the appropriate note type value based on the note's properties.
// ///
// /// If the note has an explicit type value defined, that value is returned.
// /// If the note is a complete measure rest (or a voice within a measure),
// /// it is considered a whole note regardless of the time signature.
// /// Otherwise, the note type is calculated based on its duration and divisions.
// ///
// /// Returns the determined [NoteTypeValue] for the note.
// static NoteTypeValue _type(Note note, double divisions) {
//   if (note.type?.value != null) {
//     return note.type!.value;
//   }
//   if (note.form is Rest && (note.form as Rest).measure == true) {
//     return NoteTypeValue.whole;
//   }

//   return calculateNoteType((note as RegularNote).duration, divisions);
// }
