import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
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

    ChordColumn leftNoteheads = ChordColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.left)
          .map((note) => MeasureElement(
                position: note.position,
                size: note.size,
                alignmentOffset: note.alignmentPosition,
                duration: 0,
                child: note.head,
              ))
          .toList(),
    );

    ChordColumn rightNoteheads = ChordColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.right)
          .map((note) => MeasureElement(
                position: note.position,
                size: note.size,
                alignmentOffset: note.alignmentPosition,
                duration: 0,
                child: note.head,
              ))
          .toList(),
    );

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

  MeasureElement? get _referenceElement {
    MeasureElement? ref;
    for (var column in _columns) {
      if (ref == null || ref.position < column.position) {
        ref = column._children.firstOrNull;
      }
    }
    return ref;
  }

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

  ElementPosition get position =>
      _referenceElement?.position ?? ElementPosition.staffMiddle;

  AlignmentPosition get alignmentPosition {
    return AlignmentPosition(left: 0, top: 0);
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
      noteheadsLeft?.size.height ?? 0,
    );
  }

  double get _width {
    double currentWidth = 0;
    double nextElementPosition = 0;
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
    return currentWidth;
  }

  AlignmentPosition get _accidentalsPosition {
    int interval = position.distance(accidentals?.position ?? position);

    return AlignmentPosition(
      left: 0,
      bottom: interval * NotationLayoutProperties.baseSpacePerPosition,
    );
  }

  AlignmentPosition get _leftColumnPosition {
    int interval = position.distance(noteheadsLeft?.position ?? position);

    double afterAccidentals = 0;
    if (accidentals != null) {
      afterAccidentals = NotationLayoutProperties.noteAccidentalDistance;
    }

    return AlignmentPosition(
      left: _accidentalsPosition.left +
          (accidentals?.size.width ?? 0) +
          afterAccidentals,
      bottom: interval * NotationLayoutProperties.baseSpacePerPosition,
    );
  }

  /// Calculates position for stem - relative position by
  /// component's left, bottom/top bounding box sides that is determined by [size].
  AlignmentPosition get _stemPosition {
    return AlignmentPosition(
      left: _leftColumnPosition.left +
          (noteheadsLeft?.size.width ?? 0) -
          (NotationLayoutProperties.baseStemStrokeWidth) / 2,
      top: 0,
    );
  }

  AlignmentPosition get _rightColumnPosition {
    int interval = position.distance(noteheadsRight?.position ?? position);

    return AlignmentPosition(
      left: _stemPosition.left,
      bottom: interval * NotationLayoutProperties.baseSpacePerPosition,
    );
  }

  AlignmentPosition get _dotsPosition {
    int interval = position.distance(augmentationDots?.position ?? position);

    return AlignmentPosition(
      left: _rightColumnPosition.left +
          (noteheadsRight?.size.width ?? 0) +
          AugmentationDots.defaultBaseOffset,
      bottom: interval * NotationLayoutProperties.baseSpacePerPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Stack(
        children: [
          if (accidentals != null)
            AlignmentPositioned(
              position: _accidentalsPosition.scaledByContext(context),
              child: accidentals!,
            ),
          if (noteheadsLeft != null)
            AlignmentPositioned(
              position: _leftColumnPosition.scaledByContext(context),
              child: noteheadsLeft!,
            ),
          if (stem != null)
            AlignmentPositioned(
              position: _stemPosition.scaledByContext(context),
              child: stem!,
            ),
          if (noteheadsRight != null)
            AlignmentPositioned(
              position: _rightColumnPosition.scaledByContext(context),
              child: noteheadsRight!,
            ),
          if (augmentationDots != null)
            AlignmentPositioned(
              position: _dotsPosition.scaledByContext(context),
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
    // double? top;
    double? bottom;

    MeasureElement reference = _children.first;

    // if (stem?.direction == StemDirection.up) {
    bottom = reference.alignmentOffset.bottom!;
    // }

    // top = reference.alignmentOffset.bottom!.abs() - reference.size.height;

    return AlignmentPosition(
      left: 0,
      // top: top,
      bottom: bottom,
    );
  }

  Size get size {
    double lowestY = 0;
    double highestY = 0;

    double width = 0;
    for (var child in _children) {
      double y = 0;
      double childTop = 0;
      int interval = child.position.distance(position);
      y = interval * NotationLayoutProperties.baseSpacePerPosition;

      double childBottom = y + child.alignmentOffset.bottom!;
      lowestY = min(lowestY, childBottom);

      childTop = child.size.height + child.alignmentOffset.bottom!;
      childTop += y;
      highestY = max(highestY, childTop);

      width = max(width, child.size.width);
    }

    double height = lowestY.abs() + highestY.abs();

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
