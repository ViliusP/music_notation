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
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
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
                offset: note.head.alignmentPosition,
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
                offset: note.head.alignmentPosition,
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

    // ----------- ACCIDENTALS ---------------------
    ChordColumn accidentalsColumn = ChordColumn(
      children: notesElements
          .where((e) => e.accidental != null)
          .map((e) => MeasureElement(
                position: e.position,
                size: e.accidental!.size,
                offset: e.accidental!.alignmentPosition,
                duration: 0,
                child: e.accidental!,
              ))
          .toList(),
    );

    // ----------- DOTS ---------------------
    ChordColumn augmentationDots = ChordColumn(
      children: notesElements.where((e) => e.dots != null).map((e) {
        ElementPosition position = e.position;
        if (position.numeric % 2 == 0) {
          position = position.transpose(1);
        }
        return MeasureElement(
          position: position,
          size: e.dots!.size,
          offset: e.dots!.alignmentPosition,
          duration: 0,
          child: e.dots!,
        );
      }).toList(),
    );

    return Chord(
      key: key,
      noteheadsLeft: leftNoteheads,
      noteheadsRight: rightNoteheads,
      accidentals: accidentalsColumn,
      augmentationDots: augmentationDots,
      beams: beams,
      stem: stem,
      voice: notes.firstOrNull?.editorialVoice.voice,
      length: notes.length,
    );
  }

  MeasureElement? get _positionedStem {
    if (stem == null) return null;
    ElementPosition? stemPosition;
    double? top;
    double? bottom;
    switch (stem?.direction) {
      case StemDirection.up:
        bottom = 0;
        var minLeft = noteheadsLeft?.children
            .map(
              (note) => note.position,
            )
            .minOrNull;

        var minRight = noteheadsRight?.children
            .map(
              (note) => note.position,
            )
            .minOrNull;

        stemPosition = [minLeft, minRight].nonNulls.minOrNull;
      case StemDirection.down:
        top = 0;

        var posLeft = noteheadsLeft?.children
            .map(
              (note) => note.position,
            )
            .maxOrNull;

        var posRight = noteheadsRight?.children
            .map(
              (note) => note.position,
            )
            .maxOrNull;

        if (posLeft == null && posRight == null) return null;
        stemPosition = [posLeft, posRight].nonNulls.maxOrNull;
      case null:
        return null;
    }

    if (stemPosition == null) return null;

    return MeasureElement(
      position: stemPosition,
      size: stem!.size,
      offset: AlignmentPosition(
        left: 0,
        top: top,
        bottom: bottom,
      ),
      duration: 0,
      child: stem!,
    );
  }

  List<ChordColumn> get _columns {
    List<ChordColumn> columns = [];
    if (accidentals != null && accidentals?.children.isNotEmpty == true) {
      columns.add(accidentals!);
    }
    if (noteheadsLeft != null && noteheadsLeft?.children.isNotEmpty == true) {
      columns.add(noteheadsLeft!);
    }
    if (noteheadsRight != null && noteheadsRight?.children.isNotEmpty == true) {
      columns.add(noteheadsRight!);
    }

    if (augmentationDots != null &&
        augmentationDots?.children.isNotEmpty == true) {
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
      left: -_leftColumnOffset,
      bottom: bottom,
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
    if (_positionedStem != null) {
      children.add(_positionedStem!);
    }
    return MeasureElement.columnVerticalRange(children, position);
  }

  double get _height {
    return _verticalRange.min.abs() + _verticalRange.max.abs();
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
      nextElementPosition = 0;
    }
    if (augmentationDots != null) {
      currentWidth += nextElementPosition;
      currentWidth += augmentationDots!.size.width;
      currentWidth += nextElementPosition = AugmentationDots.defaultBaseOffset;
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
    if (accidentals?.size.isEmpty == false) {
      afterAccidentals = NotationLayoutProperties.noteAccidentalDistance;
    }

    return (accidentals?.size.width ?? 0) + afterAccidentals;
  }

  /// Calculates position for stem - relative position by
  /// component's left, bottom/top bounding box sides that is determined by [size].
  AlignmentPosition get _stemPosition {
    double? top;
    double? bottom;

    if (_alignByTop) {
      bottom = 0;
    } else {
      top = 0;
    }

    return AlignmentPosition(
      left: _leftColumnOffset + (noteheadsLeft?.size.width ?? 0) - _stemSpacing,
      top: top,
      bottom: bottom,
    );
  }

  /// Distance from stem to left column of noteheads.
  double get _stemSpacing {
    if (noteheadsLeft == null) {
      return 0;
    }

    return (NotationLayoutProperties.baseStemStrokeWidth) / 2;
  }

  @override
  Widget build(BuildContext context) {
    double rightColumnOffset = _stemSpacing;
    rightColumnOffset = -rightColumnOffset.scaledByContext(context);

    double accidentalRightPadding = 0;
    if (noteheadsLeft != null || noteheadsRight != null) {
      accidentalRightPadding = NotationLayoutProperties.noteAccidentalDistance;
      accidentalRightPadding = accidentalRightPadding.scaledByContext(
        context,
      );
    }

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Stack(
        children: [
          if (stem != null)
            AlignmentPositioned(
              position: _stemPosition.scaledByContext(context),
              child: stem!,
            ),
          AlignedRow(
            alignment:
                _alignByTop ? VerticalAlignment.top : VerticalAlignment.bottom,
            children: [
              if (accidentals?.size.isEmpty == false)
                Offsetted(
                  offset: Offset(
                    0,
                    _columnOffset(accidentals).scaledByContext(context),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: accidentalRightPadding),
                    child: accidentals!,
                  ),
                ),
              if (noteheadsLeft?.size.isEmpty == false)
                Offsetted(
                  offset: Offset(
                    0,
                    _columnOffset(noteheadsLeft).scaledByContext(context),
                  ),
                  child: noteheadsLeft!,
                ),
              if (noteheadsRight?.size.isEmpty == false)
                Offsetted(
                  offset: Offset(
                    rightColumnOffset,
                    _columnOffset(noteheadsRight).scaledByContext(context),
                  ),
                  child: noteheadsRight!,
                ),
              if (augmentationDots?.size.isEmpty == false)
                Offsetted(
                  offset: Offset(
                    0,
                    _columnOffset(augmentationDots).scaledByContext(context),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            AugmentationDots.defaultBaseOffset.scaledByContext(
                      context,
                    )),
                    child: augmentationDots!,
                  ),
                ),
            ],
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

  ElementPosition get position =>
      _children.firstOrNull?.position ?? ElementPosition.staffMiddle;

  AlignmentPosition get alignmentPosition {
    MeasureElement? reference = _children.firstOrNull;

    if (reference == null) {
      return AlignmentPosition(left: 0, bottom: 0);
    }

    return AlignmentPosition(
      left: 0,
      bottom: reference.offset.effectiveBottom(reference.size),
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

      double childBottom = child.offset
          .effectiveBottom(
            child.size,
          )
          .scaledByContext(context);
      double refBottom = alignmentPosition.bottom!.scaledByContext(context);

      positioned.add(
        Positioned(
          bottom: distanceFromRef + childBottom - refBottom,
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
