import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget implements MeasureWidget {
  final List<Note> notes;
  final NotationContext notationContext;
  final FontMetadata font;

  @override
  AlignmentPosition get alignmentPosition {
    double top = 0;
    if (stem?.value == StemValue.up) {
      top = _calculateStemLength(notes);
    }

    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stem?.value == StemValue.down &&
        position.numeric % 2 == 0 &&
        maxDotsNote.dots.isNotEmpty) {
      top = NotationLayoutProperties.staveSpace / 2 +
          NoteElement.dotsSize(font).height / 2;
    }
    if (top == 0) {
      top = NotationLayoutProperties.staveSpace / 2;
    }

    return AlignmentPosition(
      left: -_calculateOffsetForCenter(font),
      top: -top,
    );
  }

  final double divisions;
  final double duration;

  final double stemLength;
  bool get _stemmed => stemLength != 0;

  final Stem? stem;

  const Chord._({
    super.key,
    required this.notes,
    required this.notationContext,
    required this.font,
    required this.divisions,
    required this.stemLength,
    required this.duration,
    this.stem,
  });

  /// **IMPORTANT**: [notes] cannot be empty.
  factory Chord.fromNotes({
    Key? key,
    required List<Note> notes,
    required NotationContext notationContext,
    required FontMetadata font,
  }) {
    if (notes.isEmpty) {
      throw ArgumentError('notes list is empty');
    }

    if (notationContext.divisions == null) {
      throw ArgumentError(
        "Divisions in notationContext cannot be null on note's initialization",
      );
    }

    return Chord._(
      key: key,
      notes: notes,
      notationContext: notationContext,
      font: font,
      divisions: notationContext.divisions!,
      stemLength: _calculateStemLength(notes),
      duration: NoteElement.determineDuration(notes.first),
      stem: notes.first.stem,
    );
  }

  /// Relative offset from bounding box top left corner.
  /// X - the middle of stem.
  /// Y - the tip of stem.
  Offset get offsetForBeam {
    double xDotsOffset = -0;

    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    if (maxDotsNote.dots.isNotEmpty) {
      xDotsOffset = NoteElement.dotsOffset();
      xDotsOffset += NoteElement.dotsSize(font).width;
    }

    if (stem?.value == StemValue.down) {
      return Offset(
        NotationLayoutProperties.stemStrokeWidth / 2,
        NotationLayoutProperties.staveSpace / 2,
      );
    }

    return Offset(
      size.width - xDotsOffset,
      0,
    );
  }

  /// Difference between lowest and highest notes' positions;
  int get positionsDifference {
    List<Note> sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    int lowestPosition = NoteElement.determinePosition(
      sortedNotes.first,
      null,
    ).numeric;
    int highestPosition = NoteElement.determinePosition(
      sortedNotes.last,
      null,
    ).numeric;
    return highestPosition - lowestPosition;
  }

  /// Calculates chord widget size from provided [notes].
  static Size _calculateSize({
    required List<Note> notes,
    required double stemLength,
    required NotationContext notationContext,
    required FontMetadata font,
  }) {
    // Sorts from lowest to highest note. First being lowest.
    List<Note> sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    StemValue? stemType = sortedNotes.first.stem?.value;

    bool beamed = isBeamed(notes);

    if (stemType == StemValue.up) {
      return NoteElement.calculateSize(
        note: sortedNotes.first,
        stemLength: _calculateStemLength(notes),
        clef: notationContext.clef,
        font: font,
        showFlag: !beamed,
      );
    }

    if (stemType == StemValue.down) {
      return NoteElement.calculateSize(
        note: sortedNotes.last,
        clef: notationContext.clef,
        stemLength: _calculateStemLength(notes),
        font: font,
        showFlag: !beamed,
      );
    }

    int lowestPosition = NoteElement.determinePosition(
      sortedNotes.first,
      null,
    ).numeric;
    int highestPosition = NoteElement.determinePosition(
      sortedNotes.last,
      null,
    ).numeric;
    int positionDifference = highestPosition - lowestPosition;

    const heightPerPosition = NotationLayoutProperties.staveSpace / 2;
    double height = positionDifference * heightPerPosition;
    if (stemLength == 0) {
      height += NoteElement.calculateSize(
            note: sortedNotes.last,
            clef: notationContext.clef,
            stemLength: 0,
            font: font,
          ).height /
          2;

      height += (NoteElement.calculateSize(
            note: sortedNotes.first,
            stemLength: 0,
            clef: notationContext.clef,
            font: font,
          ).height /
          2);
    }
    height += stemLength;

    double width = sortedNotes
        .map((e) => NoteElement.calculateSize(
              note: e,
              stemLength: 0,
              clef: notationContext.clef,
              font: font,
            ).width)
        .max;

    return Size(width, height);
  }

  static double _calculateStemLength(
    List<Note> notes,
  ) {
    var sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    int lowestPosition = NoteElement.determinePosition(
      sortedNotes.last,
      null,
    ).numeric;

    int highestPosition = NoteElement.determinePosition(
      sortedNotes.first,
      null,
    ).numeric;

    int positionDifference = highestPosition - lowestPosition;
    const heightPerPosition = NotationLayoutProperties.staveSpace / 2;

    double stemLength = positionDifference.abs() * heightPerPosition;
    stemLength += StemElement.defaultLength;

    return stemLength;
  }

  @override
  Size get size => _calculateSize(
        notes: notes,
        notationContext: notationContext,
        stemLength: stemLength,
        font: font,
      );

  double _calculateOffsetForCenter(FontMetadata font) {
    var noteheadSize = NoteheadElement(
      note: notes.first,
    ).size(font);

    var width = noteheadSize.width;
    if (_stemmed) {
      width += NotationLayoutProperties.stemStrokeWidth;
    }

    return width / 2;
  }

  int get referenceNoteIndex {
    if (_stemmed && stem?.value == StemValue.up) {
      return 0;
    }

    return notes.length - 1;
  }

  static bool isBeamed(List<Note> notes) {
    return notes.firstWhereOrNull((note) => !note.isChord)?.beams.isNotEmpty ??
        false;
  }

  bool get _beamed => isBeamed(notes);

  @override
  ElementPosition get position {
    return NoteElement.determinePosition(
      notes[referenceNoteIndex],
      notationContext.clef,
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    var sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    double calculatedStemLength = _calculateStemLength(notes);

    NoteElement refnote = NoteElement.fromNote(
      note: notes[referenceNoteIndex],
      font: font,
      notationContext: notationContext,
      showLedger: false,
      stemLength: stemLength,
    );

    for (var (index, note) in sortedNotes.indexed) {
      bool isLowest = index == 0;
      bool isHighest = index == notes.length - 1;
      bool isStemmedUpward = _stemmed && stem?.value == StemValue.up;
      bool showLedger = isLowest || isHighest;

      double stemLength = 0;

      if (stem?.value == StemValue.up && isLowest) {
        stemLength = calculatedStemLength;
      }

      if (stem?.value == StemValue.down && isHighest) {
        stemLength = calculatedStemLength;
      }

      NoteElement element = NoteElement.fromNote(
        note: note,
        font: font,
        notationContext: notationContext,
        showLedger: showLedger,
        stemLength: stemLength,
        showFlag: !_beamed,
      );

      // Interval between reference (position of highest or lowest note) and chord note.
      double interval =
          ((element.position.numeric - position.numeric)).toDouble();

      double distanceFromRef =
          interval * NotationLayoutProperties.staveSpace / 2;

      // When note is on drawn the line and it's stem is drawn down,
      // the dots size must be taken in the account.
      if (stem?.value == StemValue.down &&
          element.position.numeric % 2 == 0 &&
          refnote.position.numeric % 2 != 0 &&
          note.dots.isNotEmpty &&
          index != referenceNoteIndex) {
        distanceFromRef += element.verticalAlignmentAxisOffset;
        distanceFromRef -= NotationLayoutProperties.staveSpace / 2;
      }

      children.add(
        Positioned(
          bottom: isStemmedUpward ? distanceFromRef : null,
          top: !isStemmedUpward ? distanceFromRef.abs() : null,
          child: element,
        ),
      );
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: children,
      ),
    );
  }
}
