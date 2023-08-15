import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';

class Chord extends StatelessWidget {
  final List<Note> notes;
  final double divisions;

  const Chord({
    super.key,
    required this.notes,
    required this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notes
          .map((e) => NoteElement(
                note: e,
                divisions: divisions,
              ))
          .toList(),
    );
  }
}

class NoteElement extends StatelessWidget {
  // final NoteTypeValue type;
  // final bool stemmed;
  // final String? flagUpSymbol;
  // final String? flagDownSymbol;

  /// Width of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 sembreves to 3 black
  /// noteheads).
  // final double noteheadWidth;

  // final double? voice;

  // @override
  // HorizontalMargins? get defaultMargins => null;

  // /// Ledger line count. Minus value means that ledger lines are under staff. Positive
  // /// value means that ledger lines are above staff.
  // int get ledgerLines {
  //   int position = this.position.numericPosition;
  //   int distance = 0;
  //   const d4 = ElementPosition(octave: 4, step: Step.D);
  //   const g5 = ElementPosition(octave: 5, step: Step.G);

  //   // 39 - G in 5 octave.
  //   if (position < d4.numericPosition) {
  //     distance = (d4.numericPosition - position);

  //     return -(distance / 2).ceil();
  //   }

  //   if (position > g5.numericPosition) {
  //     distance = position - g5.numericPosition;
  //   }

  //   return (distance / 2).ceil();
  // }

  final Note note;
  final double divisions;

  bool get influencedByClef {
    return note.form is! Rest;
  }

  ElementPosition get position {
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
            break;
          case Unpitched _:
            step = noteForm.displayStep;
            octave = noteForm.displayOctave;
          case Rest _:
            step = noteForm.displayStep ?? Step.C;
            octave = noteForm.displayOctave ?? 4;
            break;
        }
        return ElementPosition(
          step: step,
          octave: octave,
        );

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
    // return null;
  }

  // static efault

  const NoteElement({
    super.key,
    required this.note,
    required this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    // String? symbol = note.type?.value.smuflSymbol;
    // symbol ??= "\uE4E3";

    bool stemmed = note.type?.value.stemmed ?? false;
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Notehead(
          type: type,
          stemmed: stemmed,
        ),
        if (stemmed)
          Padding(
            padding: const EdgeInsets.only(
              bottom: NotationLayoutProperties.noteheadHeight / 2,
            ),
            child: Stem(
              type: type,
            ),
          )
      ],
    );
  }
}

/// Painting noteheads, it should fill the space between two lines, touching
/// the stave-line on each side of it, but without extending beyond either line.
///
/// Notes on a line should be precisely centred on the stave-line.
class Notehead extends StatelessWidget {
  final NoteTypeValue type;

  /// If note are stemmed, notehead's width will be reduced for aesthetics.
  final bool stemmed;

  const Notehead({super.key, required this.type, required this.stemmed});

  @override
  Widget build(BuildContext context) {
    double notesWidth = type.noteheadWidth;

    if (stemmed) {
      notesWidth -= NotationLayoutProperties.stemStrokeWidth;
    }

    Size size = Size(
      notesWidth,
      NotationLayoutProperties.noteheadHeight,
    );

    return CustomPaint(
      size: size,
      painter: NotePainter(type.smuflSymbol),
    );
  }
}

class Stem extends StatelessWidget {
  final NoteTypeValue type;
  final double height;

  const Stem({
    super.key,
    required this.type,
    this.height = NotationLayoutProperties.standardStemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(StemPainter.strokeWidth + type.flagWidth, height),
      painter: StemPainter(
        flagSmufl: type.upwardFlag,
      ),
    );
  }
}

enum LedgerPlacement {
  above,
  below;
}

extension NoteVisualInformation on NoteTypeValue {
  String get smuflSymbol {
    switch (this) {
      case NoteTypeValue.n1024th:
      case NoteTypeValue.n512th:
      case NoteTypeValue.n256th:
      case NoteTypeValue.n128th:
      case NoteTypeValue.n64th:
      case NoteTypeValue.n32nd:
      case NoteTypeValue.n16th:
      case NoteTypeValue.eighth:
      case NoteTypeValue.quarter:
        return '\uE0A4'; // black note head.
      case NoteTypeValue.half:
        return '\uE0A3'; // minim.
      case NoteTypeValue.whole:
        return '\uE0A2'; // semibreve.
      case NoteTypeValue.breve:
        return '\uE0A0';
      case NoteTypeValue.long:
        return '\uE0A1';
      case NoteTypeValue.maxima:
        return '\uE0A1';
    }
  }

  double get noteheadWidth {
    switch (this) {
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
        return 16;
      case NoteTypeValue.whole:
        return 21.2;
      case NoteTypeValue.breve:
        return 30; // Need to be adjusted in future.
      case NoteTypeValue.long:
        return 30; // Need to be adjusted in future.
      case NoteTypeValue.maxima:
        return 30; // Need to be adjusted in future.
    }
  }

  bool get stemmed {
    switch (this) {
      case NoteTypeValue.n1024th:
        return true;
      case NoteTypeValue.n512th:
        return true;
      case NoteTypeValue.n256th:
        return true;
      case NoteTypeValue.n128th:
        return true;
      case NoteTypeValue.n64th:
        return true;
      case NoteTypeValue.n32nd:
        return true;
      case NoteTypeValue.n16th:
        return true;
      case NoteTypeValue.eighth:
        return true;
      case NoteTypeValue.quarter:
        return true;
      case NoteTypeValue.half:
        return true;
      case NoteTypeValue.whole:
        return false;
      case NoteTypeValue.breve:
        return false;
      case NoteTypeValue.long:
        return false;
      case NoteTypeValue.maxima:
        return false;
    }
  }

  String? get upwardFlag {
    switch (this) {
      case NoteTypeValue.n1024th:
        return '\uE24E';
      case NoteTypeValue.n512th:
        return '\uE24C';
      case NoteTypeValue.n256th:
        return '\uE24A';
      case NoteTypeValue.n128th:
        return '\uE248';
      case NoteTypeValue.n64th:
        return '\uE246';
      case NoteTypeValue.n32nd:
        return '\uE244';
      case NoteTypeValue.n16th:
        return '\uE242';
      case NoteTypeValue.eighth:
        return '\uE240';
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return null;
    }
  }

  int get flagWidth {
    switch (this) {
      case NoteTypeValue.n1024th:
        return 13;
      case NoteTypeValue.n512th:
        return 13;
      case NoteTypeValue.n256th:
        return 13;
      case NoteTypeValue.n128th:
        return 13;
      case NoteTypeValue.n64th:
        return 13;
      case NoteTypeValue.n32nd:
        return 13;
      case NoteTypeValue.n16th:
        return 13;
      case NoteTypeValue.eighth:
        return 13;
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return 0;
    }
  }

  String? get downwardFlag {
    switch (this) {
      case NoteTypeValue.n1024th:
        return '\uE24F';
      case NoteTypeValue.n512th:
        return '\uE24D';
      case NoteTypeValue.n256th:
        return '\uE24B';
      case NoteTypeValue.n128th:
        return '\uE249';
      case NoteTypeValue.n64th:
        return '\uE247';
      case NoteTypeValue.n32nd:
        return '\uE245';
      case NoteTypeValue.n16th:
        return '\uE243';
      case NoteTypeValue.eighth:
        return '\uE241';
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return null;
    }
  }
}
