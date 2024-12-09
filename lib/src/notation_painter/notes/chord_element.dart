import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
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
  final List<Note> notes;

  List<Note> get sortedNotes => notes.sortedBy(
        (note) => NoteElement.determinePosition(note, null),
      );

  final Clef? clef;
  final FontMetadata font;

  final double stemLength;

  bool get _stemmed => stemLength != 0;

  final StemDirection? stemDirection;

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
      top = .5 + baseDotsSize(font).height / 2;
    }
    if (top == 0) {
      top = .5;
    }

    return AlignmentPosition(
      left: 0,
      top: -top,
    );
  }

  ElementPosition get position {
    return NoteElement.determinePosition(notes[referenceNoteIndex], clef);
  }

  const Chord._({
    super.key,
    required this.notes,
    required this.clef,
    required this.font,
    required this.stemLength,
    this.stemDirection,
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

    StemValue? stemValue = notes.first.stem?.value;
    StemDirection? stemDirection;
    if (stemValue != null) {
      stemDirection = StemDirection.fromStemValue(stemValue);
    }

    return Chord._(
      key: key,
      notes: notes,
      clef: clef,
      font: font,
      stemLength: _calculateStemLength(notes),
      stemDirection: stemDirection,
    );
  }

  static Size baseDotsSize(FontMetadata font) {
    return AugmentationDots(count: 1, font: font).baseSize;
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  Offset get offsetForBeam {
    double? offsetX;
    double? offsetY = baseSize.height;
    Note maxDotsNote = notes.reduce(
      (a, b) => a.dots.length > b.dots.length ? a : b,
    );

    if (maxDotsNote.dots.isNotEmpty) {
      offsetX = baseSize.width;
      offsetX -= AugmentationDots.defaultBaseOffset;
      offsetX -= baseDotsSize(font).width;
    }

    var (leftWidth, rightWidth) = _noteheadSizesBySide(
      notes,
      font,
      stemDirection ?? Stemming.determineChordStem(notes),
    );

    if (stemDirection == StemDirection.up && rightWidth != 0) {
      offsetX = rightWidth;
    }

    if (stemDirection == StemDirection.down) {
      offsetX = (NotationLayoutProperties.baseStemStrokeWidth) / 2 + leftWidth;
    }

    if (alignmentPosition.top != null && stemDirection != StemDirection.down) {
      offsetY = 0;
    }

    return Offset(
      offsetX ?? baseSize.width,
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
  static Size _calculateBaseSize({
    required List<Note> notes,
    required double stemLength,
    required Clef? clef,
    required FontMetadata font,
  }) {
    // Sorts from lowest to highest note. First being lowest.
    List<Note> sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    StemDirection? stemDirection = StemDirection.fromStemValue(
      sortedNotes.first.stem?.value ?? StemValue.none,
    );

    double height = 0;
    bool beamed = isBeamed(notes);

    if (stemDirection != null) {
      Note ref = sortedNotes.first;
      if (stemDirection == StemDirection.down) {
        ref = sortedNotes.last;
      }
      height = NoteElement(
        base: StemlessNoteElement(
          head: NoteheadElement(
            type: ref.type?.value ?? NoteTypeValue.quarter,
            font: font,
          ),
          position: NoteElement.determinePosition(ref, clef),
          dots: null,
          accidental: null,
        ),
        stem: StemElement(
          type: ref.type?.value ?? NoteTypeValue.quarter,
          font: font,
          direction: stemDirection,
          length: _calculateStemLength(notes),
          showFlag: !beamed,
        ),
      ).size.height;
    }

    var (leftWidth, rightWidth) = _noteheadSizesBySide(
      notes,
      font,
      stemDirection ?? Stemming.determineChordStem(notes),
    );

    double width = leftWidth + rightWidth;

    if (leftWidth != 0 && rightWidth != 0) {
      width -= NotationLayoutProperties.baseStemStrokeWidth / 2;
    }

    return Size(width, height);
  }

  static (double left, double right) _noteheadSizesBySide(
    List<Note> notes,
    FontMetadata font,
    StemDirection direction,
  ) {
    // Sorts from lowest to highest note. First being lowest.
    List<Note> sortedNotes = notes.sortedBy(
      (note) => NoteElement.determinePosition(note, null),
    );

    var noteheadPositions = Adjacency.determineNoteheadPositions(
      sortedNotes,
      direction,
    );

    double widthToLeft = 0;
    double widthToRight = 0;
    for (var (i, pos) in noteheadPositions.indexed) {
      if (notes[i].type?.value == null) continue;
      double width = NoteheadElement(
        type: notes[i].type!.value,
        font: font,
      ).size.width;
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
    const heightPerPosition = .5;

    double stemLength = positionDifference.abs() * heightPerPosition;
    stemLength += NotationLayoutProperties.baseStandardStemLength;

    return stemLength;
  }

  Size get baseSize => _calculateBaseSize(
        notes: notes,
        clef: clef,
        stemLength: stemLength,
        font: font,
      );

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

  List<NoteheadPosition> get _noteheadsPositions =>
      Adjacency.determineNoteheadPositions(
        sortedNotes,
        stemDirection ?? Stemming.determineChordStem(notes, clef),
      );

  bool get _hasAdjacentNotes => Adjacency.containsAdjacentNotes(sortedNotes);

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    var children = <Widget>[];

    double calculatedStemLength = _calculateStemLength(notes);

    NoteElement refnote = NoteElement.fromNote(
      note: notes[referenceNoteIndex],
      font: font,
      clef: clef,
      showLedger: false,
      stemLength: stemLength,
    );

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

      bool isStemmedUpward = _stemmed && stemDirection == StemDirection.up;

      double stemLength = 0;

      if (_stemmed && referenceNoteIndex == index) {
        stemLength = calculatedStemLength;
      }

      NoteElement element = NoteElement.fromNote(
        note: note,
        font: font,
        clef: clef,
        showLedger: showLedger,
        stemLength: stemLength,
        showFlag: !_beamed,
      );

      // Interval between reference (position of highest or lowest note) and chord note.
      double interval =
          ((element.position.numeric - position.numeric)).toDouble();

      double distanceFromRef = interval * layoutProperties.staveSpace / 2;

      // When note is on drawn the line and it's stem is drawn down,
      // the dots size must be taken in the account.
      if (stemDirection == StemDirection.down &&
          element.position.numeric % 2 == 0 &&
          refnote.position.numeric % 2 != 0 &&
          note.dots.isNotEmpty &&
          index != referenceNoteIndex) {
        distanceFromRef += element.verticalAlignmentAxisOffset.scaledByContext(
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
          child: element,
        ),
      );
    }

    return SizedBox.fromSize(
      size: baseSize.scaledByContext(context),
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
