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
import 'package:music_notation/src/notation_painter/music_sheet/measure_row.dart';
import 'package:music_notation/src/notation_painter/music_sheet/music_element.dart';
import 'package:music_notation/src/notation_painter/properties/constants.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

const Map<String, Color> _voiceColors = {
  "0": Color.fromRGBO(0, 0, 0, 1),
  "1": Color.fromRGBO(121, 0, 0, 1),
  "2": Color.fromRGBO(0, 133, 40, 1),
  "3": Color.fromRGBO(206, 192, 0, 1),
};

class NoteElement extends StatelessWidget {
  final NoteheadElement head;
  final StemElement? stem;
  final AccidentalElement? accidental;
  final AugmentationDots? dots;
  final ElementPosition position;

  const NoteElement({
    super.key,
    required this.head,
    this.beams,
    this.accidental,
    this.dots,
    this.voice,
    this.stem,
    required this.position,
  });

  final String? voice;

  final List<Beam>? beams;

  /// Create [NoteElement] from musicXML [note].
  factory NoteElement.fromNote({
    Key? key,
    required Note note,
    required FontMetadata font,
    Clef? clef,
  }) {
    ElementPosition position = determinePosition(note, clef);

    AccidentalElement? accidental;
    if (note.accidental != null) {
      accidental = AccidentalElement(
        type: note.accidental!.value,
        font: font,
      );
    }

    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    StemElement? stemElement;
    StemDirection? stemDirection = note.stem == null
        ? null
        : StemDirection.fromStemValue(note.stem!.value);

    if (stemDirection != null) {
      stemElement = StemElement(
        type: type,
        font: font,
        length: StemElement.calculateStemLength(note, position),
        showFlag: note.beams.isEmpty,
        direction: stemDirection,
      );
    }

    AugmentationDots? dots;
    if (note.dots.isNotEmpty) {
      dots = AugmentationDots(count: note.dots.length, font: font);
    }
    var notehead = NoteheadElement(
      type: type,
      font: font,
      ledgerLines: LedgerLines.fromElementPosition(position),
    );
    return NoteElement(
      key: key,
      head: notehead,
      dots: dots,
      accidental: accidental,
      stem: stemElement,
      voice: note.editorialVoice.voice,
      beams: note.beams.isEmpty ? [] : note.beams,
      position: position,
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
        return position.transpose(clef.transposeInterval);

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }

  List<MeasureElement> get _children {
    var direction = stem?.direction;

    MeasureElement? measureStem;
    if (stem != null) {
      measureStem = MeasureElement(
        position: position,
        size: stem!.size,
        offset: stem!.offset,
        duration: 0,
        child: stem!,
      );
    }

    return [
      if (accidental != null)
        MeasureElement(
          position: position,
          size: accidental!.size,
          offset: accidental!.offset,
          duration: 0,
          child: accidental!,
        ),
      if (stem != null && direction == StemDirection.down) measureStem!,
      MeasureElement(
        position: position,
        size: head.size,
        offset: head.offset,
        duration: 0,
        child: head,
      ),
      if (stem != null && direction == StemDirection.up) measureStem!,
      if (dots != null)
        MeasureElement(
          position: position,
          size: dots!.size,
          offset: dots!.offset,
          duration: 0,
          child: dots!,
        ),
    ];
  }

  Size get size {
    double height = MeasureElementLayoutData.columnVerticalRange(
      _children,
    ).distance;
    double width = head.size.width;

    if (dots != null) {
      Size dotsSize = dots!.size;

      width += dotsSize.width;
      width += AugmentationDots.defaultBaseOffset;
    }
    if (accidental != null) {
      Size accidentalSize = accidental!.size;

      width += accidentalSize.width;
      // Space between notehead and accidental.
      width += NotationLayoutProperties.noteAccidentalDistance;
    }

    return Size(width, height);
  }

  static const double _dotOffsetAdjustment = 0.1;

  AlignmentOffset get offset {
    {
      double left = 0;

      if (accidental != null) {
        left -= accidental!.size.width;
        left -= NotationLayoutProperties.noteAccidentalDistance;
      }

      return AlignmentOffset.fromBottom(
        height: size.height,
        bottom: MeasureElementLayoutData.columnVerticalRange(_children).min,
        left: left,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: MeasureRow(
        children: _children,
      ),
    );
  }
}

extension ClefExtension on Clef {
  /// The number of positions to transpose a note based on the [Clef].
  ///
  /// The calculation considers the clef's sign and optional octave change.
  /// Unsupported clef signs throw an [UnimplementedError].
  ///
  /// Example:
  /// ```dart
  /// final clef = Clef(sign: ClefSign.G, octaveChange: -1);
  /// print(clef.transposeInterval); // -7
  /// ```
  ///
  /// Throws:
  /// - [UnimplementedError] for unsupported clef signs.
  int get transposeInterval {
    int interval = switch (sign) {
      ClefSign.G => 0,
      ClefSign.F => 12,
      ClefSign.C => throw UnimplementedError(
          "ClefSign.C is transpose is not implemented yet",
        ),
      ClefSign.percussion => throw UnimplementedError(
          "ClefSign.percussion is transpose is not implemented yet",
        ),
      ClefSign.tab => throw UnimplementedError(
          "ClefSign.tab is transpose is not implemented yet",
        ),
      ClefSign.jianpu => throw UnimplementedError(
          "ClefSign.jianpu is transpose is not implemented yet",
        ),
      ClefSign.none => throw UnimplementedError(
          "ClefSign.none is transpose is not implemented yet",
        ),
    };

    interval -= (octaveChange ?? 0) * NotationConstants.notesPerOctave;
    return interval;
  }
}
