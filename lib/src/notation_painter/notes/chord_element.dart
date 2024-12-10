import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/aligned_row.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget {
  final ChordColumn? noteheadsLeft;
  final ChordColumn? noteheadsRight;
  final ChordColumn? augmentationDots;
  final ChordColumn? accidentals;

  final int length;

  final StemElement? stem;
  final List<Beam> beams;
  final String? voice;

  const Chord({
    super.key,
    this.noteheadsLeft,
    this.noteheadsRight,
    this.augmentationDots,
    this.accidentals,
    this.stem,
    this.beams = const [],
    this.voice,
    required this.length,
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

    // ----------- STEM DIRECTION ---------------------
    StemElement? stem;
    StemValue? stemValue = notes.first.stem?.value;
    StemDirection? stemDirection;
    if (stemValue != null) {
      stemDirection = StemDirection.fromStemValue(stemValue);
    }

    // ----------- NOTEHEAD COLUMNS ---------------------

    List<StemlessNoteElement> notesElements = [];
    List<ElementPosition> positions = [];

    for (var note in notes) {
      notesElements.add(StemlessNoteElement.fromNote(
        note: note,
        clef: clef,
        font: font,
      ));
      positions.add(notesElements.last.position);
    }

    // Direction of real or imaginary (if stem isn't needed) stem.
    StemDirection direction =
        stemDirection ?? Stemming.determineChordStemDirection(positions);

    var sides = Adjacency.determineNoteSides(positions, direction);

    ChordColumn? leftNoteheads = ChordColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.left)
          .map((note) => MeasureElement(
                position: note.position,
                size: note.head.size,
                alignmentOffset: note.head.alignmentPosition,
                duration: 0,
                child: note.head,
              ))
          .toList(),
    );

    if (leftNoteheads.children.isEmpty) {
      leftNoteheads = null;
    }

    ChordColumn? rightNoteheads = ChordColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.right)
          .map((note) => MeasureElement(
                position: note.position,
                size: note.head.size,
                alignmentOffset: note.head.alignmentPosition,
                duration: 0,
                child: note.head,
              ))
          .toList(),
    );

    if (rightNoteheads.children.isEmpty) {
      rightNoteheads = null;
    }

    // -------------------- STEM ----------------------
    NoteTypeValue type = notes.first.type?.value ?? NoteTypeValue.quarter;

    List<Beam> beams =
        notes.firstWhereOrNull((note) => note.beams.isNotEmpty)?.beams ?? [];

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: _stemStartLength(notesElements) +
            NotationLayoutProperties.baseStandardStemLength,
        showFlag: beams.isEmpty,
        direction: stemDirection,
      );
    }

    return Chord(
      key: key,
      noteheadsLeft: leftNoteheads,
      noteheadsRight: rightNoteheads,
      beams: beams,
      stem: stem,
      voice: notes.firstOrNull?.editorialVoice.voice,
      length: notes.length,
    );
  }

  List<ChordColumn> get _columns {
    List<ChordColumn> columns = [];
    if (accidentals != null) {
      columns.add(accidentals!);
    }
    if (noteheadsLeft != null) {
      columns.add(noteheadsLeft!);
    }
    if (noteheadsRight != null) {
      columns.add(noteheadsRight!);
    }

    if (augmentationDots != null) {
      columns.add(augmentationDots!);
    }

    return columns;
  }

  ///
  ChordColumn? get _referenceColumn {
    ChordColumn? ref = _columns.firstOrNull;
    if (ref == null) return null;
    for (var column in _columns) {
      if (column._children.isEmpty) continue;
      if (column.position < ref!.position) {
        ref = column;
      }
    }
    return ref;
  }

  /// Calculates stem lenght
  static double _stemStartLength(
    List<StemlessNoteElement> notes,
  ) {
    var sortedNotes = notes.sortedBy(
      (note) => note.position,
    );

    int lowestPosition = sortedNotes.last.position.numeric;
    int highestPosition = sortedNotes.first.position.numeric;
    int range = (highestPosition - lowestPosition).abs();

    return range * NotationLayoutProperties.baseSpacePerPosition;
  }

  /// Position of chord element
  ElementPosition get position =>
      _referenceColumn?.position ?? ElementPosition.staffMiddle;

  /// Alignment offset for correctly placing on measure
  AlignmentPosition get alignmentPosition {
    if (_referenceColumn == null) {
      return AlignmentPosition(left: 0, bottom: 0);
    }

    double bottom;
    if (_alignByTop) {
      bottom = _verticalRange.max - _height;
    } else {
      bottom = _verticalRange.min;
    }

    return AlignmentPosition(
      left: _leftColumnOffset,
      bottom: bottom,
    );
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  Offset? get offsetForBeam {
    if (stem == null) {
      return null;
    }
    return Offset(
      _stemPosition.left,
      0,
    );
  }

  Size get size {
    return Size(
      _width,
      _height,
    );
  }

  /// Lowest y of every chord elements
  ({double min, double max}) get _verticalRange {
    var children = _columns.expand((column) => column._children).toList();
    return MeasureElement.columnVerticalRange(children, position);
  }

  double get _height {
    double elementsHeight = _verticalRange.min.abs() + _verticalRange.max.abs();
    double heightWithStem = _verticalRange.min.abs() + (stem?.length ?? 0);
    return max(heightWithStem, elementsHeight);
  }

  double get _width {
    double currentWidth = 0;
    double nextElementPosition = 0;
    double widthTillStem = 0;
    if (accidentals != null) {
      currentWidth += accidentals!.size.width;
      nextElementPosition = NotationLayoutProperties.noteAccidentalDistance;
    }
    if (noteheadsLeft != null) {
      currentWidth += nextElementPosition;
      currentWidth += noteheadsLeft!.size.width;
      nextElementPosition = 0;
    }
    if (stem != null) {
      currentWidth += nextElementPosition;
      currentWidth += (NotationLayoutProperties.baseStemStrokeWidth) / 2;
      widthTillStem = currentWidth;
      nextElementPosition = -(NotationLayoutProperties.baseStemStrokeWidth) / 2;
    }
    if (noteheadsRight != null) {
      currentWidth += nextElementPosition;
      currentWidth += noteheadsRight!.size.width;
      nextElementPosition = AugmentationDots.defaultBaseOffset;
    }
    if (augmentationDots != null) {
      currentWidth += nextElementPosition;
      currentWidth += augmentationDots!.size.width;
    }
    // If stem has flag, chord sizes must be increase to fit that flag.
    if (stem != null) {
      currentWidth = max(currentWidth, widthTillStem + (stem?.size.width ?? 0));
    }
    return currentWidth;
  }

  bool get _alignByTop => stem?.direction == StemDirection.down;

  double _columnOffset(ChordColumn? column) {
    double offset = 0;
    if (column == null) return offset;

    int columnPosition = column.position.numeric;
    int interval = columnPosition - position.numeric;

    if (_alignByTop) {
      offset = -interval * NotationLayoutProperties.baseSpacePerPosition;
      offset += column.alignmentPosition.effectiveTop(column.size);
    } else {
      offset = interval * NotationLayoutProperties.baseSpacePerPosition;
      offset += column.alignmentPosition.effectiveBottom(column.size);
    }

    return offset;
  }

  double get _leftColumnOffset {
    double afterAccidentals = 0;
    if (accidentals != null) {
      afterAccidentals = NotationLayoutProperties.noteAccidentalDistance;
    }

    return (accidentals?.size.width ?? 0) + afterAccidentals;
  }

  /// Calculates position for stem - relative position by
  /// component's left, bottom/top bounding box sides that is determined by [size].
  AlignmentPosition get _stemPosition {
    double? top;
    double? bottom;

    bottom = 0;

    return AlignmentPosition(
      left: _leftColumnOffset +
          (noteheadsLeft?.size.width ?? 0) -
          (NotationLayoutProperties.baseStemStrokeWidth) / 2,
      top: top,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: AlignedRow(
        alignment:
            _alignByTop ? VerticalAlignment.top : VerticalAlignment.bottom,
        children: [
          if (accidentals != null)
            Offsetted(
              offset: _columnOffset(accidentals).scaledByContext(context),
              child: accidentals!,
            ),
          if (noteheadsLeft != null)
            Offsetted(
              offset: _columnOffset(noteheadsLeft).scaledByContext(context),
              child: noteheadsLeft!,
            ),
          // if (stem != null)
          //   Offsetted(
          //     offset: _stemPosition.scaledByContext(context).bottom!,
          //     child: stem!,
          //   ),
          if (noteheadsRight != null)
            Offsetted(
              offset: _columnOffset(noteheadsRight).scaledByContext(context),
              child: noteheadsRight!,
            ),
          if (augmentationDots != null)
            Offsetted(
              offset: _columnOffset(augmentationDots).scaledByContext(context),
              child: augmentationDots!,
            ),
        ],
      ),
    );
  }
}

