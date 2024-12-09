import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget {
  final List<StemlessNoteElement> notes;
  final StemElement? stem;
  final List<Beam> beams;
  final String? voice;

  List<StemlessNoteElement> get sortedNotes => notes.sortedBy(
        (note) => note.position,
      );

  AlignmentPosition get alignmentPosition {
    double top = 0;
    if (stem?.direction == StemDirection.up) {
      top = _calculateStemLength(notes);
    }

    StemlessNoteElement maxDotsNote = notes.reduce(
      (a, b) => (a.dots?.count ?? 0) > (b.dots?.count ?? 0) ? a : b,
    );

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stem?.direction == StemDirection.down &&
        position.numeric % 2 == 0 &&
        maxDotsNote.dots?.count != null) {
      top = .5 + maxDotsNote.dots!.size.height / 2;
    }
    if (top == 0) {
      top = .5;
    }

    return AlignmentPosition(
      left: 0,
      top: -top,
    );
  }

  ElementPosition get position => notes[referenceNoteIndex].position;

  const Chord({
    super.key,
    required this.notes,
    this.stem,
    this.beams = const [],
    this.voice,
  });

  /// **IMPORTANT**: [notes] cannot be empty.
  factory Chord.fromNotes({
    Key? key,
    required List<Note> notes,
    required Clef? clef,
    required FontMetadata font,
  }) {
    if (notes.isEmpty) {
      throw ArgumentError('notes list is empty');
    }

    List<StemlessNoteElement> notesElements = [];

    for (var note in notes) {
      AccidentalElement? accidental;
      if (note.accidental != null) {
        accidental = AccidentalElement(
          type: note.accidental!.value,
          font: font,
        );
      }

      ElementPosition position = NoteElement.determinePosition(note, clef);

      NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

      AugmentationDots? dots;
      if (note.dots.isNotEmpty) {
        dots = AugmentationDots(count: note.dots.length, font: font);
      }

      notesElements.add(StemlessNoteElement(
        dots: dots,
        accidental: accidental,
        head: NoteheadElement(
          type: type,
          font: font,
          ledgerLines: LedgerLines.fromElementPosition(position),
        ),
        position: position,
      ));
    }

    // ----------- STEM ---------------------
    StemElement? stem;
    StemValue? stemValue = notes.first.stem?.value;
    StemDirection? stemDirection;
    if (stemValue != null) {
      stemDirection = StemDirection.fromStemValue(stemValue);
    }
    NoteTypeValue type = notes.first.type?.value ?? NoteTypeValue.quarter;

    List<Beam> beams =
        notes.firstWhereOrNull((note) => note.beams.isNotEmpty)?.beams ?? [];

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: _calculateStemLength(notesElements),
        showFlag: beams.isEmpty,
        direction: stemDirection,
      );
    }

    return Chord(
      key: key,
      notes: notesElements,
      beams: beams,
      stem: stem,
      voice: notes.firstOrNull?.editorialVoice.voice,
    );
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  Offset get offsetForBeam {
    double? offsetX;
    double? offsetY = size.height;
    StemlessNoteElement maxDotsNote = notes.reduce(
      (a, b) => (a.dots?.count ?? 0) > (b.dots?.count ?? 0) ? a : b,
    );

    if (maxDotsNote.dots != null) {
      offsetX = size.width;
      offsetX -= AugmentationDots.defaultBaseOffset;
      offsetX -= maxDotsNote.dots!.size.width;
    }

    var (leftWidth, rightWidth) = _noteheadSizesBySide(
      notes,
      stem?.direction ?? Stemming.determineChordStem(notes),
    );

    if (stem?.direction == StemDirection.up && rightWidth != 0) {
      offsetX = rightWidth;
    }

    if (stem?.direction == StemDirection.down) {
      offsetX = (NotationLayoutProperties.baseStemStrokeWidth) / 2 + leftWidth;
    }

    if (alignmentPosition.top != null &&
        stem?.direction != StemDirection.down) {
      offsetY = 0;
    }

    return Offset(
      offsetX ?? size.width,
      offsetY,
    );
  }

  /// Difference between lowest and highest notes' positions;
  int get positionsDifference {
    int lowestPosition = sortedNotes.first.position.numeric;
    int highestPosition = sortedNotes.last.position.numeric;
    return highestPosition - lowestPosition;
  }

  static (double left, double right) _noteheadSizesBySide(
    List<StemlessNoteElement> notes,
    StemDirection direction,
  ) {
    // Sorts from lowest to highest note. First being lowest.
    List<StemlessNoteElement> sortedNotes = notes.sortedBy(
      (note) => note.position,
    );

    var noteheadPositions = Adjacency.determineNoteheadPositions(
      sortedNotes,
      direction,
    );

    double widthToLeft = 0;
    double widthToRight = 0;
    for (var (i, pos) in noteheadPositions.indexed) {
      double width = notes[i].size.width;
      if (pos == NoteheadPosition.left) {
        widthToLeft = [width, widthToLeft].max;
      }
      if (pos == NoteheadPosition.right) {
        widthToRight = [width, widthToRight].max;
      }
    }
    return (widthToLeft, widthToRight);
  }

  static double _calculateStemLength(
    List<StemlessNoteElement> notes,
  ) {
    var sortedNotes = notes.sortedBy(
      (note) => note.position,
    );

    int lowestPosition = sortedNotes.last.position.numeric;

    int highestPosition = sortedNotes.first.position.numeric;

    int positionDifference = highestPosition - lowestPosition;
    const heightPerPosition = .5;

    double stemLength = positionDifference.abs() * heightPerPosition;
    stemLength += NotationLayoutProperties.baseStandardStemLength;

    return stemLength;
  }

  Size get size {
    // Sorts from lowest to highest note. First being lowest.
    List<StemlessNoteElement> sortedNotes = notes.sortedBy(
      (note) => note.position,
    );

    StemDirection? stemDirection = stem?.direction;

    double height = 0;

    if (stemDirection != null) {
      StemlessNoteElement ref = sortedNotes.first;
      if (stemDirection == StemDirection.down) {
        ref = sortedNotes.last;
      }
      height = NoteElement(
        base: ref,
        stem: stem,
      ).size.height;
    }

    var (leftWidth, rightWidth) = _noteheadSizesBySide(
      notes,
      stemDirection ?? Stemming.determineChordStem(notes),
    );

    double width = leftWidth + rightWidth;

    if (leftWidth != 0 && rightWidth != 0) {
      width -= NotationLayoutProperties.baseStemStrokeWidth / 2;
    }

    return Size(width, height);
  }

  int get referenceNoteIndex {
    if (stem != null && stem?.direction == StemDirection.up) {
      return 0;
    }

    return notes.length - 1;
  }

  static bool isBeamed(List<Note> notes) {
    return notes.firstWhereOrNull((note) => !note.isChord)?.beams.isNotEmpty ??
        false;
  }

  List<NoteheadPosition> get _noteheadsPositions =>
      Adjacency.determineNoteheadPositions(
        sortedNotes,
        stem?.direction ?? Stemming.determineChordStem(notes),
      );

  bool get _hasAdjacentNotes => Adjacency.containsAdjacentNotes(sortedNotes);

  static double _verticalAlignmentAxisOffset(
    StemlessNoteElement note,
    StemElement? stem,
  ) {
    if ((stem?.length ?? 0) > 0) {
      return stem!.length;
    }

    var spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stem?.direction == StemDirection.down &&
        note.position.numeric % 2 == 0 &&
        note.dots != null) {
      return spacePerPosition + note.dots!.size.height / 2;
    }
    return spacePerPosition;
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    var children = <Widget>[];

    double calculatedStemLength = _calculateStemLength(notes);

    StemlessNoteElement refnote = notes[referenceNoteIndex];

    int leftHighest = _noteheadsPositions.lastIndexWhere(
      (p) => p == NoteheadPosition.left,
    );
    int leftLowest = _noteheadsPositions.indexWhere(
      (p) => p == NoteheadPosition.left,
    );
    int rightHighest = _noteheadsPositions.lastIndexWhere(
      (p) => p == NoteheadPosition.right,
    );
    int rightLowest = _noteheadsPositions.indexWhere(
      (p) => p == NoteheadPosition.right,
    );

    for (var (index, note) in sortedNotes.indexed) {
      bool isLowestOfSide = index == leftLowest || index == rightLowest;
      bool isHighestOfSide = index == leftHighest || index == rightHighest;
      bool showLedger = isLowestOfSide || isHighestOfSide;

      bool isStemmedUpward =
          stem != null && stem?.direction == StemDirection.up;

      double stemLength = 0;

      if (stem != null && referenceNoteIndex == index) {
        stemLength = calculatedStemLength;
      }

      // Interval between reference (position of highest or lowest note) and chord note.
      double interval = ((note.position.numeric - position.numeric)).toDouble();

      double distanceFromRef = interval * layoutProperties.staveSpace / 2;

      // When note is on drawn the line and it's stem is drawn down,
      // the dots size must be taken in the account.
      if (stem?.direction == StemDirection.down &&
          note.position.numeric % 2 == 0 &&
          refnote.position.numeric % 2 != 0 &&
          note.dots != null &&
          index != referenceNoteIndex) {
        distanceFromRef += _verticalAlignmentAxisOffset(
          note,
          stem,
        ).scaledByContext(
          context,
        );
        distanceFromRef -= layoutProperties.staveSpace / 2;
      }

      final NoteheadPosition noteheadPos = _noteheadsPositions[index];

      double? right;

      if (noteheadPos == NoteheadPosition.right && _hasAdjacentNotes) {
        right = 0;
      }

      children.add(
        Positioned(
          bottom: isStemmedUpward ? distanceFromRef : null,
          top: !isStemmedUpward ? distanceFromRef.abs() : null,
          right: right,
          child: note,
        ),
      );
    }

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
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

    properties.add(
      IterableProperty(
        '_noteheadsPositions',
        _noteheadsPositions,
        defaultValue: [],
        level: level,
        showName: true,
      ),
    );
  }
}
