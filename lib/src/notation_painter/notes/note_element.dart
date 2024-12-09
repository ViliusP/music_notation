import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

const Map<String, Color> _voiceColors = {
  "0": Color.fromRGBO(0, 0, 0, 1),
  "1": Color.fromRGBO(121, 0, 0, 1),
  "2": Color.fromRGBO(0, 133, 40, 1),
  "3": Color.fromRGBO(206, 192, 0, 1),
};

/// Notes below line 3 have up stems on the right side of the notehead.
///
/// Notes on or above line 3 have down stems on the left side of the notehead.
///
/// The stem is always placed between the two notes of an interval of a 2nd,
/// with the upper note always to the right, the lower note always to the left.
///
/// When two notes share a stem:
/// - If the interval above the middle line is greater, the stem goes down;
/// - If the interval below the middle line is greater, the stem goes up;
/// - If the intervals above and below the middle ine are equidistant, the stem
/// goes down;
///
/// When more than two notes share a stem, the direction is determined by the
/// highest and the lowest notes:
/// - If the interval from the highest note to the middle line is greater,
/// the stem goes down;
/// - If the interval from the lowest note to the middle line is greater, the
/// stem goes up;
/// - If equidistant the stem goes down.
///
/// If you are writing two voices on the same staff, the stems for the upper
/// voice will go up, and the stems for the lower voice will go down.
class NoteElement extends StatelessWidget {
  final StemlessNoteElement base;

  final StemElement? stem;

  ElementPosition get position => base.position;

  final String? voice;

  final List<Beam> beams;

  /// Create [NoteElement] from musicXML [note].
  factory NoteElement.fromNote({
    Key? key,
    required Note note,
    required FontMetadata font,
    Clef? clef,
    double? stemLength,
    bool showFlag = true,
    bool showLedger = true,
  }) {
    AccidentalElement? accidental;
    if (note.accidental != null) {
      accidental = AccidentalElement(
        type: note.accidental!.value,
        font: font,
      );
    }

    ElementPosition position = determinePosition(note, clef);

    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    StemElement? stem;
    StemDirection? stemDirection = note.stem == null
        ? null
        : StemDirection.fromStemValue(note.stem!.value);

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: stemLength ?? StemElement.calculateStemLength(note, position),
        showFlag: note.beams.isEmpty && showFlag,
        direction: stemDirection,
      );
    }

    AugmentationDots? dots;
    if (note.dots.isNotEmpty) {
      dots = AugmentationDots(count: note.dots.length, font: font);
    }

    return NoteElement(
      key: key,
      base: StemlessNoteElement(
        dots: dots,
        accidental: accidental,
        head: NoteheadElement(
          type: type,
          font: font,
          ledgerLines: LedgerLines.fromElementPosition(position),
        ),
        position: position,
      ),
      stem: stem,
      voice: note.editorialVoice.voice,
      beams: note.beams,
    );
  }

  const NoteElement({
    super.key,
    required this.base,
    this.voice,
    this.beams = const [],
    this.stem,
  });

  AlignmentPosition get alignmentPosition {
    AlignmentPosition basePosition = base.alignmentPosition;

    if (stem?.direction == StemDirection.down) {
      return AlignmentPosition(
        left: basePosition.left,
        top: basePosition.bottom!.abs() - base.size.height,
      );
    }
    return basePosition;
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  Offset? get offsetForBeam {
    if (stem == null) {
      return null;
    }
    return Offset(
      _stemAlignment!.left,
      size.height,
    );
  }

  static ElementPosition determinePosition(Note note, Clef? clef) {
    switch (note) {
      case GraceTieNote _:
        throw UnimplementedError(
          "Grace tie note is not implemented yet in renderer",
        );
      case GraceCueNote _:
        throw UnimplementedError(
          "Grace cue note is not implemented yet in renderer",
        );
      case CueNote _:
        throw UnimplementedError(
          "Cue note is not implemented yet in renderer",
        );
      case RegularNote _:
        NoteForm noteForm = note.form;
        Step? step;
        int? octave;
        switch (noteForm) {
          case Pitch _:
            step = noteForm.step;
            octave = noteForm.octave;
            // step = Step.B;
            // octave = 4;
            break;
          case Unpitched _:
            step = noteForm.displayStep;
            octave = noteForm.displayOctave;
          case Rest _:
            throw ArgumentError(
              "If note's form is `rest`, please use RestElemenent to render it",
            );
        }

        final position = ElementPosition(
          step: step,
          octave: octave,
        );

        if (clef == null) {
          return position;
        }

        // Unpitched notes probably shouldn't be transposed;
        return position.transpose(ElementPosition.transposeIntervalByClef(
          clef,
        ));

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }

  Size get size {
    double height = base.size.height;

    if (stem != null) {
      height = stem!.length;
      if (stem!.direction == StemDirection.up) {
        height += base.alignmentPosition.bottom!.abs();
      }
      if (stem!.direction == StemDirection.down) {
        height += base.size.height - base.alignmentPosition.bottom!.abs();
      }
    }

    double width = base.size.width;

    return Size(width, height);
  }

  /// Calculates position for stem - relative position by
  /// component's left, bottom/top bounding box sides that is determined by [size].
  AlignmentPosition? get _stemAlignment {
    if (stem == null) {
      return null;
    }

    double left = 0;
    double? top;
    double? bottom;
    if (base.accidental != null) {
      left += base.accidental!.size.width;
      left += NotationLayoutProperties.noteAccidentalDistance;
    }
    if (stem?.direction == StemDirection.down) {
      left += StemElement.defaultHorizontalOffset;
      bottom = 0;
    }
    if (stem?.direction == StemDirection.up) {
      left += base.head.size.width;
      left -= StemElement.defaultHorizontalOffset;
      top = 0;
    }

    return AlignmentPosition(
      left: left,
      top: top,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    Alignment baseAlignment = Alignment.topCenter;
    if (stem?.direction == StemDirection.up) {
      baseAlignment = Alignment.bottomCenter;
    }

    return SizedBox.fromSize(
        size: size.scaledByContext(context),
        child: Stack(
          children: [
            Align(
              alignment: baseAlignment,
              child: base,
            ),
            if (stem != null)
              AlignmentPositioned(
                position: _stemAlignment!.scaledByContext(context),
                child: stem!,
              ),
          ],
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level = DiagnosticLevel.info;

    properties.add(
      StringProperty(
        'Position',
        position.toString(),
        defaultValue: null,
        level: level,
        showName: true,
      ),
    );
  }
}
