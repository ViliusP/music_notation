import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/music_sheet/measure_column.dart';
import 'package:music_notation/src/notation_painter/music_sheet/measure_row.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget {
  final MeasureColumn? noteheadsLeft;

  final MeasureColumn? noteheadsRight;

  final MeasureColumn? augmentationDots;

  final MeasureColumn? accidentals;

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

    List<NoteElement> notesElements = [];
    List<ElementPosition> positions = [];

    for (var note in notes) {
      notesElements.add(NoteElement.fromNote(
        note: note,
        clef: clef,
        font: font,
      ));
      positions.add(notesElements.last.head.position);
    }

    // Direction of real or imaginary (if stem isn't needed) stem.
    StemDirection direction =
        stemDirection ?? Stemming.determineChordStemDirection(positions);

    var sides = Adjacency.determineNoteSides(positions, direction);

    MeasureColumn? leftNoteheads = MeasureColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.left)
          .map((note) => MeasureElement(
                position: note.head.position,
                size: note.head.size,
                offset: note.head.offset,
                duration: 0,
                child: note.head,
              ))
          .toList(),
    );

    if (leftNoteheads.children.isEmpty) {
      leftNoteheads = null;
    }

    MeasureColumn? rightNoteheads = MeasureColumn(
      children: notesElements
          .whereIndexed((i, _) => sides[i] == NoteheadSide.right)
          .map((note) => MeasureElement(
                position: note.head.position,
                size: note.head.size,
                offset: note.head.offset,
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
    MeasureColumn accidentalsColumn = MeasureColumn(
      children: notesElements
          .where((e) => e.accidental != null)
          .map((e) => MeasureElement(
                position: e.head.position,
                size: e.accidental!.size,
                offset: e.accidental!.offset,
                duration: 0,
                child: e.accidental!,
              ))
          .toList(),
    );

    // ----------- DOTS ---------------------
    MeasureColumn augmentationDots = MeasureColumn(
      children: notesElements.where((e) => e.dots != null).map((e) {
        ElementPosition position = e.head.position;
        if (position.numeric % 2 == 0) {
          position = position.transpose(1);
        }
        return MeasureElement(
          position: position,
          size: e.dots!.size,
          offset: e.dots!.offset,
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

  MeasureElement? get _noteheadsLeft =>
      noteheadsLeft?.children.isNotEmpty == true
          ? MeasureElement(
              position: noteheadsLeft!.position!,
              size: noteheadsLeft!.size,
              offset: noteheadsLeft!.offset,
              duration: 0,
              child: noteheadsLeft!,
            )
          : null;

  MeasureElement? get _noteheadsRight =>
      noteheadsRight?.children.isNotEmpty == true
          ? MeasureElement(
              position: noteheadsRight!.position!,
              size: noteheadsRight!.size,
              offset: noteheadsRight!.offset,
              duration: 0,
              child: noteheadsRight!,
            )
          : null;
  MeasureElement? get _augmentationDots =>
      augmentationDots?.children.isNotEmpty == true
          ? MeasureElement(
              position: augmentationDots!.position!,
              size: augmentationDots!.size,
              offset: augmentationDots!.offset,
              duration: 0,
              child: augmentationDots!,
            )
          : null;

  MeasureElement? get _accidentals => accidentals?.children.isNotEmpty == true
      ? MeasureElement(
          position: accidentals!.position!,
          size: accidentals!.size,
          offset: accidentals!.offset,
          duration: 0,
          child: accidentals!,
        )
      : null;

  List<MeasureElement> get _elements {
    List<MeasureElement> columns = [];
    if (_accidentals != null) {
      columns.add(_accidentals!);
    }
    if (_noteheadsLeft != null) {
      columns.add(_noteheadsLeft!);
    }
    if (_noteheadsRight != null) {
      columns.add(_noteheadsRight!);
    }

    if (_augmentationDots != null) {
      columns.add(_augmentationDots!);
    }
    if (_positionedStem != null) {
      columns.add(_positionedStem!);
    }

    return columns;
  }

  MeasureElement? get _positionedStem {
    if (stem == null) return null;
    ElementPosition? stemPosition;

    switch (stem!.direction) {
      case StemDirection.up:
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
    }

    if (stemPosition == null) return null;

    return MeasureElement(
      position: stemPosition,
      size: stem!.size,
      offset: stem!.offset,
      duration: 0,
      child: stem!,
    );
  }

  MeasureElement? get _reference {
    if (_elements.isEmpty) return null;
    if (_elements.length == 1) return _elements.first;

    var sortedByBottom = _elements.sorted((a, b) {
      return a.bounds.min.compareTo(b.bounds.min);
    });

    /// Element with lowest bottom bound.
    return sortedByBottom.first;
  }

  /// Calculates stem lenght
  static double _stemStartLength(List<NoteElement> notes) {
    var sortedNotes = notes.sortedBy(
      (note) => note.head.position,
    );

    int lowestPosition = sortedNotes.last.head.position.numeric;
    int highestPosition = sortedNotes.first.head.position.numeric;
    int range = (highestPosition - lowestPosition).abs();

    return range * NotationLayoutProperties.baseSpacePerPosition;
  }

  /// Position of chord element
  ElementPosition get position =>
      _reference?.position ?? ElementPosition.staffMiddle;

  AlignmentOffset get offset {
    if (_reference == null) {
      return AlignmentOffset.zero();
    }

    return AlignmentOffset.fromBottom(
      left: 0,
      bottom: _reference!.offset.bottom,
      height: size.height,
    );
  }

  Size get size {
    return Size(
      _width,
      _verticalRange.distance,
    );
  }

  /// Lowest y of every chord elements
  NumericRange<double> get _verticalRange {
    return MeasureElement.columnVerticalRange(_elements);
  }

  double get _width {
    double currentWidth = 0;
    double nextElementPosition = 0;
    double widthTillStem = 0;
    if (_accidentals != null) {
      currentWidth += accidentals!.size.width;
      nextElementPosition = NotationLayoutProperties.noteAccidentalDistance;
    }
    if (_noteheadsLeft != null) {
      currentWidth += nextElementPosition;
      currentWidth += noteheadsLeft!.size.width;
      nextElementPosition = 0;
    }
    if (_positionedStem != null) {
      currentWidth += nextElementPosition;
      currentWidth += (NotationLayoutProperties.baseStemStrokeWidth) / 2;
      widthTillStem = currentWidth;
      nextElementPosition = -(NotationLayoutProperties.baseStemStrokeWidth) / 2;
    }
    if (_noteheadsRight != null) {
      currentWidth += nextElementPosition;
      currentWidth += noteheadsRight!.size.width;
      nextElementPosition = 0;
    }
    if (_augmentationDots != null) {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: MeasureRow(
        children: [
          if (_accidentals != null) _accidentals!,
          if (_noteheadsLeft != null) _noteheadsLeft!,
          if (_positionedStem != null) _positionedStem!,
          if (_noteheadsRight != null) _noteheadsRight!,
          if (_augmentationDots != null) _augmentationDots!,
        ],
      ),
    );
  }
}
