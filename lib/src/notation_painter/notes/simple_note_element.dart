import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

// Note without accidentals, dots. Just notehead, stem and flag (if needed).
class SimpleNoteElement extends StatelessWidget {
  final NoteheadElement head;
  final StemElement? stem;

  const SimpleNoteElement({
    super.key,
    required this.head,
    this.stem,
  });

  Size get baseSize => _calculateBaseSize(notehead: head, stem: stem);

  static Size _calculateBaseSize({
    required NoteheadElement notehead,
    StemElement? stem,
  }) {
    double width = notehead.baseSize.width;
    double height = notehead.baseSize.height;

    if (stem != null && stem.length > 0) {
      height += stem.length - height / 2;
      if (stem.direction == StemDirection.up) {
        width += stem._baseFlagSize.width;
      }
      width += _stemHorizontalOffset;
      width = [stem._baseFlagSize.width, width].max;
    }

    return Size(width, height);
  }

  static const double _stemHorizontalOffset =
      NotationLayoutProperties.baseStemStrokeWidth / 2;

  AlignmentPosition get _stemPosition {
    if (stem?.direction == StemDirection.up) {
      return AlignmentPosition(
        left: head.baseSize.width - _stemHorizontalOffset,
        top: 0,
      );
    }
    // If stem direction is null or down
    return AlignmentPosition(
      left: _stemHorizontalOffset,
      bottom: 0,
    );
  }

  AlignmentPosition _noteheadPosition() {
    if (stem?.direction == StemDirection.up) {
      return AlignmentPosition(bottom: 0, left: 0);
    }
    // If stem direction is null or down
    return AlignmentPosition(top: 0, left: 0);
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return SizedBox.fromSize(
      size: baseSize.scale(layoutProperties.staveSpace),
      child: Stack(
        children: [
          AlignmentPositioned(
            position: _noteheadPosition(),
            child: head,
          ),
          if (stem != null)
            AlignmentPositioned(
              position: _stemPosition.scale(layoutProperties.staveSpace),
              child: stem!,
            ),
        ],
      ),
    );
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

  /// By default value is up.
  final StemDirection direction;

  /// Length in stave spaces
  final double length;

  /// Determines if flag should be shown with stem. By default it is true;
  final bool showFlag;

  Size get baseSize {
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

  AlignmentPosition _flagPosition(StemDirection direction) {
    if (direction == StemDirection.down) {
      return AlignmentPosition(left: 0, bottom: 0);
    }
    return AlignmentPosition(left: 0, top: 0);
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    SmuflGlyph? flagGlyph = _glyph;

    return Stack(children: [
      CustomPaint(
        size: baseSize.scaledByContext(context),
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
    ]);
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

/// Painting noteheads, it should fill the space between two lines, touching
/// the stave-line on each side of it, but without extending beyond either line.
///
/// Notes on a line should be precisely centred on the stave-line.
class NoteheadElement extends StatelessWidget {
  final NoteTypeValue type;

  final FontMetadata font;

  final LedgerLines? ledgerLines;

  final Color color;

  GlyphBBox _bBox(FontMetadata font) {
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

  AlignmentPosition get alignmentPosition {
    double top = _bBox(font).bBoxNE.y;

    return AlignmentPosition(left: 0, top: -top);
  }

  /// Size of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 semibreves to 3 black
  /// noteheads).
  ///
  /// The height of all notehead types is same and equal to the sum of the staff
  /// line stroke width and stave space.
  Size get baseSize => _bBox(font).toSize(1);

  const NoteheadElement({
    super.key,
    required this.type,
    required this.font,
    this.ledgerLines,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: baseSize.scaledByContext(context),
      painter: NotePainter(
        smufl: _glyph.codepoint,
        ledgerLines: ledgerLines,
        color: color,
        staveSpace: layoutProperties.staveSpace,
        bBox: _bBox(font),
        ledgerLinesThickness: layoutProperties.staveLineThickness,
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
