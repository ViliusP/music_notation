import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/notehead.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

class Chord extends StatelessWidget implements MeasureWidget {
  @override
  double get defaultBottomPosition => 0;

  const Chord({
    super.key,
    required this.children,
    required this.divisions,
  });

  /// **IMPORTANT**: [notes] cannot be empty.
  factory Chord.fromNotes({
    Key? key,
    required List<Note> notes,
    required NotationContext notationContext,
  }) {
    if (notes.isEmpty) {
      throw ArgumentError('notes list is empty');
    }

    if (notationContext.divisions == null) {
      throw ArgumentError(
        "Divisions in notationContext cannot be null on note's initialization",
      );
    }

    var children = _notesToChildren(
      notes: notes,
      notationContext: notationContext,
    );

    return Chord(
      key: key,
      divisions: notationContext.divisions!,
      children: children,
    );
  }

  final List<NoteElement> children;
  List<NoteElement> get _sortedNotesElements =>
      children.sortedBy((element) => element.position).reversed.toList();

  final double divisions;

  /// Calculates chord widget size from provided [notes].
  static Size _calculateSize(List<NoteElement> notes) {
    // Sorts from lowest to highest note. First being lowest.
    List<NoteElement> sortedNotesElements = notes.sortedBy(
      (element) => element.position,
    );

    int lowestPosition = sortedNotesElements.first.position.numeric;
    int highestPosition = sortedNotesElements.last.position.numeric;
    int positionDifference = highestPosition - lowestPosition;

    const heightPerPosition = NotationLayoutProperties.staveSpace / 2;
    double height = positionDifference * heightPerPosition;
    height += sortedNotesElements.last.size.height;

    double width = sortedNotesElements.map((e) => e.size.width).max;

    return Size(width, height);
  }

