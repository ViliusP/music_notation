import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/aligned_row.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/padding_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

class StemlessNoteElement extends StatelessWidget {
  final NoteheadElement head;
  final ElementPosition position;

  final AccidentalElement? accidental;
  final AugmentationDots? dots;

  const StemlessNoteElement({
    super.key,
    required this.head,
    required this.position,
    this.accidental,
    this.dots,
  });

  factory StemlessNoteElement.fromNote({
    Key? key,
    required Note note,
    required Clef? clef,
    required FontMetadata font,
  }) {
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

    return StemlessNoteElement(
      dots: dots,
      accidental: accidental,
      head: NoteheadElement(
        type: type,
        font: font,
        ledgerLines: LedgerLines.fromElementPosition(position),
      ),
      position: position,
    );
  }

  Size get size {
    double height = head.size.height;
    double width = head.size.width;

    if (dots != null) {
      Size dotsSize = dots!.size;

      width += dotsSize.width;
      width += AugmentationDots.defaultBaseOffset;

      // if (note.stem?.direction == StemDirection.down &&
      //     position.numeric % 2 == 0) {
      //   height += dotsSize.height / 2;
      // }
    }
    if (accidental != null) {
      Size accidentalSize = accidental!.size;

      width += accidentalSize.width;
      // Space between notehead and accidental.
      width += NotationLayoutProperties.noteAccidentalDistance;

      height = accidentalSize.height;
    }

    return Size(width, height);
  }

  /// Vertical offset for head
  double get _headOffset => -NotationLayoutProperties.baseSpacePerPosition;

  /// Vertical offset for accidental
  double get _accidentalOffset => accidental!.alignmentPosition.top!;

  static const double _dotOffsetAdjustment = 0.1;

  double get _dotVerticalOffset {
    double offest = -(dots?.alignmentPosition.top ?? 0);
    if (position.numeric % 2 == 0) {
      offest -= dots!.size.height;
      offest -= _dotOffsetAdjustment;
    }
    return offest;
  }

  AlignmentPosition get alignmentPosition {
    {
      var spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;

      double bottom = -spacePerPosition;
      double left = 0;

      if (dots != null && position.numeric % 2 == 0) {
        bottom += _dotOffsetAdjustment;
      }

      if (accidental != null) {
        bottom = _accidentalOffset.abs() - size.height;
        left = accidental!.size.width;
        left += NotationLayoutProperties.noteAccidentalDistance;
      }

      return AlignmentPosition(
        bottom: bottom,
        left: left,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: AlignedRow(
        alignment: VerticalAlignment.top,
        children: [
          if (accidental != null)
            Offsetted(
              offset: Offset(0, _accidentalOffset.scaledByContext(context)),
              child: Padding(
                padding: EdgeInsets.only(
                  right: NotationLayoutProperties.noteAccidentalDistance,
                ).scaledByContext(context),
                child: accidental!,
              ),
            ),
          Offsetted(
            offset: Offset(0, _headOffset.scaledByContext(context)),
            child: head,
          ),
          if (dots != null)
            Offsetted(
              offset: Offset(0, _dotVerticalOffset.scaledByContext(context)),
              child: Padding(
                padding: EdgeInsets.only(
                  left: AugmentationDots.defaultBaseOffset,
                ).scaledByContext(context),
                child: dots!,
              ),
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

  final StemDirection direction;

  /// Length in stave spaces
  final double length;

  /// Determines if flag should be shown with stem. By default it is true;
  final bool showFlag;

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

  AlignmentPosition _flagPosition(StemDirection direction) {
    if (direction == StemDirection.down) {
      return AlignmentPosition(left: 0, bottom: 0);
    }
    return AlignmentPosition(left: 0, top: 0);
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

    return SizedBox.fromSize(
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
  Size get size => _bBox(font).toSize();

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
      size: size.scaledByContext(context),
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
