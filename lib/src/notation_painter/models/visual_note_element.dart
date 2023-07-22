import 'dart:ui';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';

class VisualNoteElement extends VisualMusicElement {
  final StemValue stemDirection;
  final String? flagUpSymbol;
  final String? flagDownSymbol;

  /// Ledger line count. Minus value means that ledger lines are under staff. Positive
  /// value means that ledger lines are above staff.
  int get ledgerLines {
    int position = this.position.numericPosition;
    int distance = 0;

    // 29 - D in 4 octave.
    // 39 - G in 5 octave.
    if (position < 29) {
      distance = (29 - position);

      return -(distance / 2).ceil();
    }

    if (position > 39) {
      distance = position - 39;
    }

    return (distance / 2).ceil();
  }

  static const ElementPosition _staffMiddle = ElementPosition(
    step: Step.B,
    octave: 4,
  );

  VisualNoteElement.stemmed({
    required this.stemDirection,
    required this.flagUpSymbol,
    required this.flagDownSymbol,
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
  });

  VisualNoteElement.noStem({
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
  })  : stemDirection = StemValue.none,
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
          var calculatedStemDirection =
              notePosition >= _staffMiddle ? StemValue.down : StemValue.up;

          return VisualNoteElement.stemmed(
            symbol: symbol,
            position: notePosition,
            defaultOffsetG4: const Offset(0, -5),
            flagDownSymbol: note.type!.value.downwardFlag,
            flagUpSymbol: note.type!.value.upwardFlag,
            stemDirection: note.stem?.value ?? calculatedStemDirection,
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