  static List<NoteElement> _notesToChildren({
    required List<Note> notes,
    required NotationContext notationContext,
  }) {
    // Sorts from lowest to highest note. First being lowest.
    var sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, notationContext.clef),
    );

    List<NoteElement> notesElements = [];

    int lowestPosition = NoteElement.determinePosition(
      notes.first,
      notationContext.clef,
    ).numeric;

    int highestPosition = NoteElement.determinePosition(
      notes.last,
      notationContext.clef,
    ).numeric;

    int positionDifference = highestPosition - lowestPosition;
    const heightPerPosition = NotationLayoutProperties.staveSpace / 2;

    double stemLength = positionDifference * heightPerPosition;
    stemLength += Stem.defaultLength;

    for (var (index, note) in sortedNotes.indexed) {
      bool isLowest = index == 0;
      bool isHighest = index == notes.length - 1;

      bool showLedger = isLowest || isHighest;

      var noteElement = NoteElement.fromNote(
        note: note,
        notationContext: notationContext,
        showLedger: showLedger,
        stemLength: isLowest ? stemLength : 0,
      );

      notesElements.add(noteElement);
    }
    return notesElements;
  }

  @override
  Size get size => _calculateSize(children);

  ElementPosition get _lowest => _sortedNotesElements.first.position;
  ElementPosition get _highest => _sortedNotesElements.last.position;

  @override
  ElementPosition get position => _sortedNotesElements.last.position;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    for (var element in _sortedNotesElements) {
      var positionsDifference = element.position.numeric - position.numeric;

      children.add(
        Positioned(
          bottom: positionsDifference * NotationLayoutProperties.staveSpace / 2,
          child: element,
        ),
      );
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        // mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class NoteElement extends StatelessWidget implements MeasureWidget {
  /// Create [NoteElement] from musicXML [note]. Throws exception if divisions of
  /// [notationContext] is null.
  factory NoteElement.fromNote({
    Key? key,
    required Note note,
    required NotationContext notationContext,
    double? stemLength,
    bool showLedger = true,
  }) {
    if (notationContext.divisions == null) {
      throw ArgumentError(
        "Divisions in notationContext cannot be null on note's initialization",
      );
    }

    double? calculatedLength;

    if (stemLength == null && note.type?.value.stemmed == true) {
      calculatedLength = Stem.defaultLength;
    }

    return NoteElement._(
      key: key,
      note: note,
      notationContext: notationContext,
      stemLength: stemLength ?? calculatedLength ?? 0,
      showLedger: showLedger,
      duration: _determineDuration(note),
      divisions: notationContext.divisions!,
    );
  }

  const NoteElement._({
    super.key,
    required this.note,
    required this.notationContext,
    this.stemLength = Stem.defaultLength,
    this.showLedger = true,
    required this.duration,
    required this.divisions,
  });

  final Note note;

  @override
  double get defaultBottomPosition => 0;

  final double duration;
  final double divisions;

  final double stemLength;
  bool get _stemmed => stemLength != 0;

  final bool showLedger;

  final NotationContext notationContext;

  bool get influencedByClef {
    return note.form is! Rest;
  }

  bool get _isRest {
    return note.form is Rest;
  }

  static double _determineDuration(Note note) {
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
        return note.duration;
      case RegularNote _:
        return note.duration;

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
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
            break;
          case Unpitched _:
            step = noteForm.displayStep;
            octave = noteForm.displayOctave;
          case Rest _:
            return RestElement.fromNote(note, 1).position;
        }

        final position = ElementPosition(
          step: step,
          octave: octave,
        );

        if (clef == null) {
          return position;
        }

        // Unpitched notes probably shouldn't be transposed;
        return position.transpose(
          ElementPosition.clefTransposeInterval(clef),
        );

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }

  @override
  ElementPosition get position => determinePosition(note, notationContext.clef);

  final bool drawLedgerLines = true;

  @override
  Size get size {
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    var noteheadSize = NoteheadElement(
      note: note,
    ).size;

    double width = noteheadSize.width;
    double height = noteheadSize.height;

    if (note.type?.value.stemmed ?? false) {
      width = width - NotationLayoutProperties.stemStrokeWidth;

      var stemSize = Stem(type: type).size;

      width += Stem(type: type).size.width;
      height += stemSize.height - noteheadSize.height / 2;
    }

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    LedgerLines? ledgerLines;

    if (showLedger) {
      ledgerLines = LedgerLines.fromElementPosition(position);
    }

    var notehead = NoteheadElement(
      note: note,
      ledgerLines: ledgerLines,
    );

    double? noteheadWidth;

    if (_stemmed) {
      noteheadWidth =
          notehead.size.width - NotationLayoutProperties.stemStrokeWidth;
    }

    if (_isRest) {
      return RestElement.fromNote(note, notationContext.divisions!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: noteheadWidth,
          child: notehead,
        ),
        if (_stemmed)
          Padding(
            padding: const EdgeInsets.only(
              bottom: NotationLayoutProperties.noteheadHeight / 2,
            ),
            child: Stem(
              length: stemLength,
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
class NoteheadElement extends StatelessWidget {
  final Note note;
  NoteTypeValue get _noteType => note.type?.value ?? NoteTypeValue.quarter;
  NoteheadValue get _notehead => note.notehead?.value ?? NoteheadValue.normal;

  final LedgerLines? ledgerLines;

  /// Size of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 semibreves to 3 black
  /// noteheads).
  ///
  /// The height of all notehead types is same and equal to the sum of the staff
  /// line stroke width and stave space.
  Size get size {
    const height = NotationLayoutProperties.noteheadHeight;

    switch (_noteType) {
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
        return const Size(16, height);
      case NoteTypeValue.whole:
        return const Size(21.2, height);
      case NoteTypeValue.breve:
        return const Size(30, height); // Need to be adjusted in future.
      case NoteTypeValue.long:
        return const Size(30, height); // Need to be adjusted in future.
      case NoteTypeValue.maxima:
        return const Size(30, height); // Need to be adjusted in future.
    }
  }

  String get _smufl {
    return _noteType.smuflSymbol;
  }

  const NoteheadElement({
    super.key,
    required this.note,
    this.ledgerLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: NotePainter(
        smufl: _smufl,
        ledgerLines: ledgerLines,
      ),
    );
  }
}

class RestElement extends StatelessWidget {
  final Note note;

  final double divisions;

  /// Determines the appropriate note type value based on the note's properties.
  ///
  /// If the note has an explicit type value defined, that value is returned.
  /// If the note is a complete measure rest (or a voice within a measure),
  /// it is considered a whole note regardless of the time signature.
  /// Otherwise, the note type is calculated based on its duration and divisions.
  ///
  /// Returns the determined [NoteTypeValue] for the note.
  NoteTypeValue get _type {
    if (note.type?.value != null) {
      return note.type!.value;
    }
    if (note.form is Rest && (note.form as Rest).measure == true) {
      return NoteTypeValue.whole;
    }

    return calculateNoteType((note as RegularNote).duration, divisions);
  }

  /// Calculates the appropriate [NoteTypeValue] based on the given note's [duration]
  /// and the [divisions] specified by the time signature.
  ///
  /// The function determines the [duration] of the note relative to the [divisions]
  /// and matches it to a corresponding [NoteTypeValue] based on predefined
  /// ratio ranges. If no exact match is found, the closest [NoteTypeValue] is selected.
  /// If the note duration significantly exceeds the [divisions], it defaults to [NoteTypeValue.maxima].
  static NoteTypeValue calculateNoteType(double duration, double divisions) {
    // Calculate the ratio of note's duration to divisions
    final ratio = duration / divisions;

    // Define a map that relates ratio ranges to NoteTypeValue
    final ratioToNoteTypeMap = {
      1 / 256: NoteTypeValue.n1024th,
      1 / 128: NoteTypeValue.n512th,
      1 / 64: NoteTypeValue.n256th,
      1 / 32: NoteTypeValue.n128th,
      1 / 16: NoteTypeValue.n64th,
      1 / 8: NoteTypeValue.n32nd,
      1 / 4: NoteTypeValue.n16th,
      1 / 2: NoteTypeValue.eighth,
      1 / 1: NoteTypeValue.quarter,
      2: NoteTypeValue.half,
      4: NoteTypeValue.whole,
      8: NoteTypeValue.breve,
      16: NoteTypeValue.long,
      32: NoteTypeValue.maxima,
    };

    // Find the appropriate NoteTypeValue based on the ratio
    NoteTypeValue? noteType;
    ratioToNoteTypeMap.forEach((ratioRange, type) {
      if (ratio <= ratioRange) {
        noteType = type;
        return;
      }
    });

    // Default to maxima if the note duration is larger than 8 times the divisions
    noteType ??= NoteTypeValue.maxima;

    return noteType!;
  }

  ElementPosition get position {
    Step? step = (note.form as Rest).displayStep;
    int? octave = (note.form as Rest).displayOctave;

    if (step != null && octave != null) {
      return ElementPosition(step: step, octave: octave);
    }

    switch (_type) {
      case NoteTypeValue.n1024th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n512th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n256th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n128th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n64th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n32nd:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.n16th:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.eighth:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.quarter:
        return const ElementPosition(step: Step.B, octave: 4);
      case NoteTypeValue.half:
        return const ElementPosition(step: Step.C, octave: 5);
      case NoteTypeValue.whole:
        return const ElementPosition(step: Step.C, octave: 5);
      case NoteTypeValue.breve:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.long:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
      case NoteTypeValue.maxima:
        return const ElementPosition(step: Step.C, octave: 4); // Adjust
    }
  }

  String get _smufl {
    switch (_type) {
      case NoteTypeValue.n1024th:
        return SmuflGlyph.rest1024th.codepoint;
      case NoteTypeValue.n512th:
        return SmuflGlyph.rest512th.codepoint;
      case NoteTypeValue.n256th:
        return SmuflGlyph.rest256th.codepoint;
      case NoteTypeValue.n128th:
        return SmuflGlyph.rest128th.codepoint;
      case NoteTypeValue.n64th:
        return SmuflGlyph.rest64th.codepoint;
      case NoteTypeValue.n32nd:
        return SmuflGlyph.rest32nd.codepoint;
      case NoteTypeValue.n16th:
        return SmuflGlyph.rest16th.codepoint;
      case NoteTypeValue.eighth:
        return SmuflGlyph.rest8th.codepoint;
      case NoteTypeValue.quarter:
        return SmuflGlyph.restQuarter.codepoint;
      case NoteTypeValue.half:
        return SmuflGlyph.restHalf.codepoint;
      case NoteTypeValue.whole:
        return SmuflGlyph.restWhole.codepoint;
      case NoteTypeValue.breve:
        return SmuflGlyph.restDoubleWhole.codepoint;
      case NoteTypeValue.long:
        return SmuflGlyph.restLonga.codepoint;
      case NoteTypeValue.maxima:
        return SmuflGlyph.restMaxima.codepoint;
    }
  }

  Size get size {
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
        return const Size(16, 14); // Need to be adjusted in future.
      case NoteTypeValue.whole:
        return const Size(
          17,
          NotationLayoutProperties.noteheadHeight / 2,
        ); // Need to be adjusted in future.
      case NoteTypeValue.breve:
        return const Size(30, 14); // Need to be adjusted in future.
      case NoteTypeValue.long:
        return const Size(30, 14); // Need to be adjusted in future.
      case NoteTypeValue.maxima:
        return const Size(30, 14); // Need to be adjusted in future.
    }
  }

  factory RestElement.fromNote(Note note, double divisions) {
    return RestElement._(
      note: note,
      divisions: divisions,
    );
  }

  const RestElement._({super.key, required this.note, required this.divisions});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: NotePainter(smufl: _smufl),
    );
  }
}

class Stem extends StatelessWidget {
  const Stem({
    super.key,
    required this.type,
    this.length = defaultLength,
  });

  static const defaultLength = NotationLayoutProperties.standardStemLength;

  final NoteTypeValue type;
  final double length;

  Size get size {
    return Size(
      StemPainter.strokeWidth + type.flagWidth,
      length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: StemPainter(
        flagSmufl: type.upwardFlag,
      ),
    );
  }
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

/// Enumerates the possible placements of ledger lines in relation to a note.
/// Ledger lines can be positioned either above or below a note symbol.
enum LedgerPlacement {
  /// Indicates that the ledger line(s) is positioned above the note symbol.
  above,

  /// Indicates that the ledger line(s) is positioned below the note symbol.
  below,
}

/// Represents the configuration of ledger lines for a particular note or element.
class LedgerLines {
  /// The number of ledger lines needed for the note or element.
  final int count;

  /// The placement of the ledger lines relative to the note or element.
  final LedgerPlacement placement;

  /// Indicates whether the ledger line extends through or intersects the note's head.
  /// When set to `true`, the ledger line will pass through the note's head, which is typically
  /// seen for notes that are directly adjacent to the staff.
  final bool extendsThroughNote;

  LedgerLines({
    required this.count,
    required this.placement,
    required this.extendsThroughNote,
  });

  static LedgerLines? fromElementPosition(ElementPosition position) {
    const middleDistanceToOuterLine = 4;
    int distance = position.distanceFromMiddle;

    var placement = LedgerPlacement.below;
    // if positive
    if (!distance.isNegative) {
      placement = LedgerPlacement.above;
    }
    distance = distance.abs();

    if (distance <= middleDistanceToOuterLine + 1) return null;
    distance -= middleDistanceToOuterLine;

    return LedgerLines(
      count: (distance / 2).floor(),
      placement: placement,
      extendsThroughNote: ((distance / 2) % 1) == 0,
    );
  }

  /// Creates a copy of the current [LedgerLines] instance with optional modifications.
  LedgerLines copyWith({
    int? count,
    LedgerPlacement? placement,
    bool? extendsThroughNote,
  }) {
    return LedgerLines(
      count: count ?? this.count,
      placement: placement ?? this.placement,
      extendsThroughNote: extendsThroughNote ?? this.extendsThroughNote,
    );
  }

  @override
  String toString() =>
      '_LedgerLines(count: $count, placement: $placement, extendsThroughNote: $extendsThroughNote)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LedgerLines &&
        other.count == count &&
        other.placement == placement &&
        other.extendsThroughNote == extendsThroughNote;
  }

  @override
  int get hashCode =>
      count.hashCode ^ placement.hashCode ^ extendsThroughNote.hashCode;
}
