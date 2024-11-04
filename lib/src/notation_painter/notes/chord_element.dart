import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget implements RhythmicElement {
  final List<Note> notes;

  List<Note> get sortedNotes => notes.sortedBy(
        (note) => NoteElement.determinePosition(note, null),
      );

  final NotationContext notationContext;
  final FontMetadata font;

  @override
  final double divisions;

  @override
  final double duration;

  @override
  final double stemLength;

  bool get _stemmed => stemLength != 0;

  @override
  final StemDirection? stemDirection;

  @override
  AlignmentPosition get alignmentPosition {
    double top = 0;
    if (stemDirection == StemDirection.up) {
      top = _calculateStemLength(notes);
    }

    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stemDirection == StemDirection.down &&
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

  @override
  ElementPosition get position {
    return NoteElement.determinePosition(
      notes[referenceNoteIndex],
      notationContext.clef,
    );
  }

  const Chord._({
    super.key,
    required this.notes,
    required this.notationContext,
    required this.font,
    required this.divisions,
    required this.stemLength,
    required this.duration,
    this.stemDirection,
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

    StemValue? stemValue = notes.first.stem?.value;
    StemDirection? stemDirection;
    if (stemValue != null) {
      stemDirection = StemDirection.fromStemValue(stemValue);
    }

    return Chord._(
      key: key,
      notes: notes,
      notationContext: notationContext,
      font: font,
      divisions: notationContext.divisions!,
      stemLength: _calculateStemLength(notes),
      duration: NoteElement.determineDuration(notes.first),
      stemDirection: stemDirection,
    );
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  @override
  Offset get offsetForBeam {
    double? offsetX;
    double? offsetY = size.height;
    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    if (maxDotsNote.dots.isNotEmpty) {
      offsetX = size.width;
      offsetX -= NoteElement.dotsOffset();
      offsetX -= NoteElement.dotsSize(font).width;
    }

    if (stemDirection == StemDirection.down) {
      offsetX = NotationLayoutProperties.stemStrokeWidth / 2;
    }

    if (alignmentPosition.top != null && stemDirection != StemDirection.down) {
      offsetY = 0;
    }

    return Offset(
      offsetX ?? size.width,
      offsetY,
    );
  }

  /// Difference between lowest and highest notes' positions;
  int get positionsDifference {
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
    // const offsetPerPosition = NotationLayoutProperties.staveSpace / 2;

    // Sorts from lowest to highest note. First being lowest.
    List<Note> sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    StemDirection? stemDirection = StemDirection.fromStemValue(
      sortedNotes.first.stem?.value ?? StemValue.none,
    );

    double height = 0;
    bool beamed = isBeamed(notes);

    if (stemDirection == StemDirection.up) {
      height = NoteElement.calculateSize(
        note: sortedNotes.first,
        stemLength: _calculateStemLength(notes),
        clef: notationContext.clef,
        font: font,
        showFlag: !beamed,
      ).height;
    }

    if (stemDirection == StemDirection.down) {
      height = NoteElement.calculateSize(
        note: sortedNotes.last,
        clef: notationContext.clef,
        stemLength: _calculateStemLength(notes),
        font: font,
        showFlag: !beamed,
      ).height;
    }

    var noteheadPositions = Adjacency.determineNoteheadPositions(
      sortedNotes,
      stemDirection ?? Stemming.determineChordStem(notes),
    );

    double widthToLeft = 0;
    double widthToRight = 0;
    for (var (i, pos) in noteheadPositions.indexed) {
      double width = NoteElement.calculateSize(
        note: notes[i],
        clef: notationContext.clef,
        stemLength: 0,
        font: font,
      ).width;
      if (pos == NoteheadPosition.left) {
        widthToLeft = [width, widthToLeft].max;
      }
      if (pos == NoteheadPosition.right) {
        widthToRight = [width, widthToRight].max;
      }
    }

    return Size(widthToLeft + widthToRight, height);
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
    stemLength += NotationLayoutProperties.standardStemLength;

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
    if (_stemmed && stemDirection == StemDirection.up) {
      return 0;
    }

    return notes.length - 1;
  }

  static bool isBeamed(List<Note> notes) {
    return notes.firstWhereOrNull((note) => !note.isChord)?.beams.isNotEmpty ??
        false;
  }

  bool get _beamed => isBeamed(notes);

  /// Notes position
  ///
  List<NoteheadPosition> get _noteheadsPositions =>
      Adjacency.determineNoteheadPositions(
        sortedNotes,
        stemDirection ??
            Stemming.determineChordStem(
              notes,
              notationContext.clef,
            ),
      );

  bool get _hasAdjacentNotes => Adjacency.containsAdjacentNotes(sortedNotes);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

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
      bool isStemmedUpward = _stemmed && stemDirection == StemDirection.up;
      bool showLedger = isLowest || isHighest;

      double stemLength = 0;

      if (stemDirection == StemDirection.up && isLowest) {
        stemLength = calculatedStemLength;
      }

      if (stemDirection == StemDirection.down && isHighest) {
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
      if (stemDirection == StemDirection.down &&
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level = DiagnosticLevel.info;

    properties.add(
      FlagProperty(
        '_hasAdjecentNotes',
        value: _hasAdjacentNotes,
        ifTrue: _hasAdjacentNotes.toString(),
        ifFalse: _hasAdjacentNotes.toString(),
        defaultValue: null,
        level: level,
        showName: true,
      ),
    );
  }
}
