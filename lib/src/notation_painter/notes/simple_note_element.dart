import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

// Note without accidentals, dots. Just notehead, stem and flag (if needed).
class SimpleNoteElement extends StatelessWidget {
  final NoteTypeValue type;

  final FontMetadata font;

  final StemDirection? stemDirection;

  final double stemLength;

  final bool showFlag;

  final LedgerLines? ledgerLines;

  const SimpleNoteElement({
    super.key,
    required this.font,
    required this.type,
    this.stemDirection,
    required this.stemLength,
    required this.showFlag,
    this.ledgerLines,
  });

  Size get size => calculateSize(
        stemLength: stemLength,
        font: font,
        showFlag: showFlag,
        type: type,
        stemDirection: stemDirection,
      );

  Size get noteheadSize => NoteheadElement(
        font: font,
        type: type,
      ).size;

  static Size calculateSize({
    required NoteTypeValue type,
    required double stemLength,
    required FontMetadata font,
    required StemDirection? stemDirection,
    bool showFlag = true,
  }) {
    var noteheadSize = NoteheadElement(
      font: font,
      type: type,
    ).size;

    double width = noteheadSize.width;
    double height = noteheadSize.height;

    if (stemLength != 0 && stemDirection != null) {
      width = width - NotationLayoutProperties.stemStrokeWidth / 2;

      var stemElement = StemElement(
        type: type,
        length: stemLength,
        showFlag: showFlag,
        font: font,
      );

      width += stemElement.size.width;
      height += stemElement.size.height - noteheadSize.height / 1.75;
    }

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    NoteheadElement notehead = NoteheadElement(
      type: type,
      font: font,
      ledgerLines: ledgerLines,
    );

    double stemLeft = 0;
    double? stemTop;
    double? stemBottom;

    if (stemDirection == StemDirection.down) {
      stemLeft = NotationLayoutProperties.stemStrokeWidth / 2;
      stemTop = NotationLayoutProperties.defaultNoteheadHeight / 1.75;
    }

    if (stemDirection == StemDirection.up) {
      stemLeft = noteheadSize.width;
      stemLeft -= NotationLayoutProperties.stemStrokeWidth / 2;
      stemBottom = NotationLayoutProperties.defaultNoteheadHeight / 1.75;
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          Positioned(
            top: stemDirection != StemDirection.up ? 0 : null,
            // bottom: stemDirection == StemDirection.up ? 0 : null,
            child: notehead,
          ),
          // if (stemLength > 0 && stemDirection != null)
          //   Positioned(
          //     left: stemLeft,
          //     top: stemTop,
          //     bottom: stemBottom,
          //     child: StemElement(
          //       type: type,
          //       font: font,
          //       length: stemLength,
          //       showFlag: showFlag,
          //     ),
          //   ),
        ],
      ),
      // child: Stack(
      //   children: [
      //     Positioned(
      //       top: stemDirection == StemDirection.down ? noteheadTop : null,
      //       bottom: stemDirection == StemDirection.up ? 0 : null,
      //       left: alignmentPosition.left.abs(),
      //       child: notehead,
      //     ),
      //     if (_stemmed)
      //       Positioned(
      //         left: stemLeft,
      //         top: stemTop,
      //         bottom: stemBottom,
      //         child: StemElement(
      //           length: stemLength,
      //           type: type,
      //           direction: stemDirection!,
      //           showFlag: note.beams.isEmpty && showFlag,
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}

class StemElement extends StatelessWidget {
  const StemElement({
    super.key,
    required this.type,
    this.length = NotationLayoutProperties.standardStemLength,
    this.direction = StemDirection.up,
    this.showFlag = true,
    required this.font,
  });

  final NoteTypeValue type;

  final FontMetadata font;

  /// By default value is up.
  final StemDirection direction;
  final double length;

  /// Determines if flag should be shown with stem. By default it is true;
  final bool showFlag;

  Size get size {
    return Size(
      StemPainter.strokeWidth + (showFlag ? _flagWidth : 0),
      length,
    );
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

  double get _flagWidth {
    if (_glyph == null) return 0;
    return _bBox(font).toRect().width;
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

  @override
  Widget build(BuildContext context) {
    SmuflGlyph? flagGlyph = _glyph;

    return Stack(children: [
      CustomPaint(
        size: size,
        painter: StemPainter(
          direction: direction,
        ),
      ),
      if (flagGlyph != null)
        CustomPaint(
          size: size,
          painter: SimpleGlyphPainter(
            flagGlyph.codepoint,
            _bBox(font),
          ),
        ),
    ]);
  }
}

/// Painting noteheads, it should fill the space between two lines, touching
/// the stave-line on each side of it, but without extending beyond either line.
///
/// Notes on a line should be precisely centred on the stave-line.
class NoteheadElement extends StatelessWidget {
  final NoteTypeValue type;

  final LedgerLines? ledgerLines;

  final FontMetadata font;

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
    double top = _bBox(font).topOffset;

    return AlignmentPosition(left: 0, top: top);
  }

  /// Size of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 semibreves to 3 black
  /// noteheads).
  ///
  /// The height of all notehead types is same and equal to the sum of the staff
  /// line stroke width and stave space.
  Size get size {
    Rect headRect = _bBox(font).toRect();
    return Size(headRect.width, headRect.height);
  }

  const NoteheadElement({
    super.key,
    required this.type,
    this.ledgerLines,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: NotePainter(
        smufl: _glyph.codepoint,
        ledgerLines: ledgerLines,
        color: color,
        bBox: _bBox(font),
      ),
    );
  }
}
