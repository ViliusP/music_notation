import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/notehead.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notation_font.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/notation_rendering_exception.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

// Note without accidentals, dots. Just notehead, stem and flag (if needed).
class SimpleNoteElement extends StatelessWidget {
  const SimpleNoteElement({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        // size: size,
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
  });

  final NoteTypeValue type;

  /// By default value is up.
  final StemDirection direction;
  final double length;

  /// Determines if flag should be shown with stem. By default it is true;
  final bool showFlag;

  Size get size {
    return Size(
      StemPainter.strokeWidth + (showFlag ? type.flagWidth : 0),
      length,
    );
  }

  @override
  Widget build(BuildContext context) {
    String? flagSmufl = type.upwardFlag?.codepoint;

    if (direction == StemDirection.down) {
      flagSmufl = type.downwardFlag?.codepoint;
    }

    if (!showFlag) {
      flagSmufl = null;
    }

    return CustomPaint(
      size: size,
      painter: StemPainter(
        flagSmufl: flagSmufl,
        direction: direction,
      ),
    );
  }
}

extension NoteVisualInformation on NoteTypeValue {
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

  SmuflGlyph? get upwardFlag {
    switch (this) {
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

  int get flagWidth {
    switch (this) {
      case NoteTypeValue.n1024th:
        return 13;
      case NoteTypeValue.n512th:
        return 13;
      case NoteTypeValue.n256th:
        return 13;
      case NoteTypeValue.n128th:
        return 13;
      case NoteTypeValue.n64th:
        return 13;
      case NoteTypeValue.n32nd:
        return 13;
      case NoteTypeValue.n16th:
        return 13;
      case NoteTypeValue.eighth:
        return 13;
      case NoteTypeValue.quarter:
      case NoteTypeValue.half:
      case NoteTypeValue.whole:
      case NoteTypeValue.breve:
      case NoteTypeValue.long:
      case NoteTypeValue.maxima:
        return 0;
    }
  }

  SmuflGlyph? get downwardFlag {
    switch (this) {
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
}

/// Painting noteheads, it should fill the space between two lines, touching
/// the stave-line on each side of it, but without extending beyond either line.
///
/// Notes on a line should be precisely centred on the stave-line.
class NoteheadElement extends StatelessWidget {
  final Note note;
  NoteTypeValue get _noteType => note.type?.value ?? NoteTypeValue.quarter;
  NoteheadValue get _notehead => note.notehead?.value ?? NoteheadValue.normal;

  final LedgerLines? ledgerLines;

  final Color color;

  GlyphBBox _bBox(FontMetadata font) {
    return font.glyphBBoxes[_glyph]!;
  }

  SmuflGlyph get _glyph {
    switch (_noteType) {
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

  /// Size of notehead symbol.
  ///
  /// The minim is usually slightly larger than the black notehead.
  /// The semibreve has greater width (in proportion 2.5 semibreves to 3 black
  /// noteheads).
  ///
  /// The height of all notehead types is same and equal to the sum of the staff
  /// line stroke width and stave space.
  Size size(FontMetadata font) {
    Rect headRect = _bBox(font).toRect();
    return Size(headRect.width, headRect.height);
  }

  const NoteheadElement({
    super.key,
    required this.note,
    this.ledgerLines,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  @override
  Widget build(BuildContext context) {
    var font = NotationFont.of(context)?.value;

    if (font == null) {
      throw NotationRenderingException.noFont(widget: this);
    }
    return CustomPaint(
      size: size(font),
      painter: NotePainter(
        smufl: _glyph.codepoint,
        ledgerLines: ledgerLines,
        color: color,
        bBox: _bBox(font),
      ),
    );
  }
}
