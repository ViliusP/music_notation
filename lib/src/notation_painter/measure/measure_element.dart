import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/time_signature_element.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

/// An Wrapper widget representing a musical element within a measure,
/// including properties for positioning, size, and alignment.
class MeasureElement extends StatelessWidget {
  /// Position of the musical element within the measure, using an [ElementPosition]
  /// object to define note pitch and octave. This allows accurate placement on the staff.
  final ElementPosition position;

  /// The size of the element, in stave spaces, defining its width and height within the measure.
  final Size size;

  /// Optional positioning and alignment information for precise element placement.
  final AlignmentPosition alignmentOffset;

  final double duration;

  final Widget child;

  /// Constant constructor for the [MeasureWidget] base class.
  const MeasureElement({
    super.key,
    required this.position,
    required this.size,
    required this.alignmentOffset,
    required this.duration,
    required this.child,
  });

  factory MeasureElement.note({
    required Note note,
    required FontMetadata font,
    required Clef? clef,
  }) {
    var noteElement = NoteElement.fromNote(
      note: note,
      font: font,
      clef: clef,
    );
    return MeasureElement(
      position: noteElement.position,
      size: noteElement.size,
      alignmentOffset: noteElement.alignmentPosition,
      duration: note.determineDuration(),
      child: noteElement,
    );
  }

  factory MeasureElement.rest({
    required Note rest,
    required FontMetadata font,
    required Clef? clef,
  }) {
    var restElement = RestElement.fromNote(
      note: rest,
      font: font,
      clef: clef,
    );
    return MeasureElement(
      position: restElement.position,
      size: restElement.baseSize,
      alignmentOffset: restElement.alignmentPosition,
      duration: rest.determineDuration(),
      child: restElement,
    );
  }

  factory MeasureElement.chord({
    required List<Note> notes,
    required FontMetadata font,
    required Clef? clef,
  }) {
    var chord = Chord.fromNotes(
      notes: notes,
      font: font,
      clef: clef,
    );
    return MeasureElement(
      position: chord.position,
      size: chord.size,
      alignmentOffset: chord.alignmentPosition,
      duration: notes.first.determineDuration(),
      child: chord,
    );
  }

  factory MeasureElement.clef({
    required Clef clef,
    required FontMetadata font,
  }) {
    var element = ClefElement(clef: clef, font: font);
    return MeasureElement(
      position: element.position,
      size: element.baseSize,
      alignmentOffset: element.alignmentPosition,
      duration: 0,
      child: element,
    );
  }

  factory MeasureElement.timeSignature({
    required TimeBeat timeBeat,
    required FontMetadata font,
  }) {
    var element = TimeSignatureElement(
      timeBeat: timeBeat,
      font: font,
    );
    return MeasureElement(
      position: element.position,
      size: element.baseSize,
      alignmentOffset: element.alignmentPosition,
      duration: 0,
      child: element,
    );
  }

  factory MeasureElement.keySignature({
    required TraditionalKey key,
    required TraditionalKey? keyBefore,
    required Clef? clef,
    required FontMetadata font,
  }) {
    var element = KeySignatureElement.traditional(
      key: key,
      keyBefore: keyBefore,
      clef: clef,
      font: font,
    );
    return MeasureElement(
      position: element.position,
      size: element.baseSize,
      alignmentOffset: element.alignmentPosition,
      duration: 0,
      child: element,
    );
  }

  /// Calculates a bounding box for elements extending below the staff,
  /// with consideration for the element's position and vertical alignment offset.
  Rect boxBelowStaff([double scale = 1]) {
    double spacePerPosition = scale / 2;

    Size size = this.size.scale(scale);
    AlignmentPosition alignmentScaled = alignmentOffset.scale(scale);

    double belowStaffLength = 0;

    double distanceToStaffBottom =
        spacePerPosition * ElementPosition.staffBottom.numeric;

    if (alignmentScaled.top != null) {
      belowStaffLength = [
        -spacePerPosition * position.numeric,
        distanceToStaffBottom,
        size.height,
        alignmentScaled.top!,
      ].sum;
    }

    if (alignmentScaled.bottom != null) {
      belowStaffLength = [
        -spacePerPosition * position.numeric,
        distanceToStaffBottom,
        -alignmentScaled.bottom!,
      ].sum;
    }

    belowStaffLength = [0.0, belowStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, belowStaffLength));
  }

  /// Calculates a bounding box for elements extending above the staff,
  /// considering the element's position and vertical alignment offset.
  Rect boxAboveStaff([double scale = 1]) {
    double spacePerPosition = scale / 2;

    double aboveStaffLength = 0;

    Size size = this.size.scale(scale);
    AlignmentPosition alignmentScaled = alignmentOffset.scale(scale);

    double distanceToStaffTop =
        spacePerPosition * ElementPosition.staffTop.numeric;

    if (alignmentScaled.top != null) {
      aboveStaffLength = [
        spacePerPosition * position.numeric,
        -alignmentScaled.top!,
        -distanceToStaffTop,
      ].sum;
    }

    if (alignmentScaled.bottom != null) {
      aboveStaffLength = [
        spacePerPosition * position.numeric,
        -distanceToStaffTop,
        size.height,
        alignmentScaled.bottom!,
      ].sum;
    }

    aboveStaffLength = [0.0, aboveStaffLength].max;

    return Rect.fromPoints(Offset(0, 0), Offset(size.width, aboveStaffLength));
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Defines specific alignment offsets for musical elements, used for vertical and
/// horizontal positioning within their container.
class AlignmentPosition {
  /// Vertical offset from the top of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=0`. If null, alignment is based on [bottom].
  final double? top;

  /// Vertical offset from the bottom of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=container.height`. If null, alignment is based on [top].
  final double? bottom;

  /// Horizontal offset from the left side of the element’s bounding box, aligning the
  /// element horizontally, typically at the visual or optical center.
  final double left;

  const AlignmentPosition({
    this.top,
    this.bottom,
    required this.left,
  }) : assert(
          (top == null) != (bottom == null),
          'Either top or bottom must be null, but not both.',
        );

  AlignmentPosition scale(double scale) {
    return AlignmentPosition(
      left: left * scale,
      top: top != null ? top! * scale : null,
      bottom: bottom != null ? bottom! * scale : null,
    );
  }

  AlignmentPosition scaledByContext(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return scale(layoutProperties.staveSpace);
  }
}

class AlignmentPositioned extends Positioned {
  AlignmentPositioned({
    super.key,
    required AlignmentPosition position,
    required super.child,
  }) : super(
          bottom: position.bottom,
          top: position.top,
          left: position.left,
        );
}

extension NoteWidgetization on Note {
  double determineDuration() {
    switch (this) {
      case GraceTieNote _:
        throw UnimplementedError(
          "Grace tie note is not implemented yet in renderer",
        );
      case GraceCueNote _:
        throw UnimplementedError(
          "Grace cue note is not implemented yet in renderer",
        );
      case CueNote cueNote:
        return cueNote.duration;
      case RegularNote regularNote:
        return regularNote.duration;

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }
}
