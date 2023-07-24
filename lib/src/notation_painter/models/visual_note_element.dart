import 'dart:ui';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_music_element.dart';

class VisualNoteElement extends VisualMusicElement {
  final bool stemmed;
  final String? flagUpSymbol;
  final String? flagDownSymbol;

  /// Ledger line count. Minus value means that ledger lines are under staff. Positive
  /// value means that ledger lines are above staff.
  int get ledgerLines {
    int position = this.position.numericPosition;
    int distance = 0;
    const d4 = ElementPosition(octave: 4, step: Step.D);
    const g5 = ElementPosition(octave: 5, step: Step.G);

    // 39 - G in 5 octave.
    if (position < d4.numericPosition) {
      distance = (d4.numericPosition - position);

      return -(distance / 2).ceil();
    }

    if (position > g5.numericPosition) {
      distance = position - g5.numericPosition;
    }

    return (distance / 2).ceil();
  }

  VisualNoteElement.stemmed({
    required this.flagUpSymbol,
    required this.flagDownSymbol,
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
  }) : stemmed = true;

  VisualNoteElement.noStem({
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
  })  : stemmed = false,
        flagDownSymbol = null,
        flagUpSymbol = null;

  factory VisualNoteElement.fromNote(Note note) {
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
            throw UnimplementedError(
              "Unpitched is not implemented yet in renderer",
            );
          case Rest _:
            break;
        }
        String? symbol = note.type?.value.smuflSymbol;
        symbol ??= "\uE4E3";

        var notePosition = ElementPosition(
          step: step ?? Step.C,
          octave: octave ?? 5,
        );

        if (note.type?.value.stemmed == true) {
          return VisualNoteElement.stemmed(
            symbol: symbol,
            position: notePosition,
            defaultOffsetG4: const Offset(0, -5),
            flagDownSymbol: note.type!.value.downwardFlag,
            flagUpSymbol: note.type!.value.upwardFlag,
          );
        }

        return VisualNoteElement.noStem(
          symbol: symbol,
          position: notePosition,
          defaultOffsetG4: const Offset(0, -5),
        );

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }
}

extension NoteHeadSmufl on NoteTypeValue {
  String get smuflSymbol {
    switch (this) {
      case NoteTypeValue.n1024th:
        return '\uE0A4';
      case NoteTypeValue.n512th:
        return '\uE0A4';
      case NoteTypeValue.n256th:
        return '\uE0A4';
      case NoteTypeValue.n128th:
        return '\uE0A4';
      case NoteTypeValue.n64th:
        return '\uE0A4';
      case NoteTypeValue.n32nd:
        return '\uE0A4';
      case NoteTypeValue.n16th:
        return '\uE0A4';
      case NoteTypeValue.eighth:
        return '\uE0A4';
      case NoteTypeValue.quarter:
        return '\uE0A4';
      case NoteTypeValue.half:
        return '\uE0A3';
      case NoteTypeValue.whole:
        return '\uE0A2';
      case NoteTypeValue.breve:
        return '\uE0A0';
      case NoteTypeValue.long:
        return '\uE0A1';
      case NoteTypeValue.maxima:
        return '\uE0A1';
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