class ChordColumn extends StatelessWidget {
  final List<MeasureElement> children;

  const ChordColumn({
    super.key,
    required this.children,
  });

  SplayTreeSet<MeasureElement> get _children =>
      SplayTreeSet<MeasureElement>.from(children, _comparator);

  int Function(MeasureElement, MeasureElement)? get _comparator {
    return (a, b) {
      return a.position.compareTo(b.position);
    };
  }

  ElementPosition get position => _children.first.position;

  AlignmentPosition get alignmentPosition {
    MeasureElement reference = _children.first;

    return AlignmentPosition(
      left: 0,
      bottom: reference.alignmentOffset.effectiveBottom(reference.size),
    );
  }

  Size get size {
    var range = MeasureElement.columnVerticalRange(children, position);
    double height = range.max.abs() + range.min.abs();

    double width = 0;
    for (var child in _children) {
      width = max(width, child.size.width);
    }

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    List<Widget> positioned = [];

    for (var child in _children) {
      double interval =
          ((child.position.numeric - position.numeric)).toDouble();
      double distanceFromRef = interval * layoutProperties.spacePerPosition;

      positioned.add(
        Positioned(
          bottom: distanceFromRef,
          child: child,
        ),
      );
    }

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: positioned,
      ),
    );
  }
}
