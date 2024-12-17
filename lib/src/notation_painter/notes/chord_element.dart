import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/layout/measure_column.dart';
import 'package:music_notation/src/notation_painter/layout/measure_row.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef PositionedElement<T> = ({ElementPosition position, T element});

class Chord extends StatelessWidget {
  final List<PositionedNotehead> noteheadsLeft;

  final List<PositionedNotehead> noteheadsRight;

  final MeasureColumn? augmentationDots;

  final MeasureColumn? accidentals;

  final int length;

  final StemElement? stem;

  final List<Beam> beams;
  final String? voice;

  const Chord({
    super.key,
    this.noteheadsLeft = const [],
    this.noteheadsRight = const [],
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

    List<PositionedElement<NoteElement>> notesElements = [];

    for (var note in notes) {
      var noteElement = NoteElement.fromNote(
        note: note,
        clef: clef,
        font: font,
      );
      var position = NoteElement.determinePosition(note, clef);

      notesElements.add((element: noteElement, position: position));
    }

    var positions = notesElements.map((e) => e.position).toList();

    // Direction of real or imaginary (if stem isn't needed) stem.
    StemDirection direction =
        stemDirection ?? Stemming.determineChordStemDirection(positions);

    var sides = Adjacency.determineNoteSides(positions, direction);

    List<PositionedNotehead> leftNoteheads = notesElements
        .whereIndexed((i, _) => sides[i] == NoteheadSide.left)
        .map((note) => PositionedNotehead.fromParent(
              element: note.element.head,
              position: note.position,
            ))
        .toList();

    List<PositionedNotehead> rightNoteheads = notesElements
        .whereIndexed((i, _) => sides[i] == NoteheadSide.right)
        .map((note) => PositionedNotehead.fromParent(
              element: note.element.head,
              position: note.position,
            ))
        .toList();

    // -------------------- STEM ----------------------
    NoteTypeValue type = notes.first.type?.value ?? NoteTypeValue.quarter;

    List<Beam> beams =
        notes.firstWhereOrNull((note) => note.beams.isNotEmpty)?.beams ?? [];

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: _stemStartLength(positions) +
            NotationLayoutProperties.baseStandardStemLength,
        showFlag: beams.isEmpty,
        direction: stemDirection,
      );
    }

    // ----------- ACCIDENTALS ---------------------
    MeasureColumn accidentalsColumn = MeasureColumn(
      children: notesElements
          .where((e) => e.element.accidental != null)
          .map((e) => MeasureElement(
                position: e.position,
                size: e.element.accidental!.size,
                alignment: e.element.accidental!.alignment,
                duration: 0,
                child: e.element.accidental!,
              ))
          .toList(),
    );

