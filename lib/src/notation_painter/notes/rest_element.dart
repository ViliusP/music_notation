import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dot.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class RestElement extends StatelessWidget implements RhythmicElement {
  final Note note;

  @override
  final NotationContext notationContext;

  final FontMetadata font;

  @override
  AlignmentPosition get alignmentPosition {
    return AlignmentPosition(left: 0, top: -_verticalAlignmentAxisOffset);
  }

  @override
  // TODO: implement alignmentPositionV2
  AlignmentPositionV2 get alignmentPositionV2 {
    double alignment = _bBox.bBoxNE.y;
    if (_dots > 0) {
      double maybeDotOffset = alignment;
      maybeDotOffset -= AugmentationDot(
            count: 1,
            font: font,
          ).alignmentPositionV2.top ??
          0;
      maybeDotOffset -= 1 / 2;
      if (maybeDotOffset < 0) {
        alignment -= maybeDotOffset;
      }
    }

    return AlignmentPositionV2(
      left: 0,
      top: alignment,
    );
  }

  GlyphBBox get _bBox {
    return font.glyphBBoxes[_glyph]!;
  }

  double get _verticalAlignmentAxisOffset {
    double alignment = _bBox.topOffset;
    if (_dots > 0) {
      double maybeDotOffset = alignment;
      maybeDotOffset -= AugmentationDot(
            count: 1,
            font: font,
          ).alignmentPosition.top ??
          0;
      maybeDotOffset -= NotationLayoutProperties.defaultStaveSpace / 2;
      if (maybeDotOffset < 0) {
        alignment -= maybeDotOffset;
      }
    }
    return alignment;
  }

  @override
  double get duration => note.determineDuration();

  @override
  Offset get offsetForBeam => Offset.zero;

  @override
  StemDirection? get stemDirection => null;

  @override
  double get stemLength => 0;

  @override
  ElementPosition get position => _determinePosition();

  @override
  Size get size {
    Size restSymbolSize = _bBox.toRect().size;
    double width = restSymbolSize.width;
    double height = restSymbolSize.height;
    if (_dots > 0) {
      width += AugmentationDot.defaultOffset;
      var dots = AugmentationDot(count: _dots, font: font);
      width += dots.size.width;

      if (_dotsVerticalOffset < 0) {
        height += _dotsVerticalOffset.abs();
      }
    }
    return Size(width, height);
  }

  int get _dots {
    return note.dots.length;
  }

  double get _dotsVerticalOffset {
    // Alignment line of rest.
    double top = NotationLayoutProperties.defaultStaveSpace * _bBox.bBoxNE.y;

    top -= AugmentationDot(
          count: 1,
          font: font,
        ).alignmentPosition.top ??
        0;
    top -= NotationLayoutProperties.defaultStaveSpace / 2;
    return top;
  }

  NoteTypeValue get _type {
    NoteTypeValue? type = note.type?.value;

    NoteForm noteForm = note.form;
    if ((noteForm as Rest).measure == true) {
      type = NoteTypeValue.whole;
    }
    return type ?? NoteTypeValue.quarter;
  }

  SmuflGlyph get _glyph => _determineGlyph(_type, position);

  factory RestElement.fromNote({
    required Note note,
    required NotationContext context,
    required FontMetadata font,
  }) {
    return RestElement._(
      note: note,
      notationContext: context,
      font: font,
    );
  }

  const RestElement._({
    required this.note,
    required this.notationContext,
    required this.font,
  });

  bool get isMeasure => (note.form as Rest).measure == true;

  static SmuflGlyph _determineGlyph(NoteTypeValue type, ElementPosition pos) {
    switch (type) {
      case NoteTypeValue.n1024th:
        return SmuflGlyph.rest1024th;
      case NoteTypeValue.n512th:
        return SmuflGlyph.rest512th;
      case NoteTypeValue.n256th:
        return SmuflGlyph.rest256th;
      case NoteTypeValue.n128th:
        return SmuflGlyph.rest128th;
      case NoteTypeValue.n64th:
        return SmuflGlyph.rest64th;
      case NoteTypeValue.n32nd:
        return SmuflGlyph.rest32nd;
      case NoteTypeValue.n16th:
        return SmuflGlyph.rest16th;
      case NoteTypeValue.eighth:
        return SmuflGlyph.rest8th;
      case NoteTypeValue.quarter:
        return SmuflGlyph.restQuarter;
      case NoteTypeValue.half:
        if (pos.numeric >= ElementPosition.firstLedgerAbove.numeric) {
          return SmuflGlyph.restHalfLegerLine;
        }
        if (pos.numeric <= ElementPosition.secondLedgerBelow.numeric) {
          return SmuflGlyph.restHalfLegerLine;
        }
        return SmuflGlyph.restHalf;
      case NoteTypeValue.whole:
        if (pos.numeric >= ElementPosition.firstLedgerAbove.numeric) {
          return SmuflGlyph.restWholeLegerLine;
        }
        if (pos.numeric <= ElementPosition.secondLedgerBelow.numeric) {
          return SmuflGlyph.restWholeLegerLine;
        }
        return SmuflGlyph.restWhole;
      case NoteTypeValue.breve:
        return SmuflGlyph.restDoubleWhole;
      case NoteTypeValue.long:
        return SmuflGlyph.restLonga;
      case NoteTypeValue.maxima:
        return SmuflGlyph.restMaxima;
    }
  }

  ElementPosition _determinePosition() {
    Step? step = (note.form as Rest).displayStep;
    int? octave = (note.form as Rest).displayOctave;

    if (step != null && octave != null) {
      ElementPosition pos = ElementPosition(step: step, octave: octave);
      if (notationContext.clef != null) {
        pos = pos.transpose(ElementPosition.transposeIntervalByClef(
          notationContext.clef!,
        ));
      }
      return pos;
    }

    switch (_type) {
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
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          if (_dots > 0)
            Positioned(
              top: _dotsVerticalOffset.clamp(0, double.maxFinite),
              right: 0,
              child: AugmentationDot(count: _dots, font: font),
            ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CustomPaint(
              size: _bBox.toRect().size,
              painter: SimpleGlyphPainter(_glyph.codepoint, _bBox),
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
