import 'dart:ui';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/layout.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_music_element.dart';

class VisualNoteElement extends VisualMusicElement {
  final NoteTypeValue type;
  final bool stemmed;
  final String? flagUpSymbol;
  final String? flagDownSymbol;

  /// Width of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 sembreves to 3 black
  /// noteheads).
  final double noteheadWidth;

  final double? voice;

  @override
  HorizontalMargins? get defaultMargins => null;

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

  VisualNoteElement._({
    required this.flagUpSymbol,
    required this.flagDownSymbol,
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
    required this.stemmed,
    required super.influencedByClef,
    required this.noteheadWidth,
    required this.type,
    this.voice,
  });

  VisualNoteElement.stemmed({
    required this.flagUpSymbol,
    required this.flagDownSymbol,
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
    required super.influencedByClef,
    required this.noteheadWidth,
    required this.type,
    this.voice,
  }) : stemmed = true;

  VisualNoteElement.noStem({
    required super.symbol,
    required super.position,
    super.defaultOffsetG4,
    required super.influencedByClef,
    required this.noteheadWidth,
    required this.type,
    this.voice,
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
        bool influencedByClef = true;
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
            influencedByClef = false;
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
            influencedByClef: influencedByClef,
            noteheadWidth: note.type?.value.noteheadWidth ??
                NoteTypeValue.quarter.noteheadWidth,
            type: note.type?.value ?? NoteTypeValue.eighth,
          );
        }

        return VisualNoteElement.noStem(
          symbol: symbol,
          position: notePosition,
          defaultOffsetG4: const Offset(0, -5),
          influencedByClef: influencedByClef,
          noteheadWidth: note.type?.value.noteheadWidth ??
              NoteTypeValue.quarter.noteheadWidth,
          type: note.type?.value ?? NoteTypeValue.eighth,
        );

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }

  VisualNoteElement noteCopyWith({
    String? symbol,
    ElementPosition? position,
    bool? stemmed,
    String? flagUpSymbol,
    String? flagDownSymbol,
    Offset? defaultOffsetG4,
    bool? influencedByClef,
  }) =>
      VisualNoteElement._(
        symbol: symbol ?? this.symbol,
        position: position ?? this.position,
        defaultOffsetG4: defaultOffsetG4 ?? defaultOffset,
        flagUpSymbol: flagUpSymbol ?? this.flagUpSymbol,
        flagDownSymbol: flagDownSymbol ?? this.flagDownSymbol,
        stemmed: stemmed ?? this.stemmed,
        influencedByClef: influencedByClef ?? this.influencedByClef,
        noteheadWidth: noteheadWidth,
        type: type ?? NoteTypeValue.eighth,
      );
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
