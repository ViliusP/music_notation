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

  final List<Note> notes;
  final NotationContext notationContext;
  final FontMetadata font;

  final double divisions;
  final double duration;

  final double stemLength;
  bool get _stemmed => stemLength != 0;

  final Stem? stem;

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

  @override
  double get verticalAlignmentAxisOffset {
    if (stem?.value == StemValue.up) {
      return _calculateStemLength(notes);
    }

    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stem?.value == StemValue.down &&
        position.numeric % 2 == 0 &&
        maxDotsNote.dots.isNotEmpty) {
      return NotationLayoutProperties.staveSpace / 2 +
          NoteElement.dotsSize(font).height / 2;
    }
    return NotationLayoutProperties.staveSpace / 2;
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

    if (stemType == StemValue.up) {
      return NoteElement.calculateSize(
        note: sortedNotes.first,
        stemLength: _calculateStemLength(notes),
        clef: notationContext.clef,
        font: font,
      );
    }

    if (stemType == StemValue.down) {
      return NoteElement.calculateSize(
        note: sortedNotes.last,
        clef: notationContext.clef,
        stemLength: _calculateStemLength(notes),
        font: font,
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

  @override
  double get alignmentOffset => _calculateAlignmentOffset(font);

  double _calculateAlignmentOffset(FontMetadata font) {
    var noteheadSize = NoteheadElement(
      note: notes.first,
    ).size(font);

    var width = noteheadSize.width;
    if (_stemmed) {
      width += NotationLayoutProperties.stemStrokeWidth;
    }

    return width / 2;
  }

  @override
  ElementPosition get position {
    var notesPositions = notes.map((note) => NoteElement.determinePosition(
          note,
          notationContext.clef,
        ));

    if (_stemmed && stem?.value == StemValue.up) {
      return notesPositions.first;
    }

    return notesPositions.last;
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    var sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    double calculatedStemLength = _calculateStemLength(notes);

    for (var (index, note) in sortedNotes.indexed) {
      bool isLowest = index == 0;
      bool isHighest = index == notes.length - 1;
      bool isStemmedUpward = _stemmed && stem?.value == StemValue.up;
      bool showLedger = isLowest || isHighest;

      ElementPosition notePosition = NoteElement.determinePosition(
        note,
        notationContext.clef,
      );

      // Interval between reference (position of highest or lowest note) and chord note.
      double interval = ((notePosition.numeric - position.numeric)).toDouble();

      double distanceFromRef =
          interval * NotationLayoutProperties.staveSpace / 2;

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
      );

      children.add(
        Positioned(
          bottom: isStemmedUpward ? distanceFromRef : 0,
          top: !isStemmedUpward ? distanceFromRef.abs() : 0,
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