    // ----------- DOTS ---------------------
    MeasureColumn augmentationDots = MeasureColumn(
      children: notesElements.where((e) => e.element.dots != null).map((e) {
        ElementPosition position = e.position;
        if (position.numeric % 2 == 0) {
          position = position.transpose(1);
        }
        return MeasureElement(
          position: position,
          size: e.element.dots!.size,
          alignment: e.element.dots!.alignment,
          duration: 0,
          child: e.element.dots!,
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

  MeasureColumn? get _leftColumn {
    if (noteheadsLeft.isEmpty) return null;

    return MeasureColumn(children: noteheadsLeft);
  }

  MeasureColumn? get _rightColumn {
    if (noteheadsRight.isEmpty) return null;

    return MeasureColumn(children: noteheadsRight);
  }

  MeasureElement? get _accidentals => accidentals?.children.isNotEmpty == true
      ? MeasureElement(
          position: accidentals!.position,
          size: accidentals!.size,
          alignment: accidentals!.alignment,
          duration: 0,
          child: accidentals!,
        )
      : null;

  MeasureElement? get _augmentationDots =>
      augmentationDots?.children.isNotEmpty == true
          ? MeasureElement(
              position: augmentationDots!.position,
              size: augmentationDots!.size,
              alignment: augmentationDots!.alignment,
              duration: 0,
              child: augmentationDots!,
            )
          : null;

  List<MeasureWidget> get _elements {
    List<MeasureWidget> columns = [];
    if (_accidentals != null) {
      columns.add(_accidentals!);
    }
    if (noteheadsLeft.isNotEmpty) {
      columns.addAll(noteheadsLeft);
    }
    if (noteheadsRight.isNotEmpty) {
      columns.addAll(noteheadsRight);
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
        var minLeft = noteheadsLeft.map((note) => note.position).minOrNull;

        var minRight = noteheadsRight.map((note) => note.position).minOrNull;

        stemPosition = [minLeft, minRight].nonNulls.minOrNull;
      case StemDirection.down:
        var posLeft = noteheadsLeft.map((note) => note.position).maxOrNull;

        var posRight = noteheadsRight.map((note) => note.position).maxOrNull;

        if (posLeft == null && posRight == null) return null;
        stemPosition = [posLeft, posRight].nonNulls.maxOrNull;
    }

    if (stemPosition == null) return null;

    return MeasureElement(
      position: stemPosition,
      size: stem!.size,
      alignment: stem!.alignment,
      duration: 0,
      child: stem!,
    );
  }

  MeasureElementLayoutData? get _reference {
    if (_elements.isEmpty) return null;
    if (_elements.length == 1) return _elements.first;

    var sortedByBottom = _elements.sorted((a, b) {
      return a.bounds.min.compareTo(b.bounds.min);
    });

    /// Element with lowest bottom bound.
    return sortedByBottom.first;
  }

  /// Calculates stem lenght
  static double _stemStartLength(List<ElementPosition> positions) {
    var sortedNotes = positions.sorted();

    int lowestPosition = sortedNotes.last.numeric;
    int highestPosition = sortedNotes.first.numeric;
    int range = (highestPosition - lowestPosition).abs();

    return range * NotationLayoutProperties.baseSpacePerPosition;
  }

  /// Position of chord element
  ElementPosition get position =>
      _reference?.position ?? ElementPosition.staffMiddle;

  Alignment get alignment {
    if (_reference == null) {
      return Alignment.topLeft;
    }

    double leftOffset = 0;

    var x = MeasureElementLayoutData.calculateSingleAxisAlignment(
      -leftOffset,
      size.width - leftOffset,
      Axis.horizontal,
    );

    var y = MeasureElementLayoutData.calculateSingleAxisAlignment(
      _verticalRange.max,
      _verticalRange.min,
      Axis.vertical,
    );

    return Alignment(x, y);
  }

  Size get size {
    return Size(
      _width,
      _verticalRange.distance,
    );
  }

  /// Lowest y of every chord elements
  NumericalRange<double> get _verticalRange {
    return _elements.columnVerticalRange(position);
  }

  double get _width {
    double currentWidth = 0;
    double nextElementPosition = 0;
    double widthTillStem = 0;
    if (_accidentals != null) {
      currentWidth += accidentals!.size.width;
      nextElementPosition = NotationLayoutProperties.noteAccidentalDistance;
    }
    if (_leftColumn != null) {
      currentWidth += nextElementPosition;
      currentWidth += _leftColumn!.size.width;
      nextElementPosition = 0;
    }
    if (_positionedStem != null) {
      currentWidth += nextElementPosition;
      currentWidth += (NotationLayoutProperties.baseStemStrokeWidth) / 2;
      widthTillStem = currentWidth;
      nextElementPosition = -(NotationLayoutProperties.baseStemStrokeWidth) / 2;
    }
    if (_rightColumn != null) {
      currentWidth += nextElementPosition;
      currentWidth += _rightColumn!.size.width;
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
          if (_leftColumn != null) _leftColumn!,
          if (_positionedStem != null) _positionedStem!,
          if (_rightColumn != null) _rightColumn!,
          if (_augmentationDots != null) _augmentationDots!,
        ],
      ),
    );
  }
}
