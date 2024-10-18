import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';

class Chord extends StatelessWidget implements MeasureWidget {
  const Chord._({
    super.key,
    required this.notes,
    required this.notationContext,
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
      notationContext: notationContext,
      divisions: notationContext.divisions!,
      stemLength: _calculateStemLength(notes),
      duration: NoteElement.determineDuration(notes.first),
      stem: notes.first.stem,
      notes: notes,
    );
  }

  final List<Note> notes;
  final NotationContext notationContext;

  final double divisions;
  final double duration;

  final double stemLength;
  bool get _stemmed => stemLength != 0;

  final Stem? stem;

  Offset get offsetForBeam {
    if (stem?.value == StemValue.down) {
      return Offset(
        NotationLayoutProperties.stemStrokeWidth / 1.5,
        NotationLayoutProperties.staveSpace / 2,
      );
    }

    double width = notes
        .map((e) => NoteElement.calculateSize(note: e, stemLength: 0).width)
        .max;

    return Offset(
      width - NotationLayoutProperties.stemStrokeWidth,
      size.height,
    );
  }

  @override
  double get positionalOffset {
    if (stem?.value == StemValue.down) {
      const heightPerPosition = NotationLayoutProperties.staveSpace / 2;
      double height = positionsDifference * heightPerPosition;
      return -_calculateStemLength(notes) + height;
    }

    return -NotationLayoutProperties.staveSpace / 2 -
        NotationLayoutProperties.staffLineStrokeWidth / 2;
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
      );
    }

    if (stemType == StemValue.down) {
      return NoteElement.calculateSize(
        note: sortedNotes.last,
        stemLength: _calculateStemLength(notes),
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
            stemLength: 0,
          ).height /
          2;

      height += (NoteElement.calculateSize(
            note: sortedNotes.first,
            stemLength: 0,
          ).height /
          2);
    }
    height += stemLength;

    double width = sortedNotes
        .map((e) => NoteElement.calculateSize(note: e, stemLength: 0).width)
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
      );

  @override
  double get alignmentOffset => _calculateAlignmentOffset();

  double _calculateAlignmentOffset() {
    var noteheadSize = NoteheadElement(
      note: notes.first,
    ).size;

    var width = noteheadSize.width;
    if (_stemmed) {
      width += NotationLayoutProperties.stemStrokeWidth;
    }

    return width / 2;
  }

  @override
  ElementPosition get position {
    return notes
        .map((note) => NoteElement.determinePosition(
              note,
              notationContext.clef,
            ))
        .first;
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

      bool showLedger = isLowest || isHighest;

      ElementPosition notePosition = NoteElement.determinePosition(
        note,
        notationContext.clef,
      );

      double bottom = (notePosition.numeric - position.numeric).toDouble();
      bottom *= NotationLayoutProperties.staveSpace / 2;

      double stemLength = 0;

      if (stem?.value == StemValue.up && isLowest) {
        stemLength = calculatedStemLength;
      }

      if (stem?.value == StemValue.down && isHighest) {
        stemLength = calculatedStemLength;
        bottom = 0;
      }

      NoteElement element = NoteElement.fromNote(
        note: note,
        notationContext: notationContext,
        showLedger: showLedger,
        stemLength: stemLength,
      );

      if (stem?.value == StemValue.down && !isHighest) {
        bottom += 35; // This is magic number that just works, need to fix it.
        // bottom += element.positionalOffset;
      }

      children.add(
        Positioned(
          bottom: bottom,
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
