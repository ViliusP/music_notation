import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:music_notation/src/notation_painter/layout/measure_stack.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/time_signature_element.dart';

/// An Wrapper widget representing a musical element within a measure,
/// including properties for positioning, size, and alignment.
class MeasureElement extends StatelessWidget implements MeasureWidget {
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
      position: noteElement.position,
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

    return MusicElement(
      position: position,
      offset: offset,
      child: CustomPaint(
        foregroundPainter: AlignmentDebugPainter(
          offset: offset.scaledByContext(context),
          lines: debugSettings?.alignmentDebugOptions ?? {},
        ),
        child: child,
      ),
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
    implements MeasureWidget {
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
  Type get debugTypicalAncestorWidgetClass => RenderMeasureColumn;
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

class MusicElement extends SingleChildRenderObjectWidget {
  final AlignmentOffset offset;

  final ElementPosition position;

  const MusicElement({
    super.key,
    required this.position,
    required this.offset,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MusicElementRenderBox(position: position, alignment: offset);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    MusicElementRenderBox renderObject,
  ) {
    renderObject.position = position;
    renderObject.alignment = offset;
  }
}

/// Render box for the BeamElement widget.
class MusicElementRenderBox extends RenderProxyBox {
  /// List of beams managed by this element.
  ElementPosition position;

  AlignmentOffset alignment;

  /// Constructor to initialize BeamElementRenderBox.
  MusicElementRenderBox({
    required this.position,
    required this.alignment,
  });

  @override
  void performLayout() {
    // Layout the child with loosened constraints.
    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
    }

    // Set the size of the render box based on the child or a default size.
    size = constraints.constrain(Size(
      child?.size.width ?? 0,
      child?.size.height ?? 0,
    ));

    if (parentData is MeasureParentData) {
      (parentData as MeasureParentData).position = position;
      (parentData as MeasureParentData).alignment = alignment;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the child, if available.
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
