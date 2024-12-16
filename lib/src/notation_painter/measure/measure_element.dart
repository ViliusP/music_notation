import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/debug/alignment_debug_painter.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/music_sheet/measure_stack.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/time_signature_element.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

class MeasureElementData with MeasurePositioned {
  @override
  final double duration;

  @override
  final AlignmentOffset offset;

  @override
  final ElementPosition position;

  @override
  final Size size;

  const MeasureElementData({
    required this.position,
    required this.size,
    required this.offset,
    required this.duration,
  });
}

mixin MeasurePositioned {
  /// Position of the musical element within the measure, using an [ElementPosition]
  /// object to define note pitch and octave. This allows accurate placement on the staff.
  ElementPosition get position;

  /// The size of the element, in stave spaces, defining its width and height
  /// within the measure.
  Size get size;

  /// Optional positioning and alignment information for precise element placement
  /// within its own container.
  AlignmentOffset get offset;

  double get duration;

  /// The bounds represents the vertical positions of an element within a layout system,
  /// with the positions adjusted based on the element's position, alignment and size.
  PositionalRange get bounds {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    double extentAbove = heightAboveReference(position);
    int positionsAbove = (extentAbove / spacePerPosition).ceil();
    ElementPosition top = position + positionsAbove;

    double extentBelow = heightBelowReference(position);
    int positionsBelow = (extentBelow / spacePerPosition).ceil();

    ElementPosition bottom = position - positionsBelow;

    return PositionalRange(top, bottom);
  }

  double _distanceToBottom(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = position.numeric - reference.numeric;
    double distanceToReference = interval * spacePerPosition;

    return distanceToReference + offset.bottom;
  }

  /// Vertical Distance from [reference] position to provided vertical [side] of element.
  /// Negative values means that [side] of [MeasureElementData] is positioned below [reference].
  ///
  /// Results are provided in stave spaces
  double distanceToPosition(ElementPosition reference, BoxSide side) {
    return switch (side) {
      BoxSide.top => _distanceToBottom(reference) + size.height,
      BoxSide.bottom => _distanceToBottom(reference),
    };
  }

  /// Vertical distance from element [side] to [reference] element [side].
  /// Negative values means that [side] of element is below [reference] element [side].
  double distance(MeasurePositioned reference, BoxSide side) {
    ElementPosition upperBound = reference.bounds.max;
    return distanceToPosition(upperBound, side) -
        reference.distanceToPosition(upperBound, side);
  }

  /// Calculates the height of the bounding box for elements extending above
  /// the [reference] position, considering the element's [position] and vertical alignment [offset].
  double heightAboveReference(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = reference.numeric - position.numeric;
    double distanceToReference = interval * spacePerPosition;

    // The height of the element extending above its own alignment offset.
    // A positive value means the element is entirely below its alignment axis.
    double extentAbove = offset.top.limit(top: 0);
    extentAbove = extentAbove.abs();

    double aboveReference = extentAbove - distanceToReference;

    // If the value is negative, the element's top is below the reference,
    // meaning nothing extends above the reference, so the height is 0.
    return [0.0, aboveReference].max;
  }

  /// Calculates the height of the bounding box for elements extending below
  /// the [reference] position, considering the element's position and [position] alignment [offset].
  double heightBelowReference(ElementPosition reference) {
    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int interval = reference.numeric - position.numeric;
    double distanceToReference = interval * spacePerPosition;

    // The height of the element extending below its own alignment offset.
    // A positive value means the element is entirely above its alignment axis.
    double extentBelow = offset.bottom.limit(top: 0);
    extentBelow = extentBelow.abs();

    double belowReference = extentBelow + distanceToReference;

    // If the value is negative, the element's bottom is above the reference,
    // meaning nothing extends below the reference, so the height is 0.
    return [0.0, belowReference].max;
  }

  /// TODO CHECK
  /// Calculates how much does elements extent above [reference] and below [reference] position.
  /// If reference is not given, the lowest position will be considered as reference position.
  ///
  /// Results are in stave staves
  static NumericalRange<double> columnVerticalRange(
    List<MeasurePositioned> elements, [
    ElementPosition? reference,
  ]) {
    if (elements.isEmpty) {
      return NumericalRange<double>(0.0, 0.0);
    }
    ElementPosition ref;
    if (reference != null) {
      ref = reference;
    } else {
      ref = columnPositionalRange(elements)!.min;
    }

    var bottoms = elements.map(
      (e) => e.distanceToPosition(ref, BoxSide.bottom),
    );
    var tops = elements.map(
      (e) => e.distanceToPosition(ref, BoxSide.top),
    );

    return NumericalRange<double>(bottoms.min, tops.max);
  }

  /// TODO CHECK
  ///
  /// Maximum and minimun values of [elements] position.
  static PositionalRange? columnPositionalRange(
    List<MeasurePositioned> elements,
  ) {
    if (elements.isEmpty) {
      return null;
    }
    var positions = elements.map((e) => e.position);
    var min = positions.min;
    var max = positions.max;

    return PositionalRange(min, max);
  }

  /// TODO CHECK
  ///
  /// Positions needed to fully fit column bound in container.
  /// Do not mix with [columnPositionalRange].
  static PositionalRange? columnPositionalBounds(
    List<MeasurePositioned> elements,
  ) {
    if (elements.isEmpty) {
      return null;
    }
    var ranges = elements.map((e) => e.bounds);
    var min = ranges.map((range) => range.min).min;
    var max = ranges.map((range) => range.max).max;

    return PositionalRange(min, max);
  }
}

