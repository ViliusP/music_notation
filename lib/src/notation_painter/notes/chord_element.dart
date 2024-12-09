import 'dart:collection';
import 'dart:math';

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
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class Chord extends StatelessWidget {
  final List<StemlessNoteElement> _notes;

  final StemElement? stem;
  final List<Beam> beams;
  final String? voice;

  SplayTreeSet<StemlessNoteElement> get notes =>
      SplayTreeSet<StemlessNoteElement>.from(_notes, comparator);

  StemlessNoteElement get _referenceNote => notes.first;

  int Function(StemlessNoteElement, StemlessNoteElement)? get comparator {
    if (stem != null && stem?.direction == StemDirection.up) {
      return (a, b) => a.position.compareTo(b.position);
    }

    return (a, b) => b.position.compareTo(a.position);
  }

  ElementPosition get position => notes.first.position;

  AlignmentPosition get alignmentPosition {
    double? top;
    double? bottom;
    if (stem?.direction == StemDirection.up) {
      bottom = _referenceNote.alignmentPosition.bottom!;
    }

    if (stem?.direction == StemDirection.down) {
      top =
          _referenceNote.size.height - _referenceNote.alignmentPosition.bottom!;
    }

    return AlignmentPosition(
      left: 0,
      top: top,
      bottom: bottom,
    );
  }

  const Chord({
    super.key,
    required List<StemlessNoteElement> notes,
    this.stem,
    this.beams = const [],
    this.voice,
  }) : _notes = notes;

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
        length: _stemStartLength(notesElements) +
            NotationLayoutProperties.baseStandardStemLength,
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
  Offset? get offsetForBeam {
    if (stem == null) {
      return null;
    }

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

    var (leftWidth, rightWidth) = _noteheadSizesBySide;

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
  int get _range => _referenceNote.position.distance(notes.last.position);

  (double left, double right) get _noteheadSizesBySide {
    var noteheadPositions = Adjacency.determineNoteheadPositions(
      notes.toList(),
      stem?.direction ?? StemDirection.up,
    );

    double widthToLeft = 0;
    double widthToRight = 0;
    for (var (i, pos) in noteheadPositions.indexed) {
      double width = notes.elementAt(i).size.width;
      if (pos == NoteheadSide.left) {
        widthToLeft = [width, widthToLeft].max;
      }
      if (pos == NoteheadSide.right) {
        widthToRight = [width, widthToRight].max;
      }
    }
    return (widthToLeft, widthToRight);
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

  Size get size {
    double height = 0;
    if (alignmentPosition.bottom != null) {
      double lowestY = 0;
      double highestY = 0;
      for (var note in notes) {
        double y = 0;
        double noteTop = 0;
        int interval = note.position.distance(_referenceNote.position);
        y = interval * NotationLayoutProperties.baseSpacePerPosition;

        double noteBottom = y + note.alignmentPosition.bottom!;
        lowestY = min(lowestY, noteBottom);

        noteTop = note.size.height + note.alignmentPosition.bottom!;
        noteTop += y;
        highestY = max(highestY, noteTop);
      }

      height = lowestY.abs() + highestY.abs();
      double heigthWithStem = lowestY.abs() + (stem?.length ?? 0);
      height = max(heigthWithStem, height);
    }

    var (leftWidth, rightWidth) = _noteheadSizesBySide;

    double width = leftWidth + rightWidth;

    if (leftWidth != 0 && rightWidth != 0) {
      width -= NotationLayoutProperties.baseStemStrokeWidth / 2;
    }

    return Size(width, height);
  }

  List<NoteheadSide> get _noteheadSides => Adjacency.determineNoteheadPositions(
        notes.toList(),
        stem?.direction ?? Stemming.determineChordStemDirection(_notes),
      );

  bool get _hasAdjacentNotes => Adjacency.containsAdjacentNotes(notes.toList());

  /// Calculates position for stem - relative position by
  /// component's left, bottom/top bounding box sides that is determined by [size].
  AlignmentPosition? get _stemAlignment {
    if (stem == null) {
      return null;
    }

    double left = 0;
    double? top;
    double? bottom;
    if (_referenceNote.accidental != null) {
      // left += base.accidental!.size.width;
      // left += NotationLayoutProperties.noteAccidentalDistance;
    }
    if (stem?.direction == StemDirection.down) {
      // left += StemElement.defaultHorizontalOffset;
      bottom = 0;
    }
    if (stem?.direction == StemDirection.up) {
      // left += base.head.size.width;
      // left -= StemElement.defaultHorizontalOffset;
      top = 0;
    }

    return AlignmentPosition(
      left: left,
      top: top,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    var children = <Widget>[];

    for (var (index, note) in notes.indexed) {
      // Interval between reference note and current iteration note.
      double interval = ((note.position.numeric - position.numeric)).toDouble();
      double distanceFromRef = interval * layoutProperties.spacePerPosition;

      double? left;
      final NoteheadSide side = _noteheadSides[index];

      if (side == NoteheadSide.left && _hasAdjacentNotes) {
        left = 0;
      }

      bool alignByBottom = stem?.direction == StemDirection.up;

      children.add(
        Positioned(
          bottom: alignByBottom ? distanceFromRef : null,
          top: !alignByBottom ? distanceFromRef.abs() : null,
          left: left,
          child: note,
        ),
      );
    }

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Stack(
        children: [
          ...children,
          if (stem != null)
            AlignmentPositioned(
              position: _stemAlignment!.scaledByContext(context),
              child: stem!,
            ),
        ],
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
        _noteheadSides,
        defaultValue: [],
        level: level,
        showName: true,
      ),
    );
  }
}
