import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

class BeamStem extends SingleChildRenderObjectWidget {
  final StemDirection direction;

  const BeamStem({
    super.key,
    required this.direction,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BeamStemRenderBox(direction: direction);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    BeamStemRenderBox renderObject,
  ) {
    renderObject.direction = direction;
  }
}

class BeamStemRenderBox extends RenderProxyBox {
  StemDirection direction;

  BeamStemRenderBox({required this.direction});

  @override
  void performLayout() {
    // Layout the child with loosened constraints
    if (child != null) {
      child!.layout(constraints.loosen(), parentUsesSize: true);
    }

    // Set the size of the wrapper based on the child or a default
    size = constraints.constrain(Size(
      child?.size.width ?? 0,
      child?.size.height ?? 0,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint the child
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

class StemElement extends StatelessWidget {
  const StemElement({
    super.key,
    required this.type,
    required this.font,
    required this.direction,
    required this.length,
    this.showFlag = true,
  }) : assert(length >= 0, "Stem must have positive length");

  final NoteTypeValue type;

  final FontMetadata font;

  final StemDirection direction;

  /// Length in stave spaces
  final double length;

  /// Determines if flag should be shown with stem. By default it is true;
  final bool showFlag;

  AlignmentOffset get offset => switch (direction) {
        StemDirection.up => AlignmentOffset.fromBottom(
            left: 0,
            bottom: 0,
            height: size.height,
          ),
        StemDirection.down => AlignmentOffset.fromTop(
            left: 0,
            top: 0,
            height: size.height,
          ),
      };

  Size get size {
    double width = NotationLayoutProperties.baseStemStrokeWidth;
    if (showFlag && length > 0) {
      width = width / 2 + _baseFlagSize.width;
    }

    return Size(width, length);
  }

  SmuflGlyph? get _glyph {
    if (!showFlag) {
      return null;
    }

    if (direction == StemDirection.down) {
      return _downwardFlag;
    }
    return _upwardFlag;
  }

  static const double defaultHorizontalOffset =
      NotationLayoutProperties.baseStemStrokeWidth / 2;

  GlyphBBox _bBox(FontMetadata font) {
    return font.glyphBBoxes[_glyph]!;
  }

  SmuflGlyph? get _upwardFlag {
    switch (type) {
      case NoteTypeValue.n1024th:
        return CombiningStaffPositions.flag1024thUp;
      case NoteTypeValue.n512th:
        return CombiningStaffPositions.flag512thUp;
      case NoteTypeValue.n256th:
        return CombiningStaffPositions.flag256thUp;
      case NoteTypeValue.n128th:
        return CombiningStaffPositions.flag128thUp;
      case NoteTypeValue.n64th:
        return CombiningStaffPositions.flag64thUp;
      case NoteTypeValue.n32nd:
        return CombiningStaffPositions.flag32ndUp;
      case NoteTypeValue.n16th:
        return CombiningStaffPositions.flag16thUp;
      case NoteTypeValue.eighth:
        return CombiningStaffPositions.flag8thUp;
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return null;
    }
  }

  Size get _baseFlagSize {
    if (!showFlag) return Size(0, 0);
    if (_glyph == null) return Size(0, 0);
    return _bBox(font).toSize();
  }

  SmuflGlyph? get _downwardFlag {
    switch (type) {
      case NoteTypeValue.n1024th:
        return CombiningStaffPositions.flag1024thDown;
      case NoteTypeValue.n512th:
        return CombiningStaffPositions.flag512thDown;
      case NoteTypeValue.n256th:
        return CombiningStaffPositions.flag256thDown;
      case NoteTypeValue.n128th:
        return CombiningStaffPositions.flag128thDown;
      case NoteTypeValue.n64th:
        return CombiningStaffPositions.flag64thDown;
      case NoteTypeValue.n32nd:
        return CombiningStaffPositions.flag32ndDown;
      case NoteTypeValue.n16th:
        return CombiningStaffPositions.flag16thDown;
      case NoteTypeValue.eighth:
        return CombiningStaffPositions.flag8thDown;
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return null;
    }
  }

  AlignmentOffset _flagPosition(StemDirection direction) {
    if (direction == StemDirection.down) {
      return AlignmentOffset.fromBottom(
        left: 0,
        bottom: 0,
        height: _baseFlagSize.height,
      );
    }
    return AlignmentOffset.fromTop(
      left: 0,
      top: 0,
      height: _baseFlagSize.height,
    );
  }

  /// Default stem length: `3.5*stave_space`.
  ///
  /// Stems for notes on more than one ledger line extend to the middle stave-line
  static double calculateStemLength(Note note, ElementPosition position) {
    if (note.type?.value.stemmed != true) {
      return 0.0;
    }

    double stemLength = NotationLayoutProperties.baseStandardStemLength;
    var spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

    int distance = 0;

    if (position >= ElementPosition.secondLedgerAbove) {
      distance = position.distance(ElementPosition.secondLedgerAbove) + 1;
    }

    if (position <= ElementPosition.secondLedgerBelow) {
      distance = position.distance(ElementPosition.secondLedgerBelow) + 1;
    }

    stemLength += distance * spacePerPosition;
    return stemLength;
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    SmuflGlyph? flagGlyph = _glyph;

    return BeamStem(
      direction: direction,
      child: SizedBox.fromSize(
        size: size.scaledByContext(context),
        child: Stack(children: [
          CustomPaint(
            size: size.scaledByContext(context),
            painter: StemPainter(
              direction: direction,
              thickness: layoutProperties.stemStrokeWidth,
            ),
          ),
          if (flagGlyph != null && length > 0)
            AlignmentPositioned(
              position: _flagPosition(direction),
              child: CustomPaint(
                size: _baseFlagSize.scaledByContext(context),
                painter: SimpleGlyphPainter(
                  flagGlyph.codepoint,
                  _bBox(font),
                  layoutProperties.staveSpace,
                ),
              ),
            ),
        ]),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level = DiagnosticLevel.info;

    properties.add(
      EnumProperty<NoteTypeValue>(
        "type",
        type,
        level: level,
      ),
    );

    properties.add(
      FlagProperty(
        "showFlag",
        value: showFlag,
        ifTrue: "true",
        ifFalse: "false",
        level: level,
        showName: true,
      ),
    );

    properties.add(
      DoubleProperty(
        "length",
        length,
        level: level,
        showName: true,
      ),
    );

    properties.add(
      EnumProperty<StemDirection>(
        "direction",
        direction,
        level: level,
      ),
    );
  }
}

class PositionedNotehead extends NoteheadElement implements MeasureWidget {
  @override
  final ElementPosition position;

  const PositionedNotehead({
    super.key,
    required super.type,
    required super.font,
    super.ledgerLines,
    super.color,
    required this.position,
  });

  PositionedNotehead.fromParent({
    super.key,
    required this.position,
    required NoteheadElement element,
  }) : super(
          font: element.font,
          type: element.type,
          color: element.color,
          ledgerLines: element.ledgerLines,
        );

  @override
  Widget build(BuildContext context) {
    return MusicElement(
      position: position,
      offset: super.offset,
      child: super.build(context),
    );
  }
}

/// Painting noteheads, it should fill the space between two lines, touching
/// the stave-line on each side of it, but without extending beyond either line.
///
/// Notes on a line should be precisely centred on the stave-line.
class NoteheadElement extends StatelessWidget {
  final NoteTypeValue type;

  final FontMetadata font;

  final LedgerLines? ledgerLines;

  final Color color;

  const NoteheadElement({
    super.key,
    required this.type,
    required this.font,
    this.ledgerLines,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  GlyphBBox get _bBox {
    return font.glyphBBoxes[_glyph]!;
  }

  SmuflGlyph get _glyph {
    switch (type) {
      case NoteTypeValue.n1024th:
      case NoteTypeValue.n512th:
      case NoteTypeValue.n256th:
      case NoteTypeValue.n128th:
      case NoteTypeValue.n64th:
      case NoteTypeValue.n32nd:
      case NoteTypeValue.n16th:
      case NoteTypeValue.eighth:
      case NoteTypeValue.quarter:
        return NoteheadSetDefault.noteheadBlack;
      case NoteTypeValue.half:
        return NoteheadSetDefault.noteheadHalf;
      case NoteTypeValue.whole:
        return NoteheadSetDefault.noteheadWhole;
      case NoteTypeValue.breve:
        return NoteheadSetDefault.noteheadDoubleWhole;
      case NoteTypeValue.long:
        return SmuflGlyph.mensuralNoteheadLongaWhite;
      case NoteTypeValue.maxima:
        return SmuflGlyph.mensuralNoteheadMaximaWhite;
    }
  }

  AlignmentOffset get offset => AlignmentOffset.fromBbox(left: 0, bBox: _bBox);

  /// Size of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 semibreves to 3 black
  /// noteheads).
  ///
  /// The height of all notehead types is same and equal to the sum of the staff
  /// line stroke width and stave space.
  Size get size => _bBox.toSize();

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    var widget = CustomPaint(
      size: size.scaledByContext(context),
      painter: NotePainter(
        smufl: _glyph.codepoint,
        ledgerLines: ledgerLines,
        color: color,
        staveSpace: layoutProperties.staveSpace,
        bBox: _bBox,
        ledgerLinesThickness: layoutProperties.staveLineThickness,
      ),
    );

    return widget;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level = DiagnosticLevel.info;

    properties.add(
      EnumProperty<NoteTypeValue>(
        "type",
        type,
        level: level,
      ),
    );

    properties.add(
      IntProperty(
        "ledgerLines.count",
        ledgerLines?.count,
        ifNull: "0",
        level: level,
        showName: true,
      ),
    );
  }
}

extension StemProperties on NoteTypeValue {
  bool get stemmed {
    switch (this) {
      case NoteTypeValue.n1024th:
      case NoteTypeValue.n512th:
      case NoteTypeValue.n256th:
      case NoteTypeValue.n128th:
      case NoteTypeValue.n64th:
      case NoteTypeValue.n32nd:
      case NoteTypeValue.n16th:
      case NoteTypeValue.eighth:
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
        return true;
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return false;
    }
  }
}