/// An Wrapper widget representing a musical element within a measure,
/// including properties for positioning, size, and alignment.
class MeasureElement extends StatelessWidget with MeasurePositioned {
  @override
  final double duration;

  @override
  final AlignmentOffset offset;

  @override
  final ElementPosition position;

  @override
  final Size size;

  final Widget child;

  /// Constant constructor for the [MeasureWidget] base class.
  const MeasureElement({
    super.key,
    required this.position,
    required this.size,
    required this.offset,
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
      position: noteElement.head.position,
      size: noteElement.size,
      offset: noteElement.offset,
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
      size: restElement.size,
      offset: restElement.offset,
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
      offset: chord.offset,
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
      size: element.size,
      offset: element.offset,
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
      size: element.size,
      offset: element.offset,
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
      size: element.size,
      offset: element.offset,
      duration: 0,
      child: element,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugSettings? debugSettings = DebugSettings.of(context);

    return CustomPaint(
      foregroundPainter: AlignmentDebugPainter(
        offset: offset.scaledByContext(context),
        lines: debugSettings?.alignmentDebugOptions ?? {},
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level = DiagnosticLevel.info;

    properties.add(
      StringProperty(
        'position',
        position.toString(),
        level: level,
        showName: true,
      ),
    );

    properties.add(
      StringProperty(
        'alignment',
        "left: ${offset.left}, top: ${offset.top}, bottom: ${offset.bottom}",
        level: level,
        showName: true,
      ),
    );

    properties.add(
      StringProperty(
        'size',
        "width: ${size.width}, height: ${size.height}",
        level: level,
        showName: true,
      ),
    );
  }
}

class MeasureElementV2 extends ParentDataWidget<MeasureParentData>
    with MeasurePositioned {
  @override
  final double duration;

  @override
  final AlignmentOffset offset;

  @override
  final ElementPosition position;

  @override
  final Size size;

  const MeasureElementV2({
    super.key,
    required this.position,
    required this.size,
    required this.offset,
    required this.duration,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as MeasureParentData;
    if (parentData.position != position || parentData.alignment != offset) {
      parentData.position = position;
      parentData.alignment = offset;

      // Notify the parent RenderObject to relayout.
      final target = renderObject.parent;
      if (target is RenderObject) {
        target.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => MeasureLayoutV2;
}

class ElementLayoutProperties {}

/// Defines specific alignment offsets for musical elements, used for vertical and
/// horizontal positioning within their container.
class AlignmentOffset {
  /// Vertical offset from the top of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=0`.
  final double top;

  /// Vertical offset from the bottom of the bounding box, aligning the element with
  /// the staff line when positioned at `Y=container.height`.
  final double bottom;

  double get height => (top + bottom).abs();

  /// Horizontal offset from the left side of the element’s bounding box, aligning the
  /// element horizontally, typically at the visual or optical center.
  final double left;

  const AlignmentOffset({
    required this.top,
    required this.bottom,
    required this.left,
  });

  const AlignmentOffset.zero() : this(left: 0, top: 0, bottom: 0);

  factory AlignmentOffset.fromTop({
    required double left,
    required double top,
    required double height,
  }) {
    return AlignmentOffset(
      top: top,
      bottom: _effectiveBottom(bottom: null, top: top, height: height),
      left: left,
    );
  }

  factory AlignmentOffset.fromBottom({
    required double left,
    required double bottom,
    required double height,
  }) {
    return AlignmentOffset(
      top: _effectiveTop(bottom: bottom, top: null, height: height),
      bottom: bottom,
      left: left,
    );
  }

  AlignmentOffset.fromBbox({
    required double left,
    required GlyphBBox bBox,
  }) : this(left: left, top: -bBox.topRight.y, bottom: bBox.bottomLeft.y);

  AlignmentOffset.center({
    required double left,
    required Size size,
  }) : this(
          left: left,
          top: -size.height / 2,
          bottom: -size.height / 2,
        );

  AlignmentOffset scale(double scale) {
    return AlignmentOffset(
      left: left * scale,
      top: top * scale,
      bottom: bottom * scale,
    );
  }

  AlignmentOffset scaledByContext(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return scale(layoutProperties.staveSpace);
  }

  /// Returns [bottom] if it is not null,
  /// otherwise, returns calculated top from [size] and [top].
  static double _effectiveBottom({
    required double height,
    required double? bottom,
    required double? top,
  }) {
    if (bottom != null) return bottom;
    double sign = top!.sign;
    if (sign == 0) {
      sign = -1;
    }
    return (top + height) * sign;
  }

  /// Returns [top] if it is not null,
  /// otherwise, returns calculated top from [size] and [bottom].
  static double _effectiveTop({
    required double height,
    required double? bottom,
    required double? top,
  }) {
    if (top != null) return top;
    double sign = bottom!.sign;
    if (sign == 0) {
      sign = -1;
    }
    return (bottom + height) * sign;
  }

  @override
  String toString() {
    return "AlignmentOffset(left: $left, top: $top, bottom: $bottom)";
  }
}

class AlignmentPositioned extends Positioned {
  AlignmentPositioned({
    super.key,
    required AlignmentOffset position,
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

enum BoxSide {
  top,
  bottom,
}
