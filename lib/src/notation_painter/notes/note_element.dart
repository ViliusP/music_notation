import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/notehead.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_font.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dot.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/dots_painter.dart';
import 'package:music_notation/src/notation_painter/painters/note_painter.dart';
import 'package:music_notation/src/notation_painter/painters/stem_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/notation_rendering_exception.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

const Map<String, Color> _voiceColors = {
  "0": Color.fromRGBO(0, 0, 0, 1),
  "1": Color.fromRGBO(121, 0, 0, 1),
  "2": Color.fromRGBO(0, 133, 40, 1),
  "3": Color.fromRGBO(206, 192, 0, 1),
};

/// Notes below line 3 have up stems on the right side of the notehead.
///
/// Notes on or above line 3 have down stems on the left side of the notehead.
///
/// The stem is always placed between the two notes of an interval of a 2nd,
/// with the upper note always to the right, the lower note always to the left.
///
/// When two notes share a stem:
/// - If the interval above the middle line is greater, the stem goes down;
/// - If the interval below the middle line is greater, the stem goes up;
/// - If the intervals above and below the middle ine are equidistant, the stem
/// goes down;
///
/// When more than two notes share a stem, the direction is determined by the
/// highest and the lowest notes:
/// - If the interval from the highest note to the middle line is greater,
/// the stem goes down;
/// - If the interval from the lowest note to the middle line is greater, the
/// stem goes up;
/// - If equidistant the stem goes down.
///
/// If you are writing two voices on the same staff, the stems for the upper
/// voice will go up, and the stems for the lower voice will go down.
class NoteElement extends StatelessWidget implements RhythmicElement {
  final Note note;

  @override
  final StemDirection? stemDirection;

  @override
  final double stemLength;

  @override
  final double duration;

  bool get _stemmed => stemLength != 0;

  final bool showLedger;
  final bool showFlag;

  @override
  final NotationContext notationContext;

  @override
  ElementPosition get position => determinePosition(note, notationContext.clef);

  final bool drawLedgerLines = true;

  final FontMetadata font;

  /// Create [NoteElement] from musicXML [note]. Throws exception if divisions of
  /// [notationContext] is null.
  factory NoteElement.fromNote({
    Key? key,
    required Note note,
    required FontMetadata font,
    required NotationContext notationContext,
    double? stemLength,
    bool showFlag = true,
    bool showLedger = true,
  }) {
    if (notationContext.divisions == null) {
      throw ArgumentError(
        "Divisions in notationContext cannot be null on note's initialization",
      );
    }

    return NoteElement._(
      key: key,
      note: note,
      notationContext: notationContext,
      font: font,
      stemLength: stemLength ?? _calculateStemLength(note, notationContext),
      showLedger: showLedger,
      showFlag: showFlag,
      duration: note.determineDuration(),
      stemDirection: note.stem == null
          ? null
          : StemDirection.fromStemValue(note.stem!.value),
    );
  }

  const NoteElement._({
    super.key,
    required this.note,
    required this.notationContext,
    this.stemLength = NotationLayoutProperties.standardStemLength,
    this.showFlag = true,
    this.showLedger = true,
    required this.duration,
    this.stemDirection,
    required this.font,
  });

  @override
  AlignmentPosition get alignmentPosition {
    double? bottom;
    double? top;

    if (_stemmed && stemDirection == StemDirection.up) {
      bottom = -NotationLayoutProperties.staveSpace / 2;
    }

    if (_stemmed && stemDirection == StemDirection.down) {
      top = -NotationLayoutProperties.staveSpace / 2;
      if (position.numeric % 2 == 0 && _dots > 0) {
        top -= _dotsSize.height / 2;
      }
    }

    if (top == null && bottom == null) {
      top = -NotationLayoutProperties.staveSpace / 2;
    }

    return AlignmentPosition(
      top: top,
      bottom: bottom,
      left: _calculateAlignmentOffset(font),
    );
  }

  double _calculateAlignmentOffset(FontMetadata font) {
    double leftOffset = 0;

    AccidentalValue? accidental = note.accidental?.value;

    if (accidental != null) {
      Size accidentalSize = AccidentalElement.calculateSize(accidental, font);
      leftOffset -= accidentalSize.width;
      // Space between notehead and accidental.
      leftOffset -= NotationLayoutProperties.staveSpace / 4;
    }

    return leftOffset;
  }

  /// Relative offset from bounding box bottom left if [AlignmentPosition.top] is defined.
  /// Relative offset from bounding box top left if [AlignmentPosition.bottom] is defined.
  ///
  /// X - the middle of stem.
  /// Y - the tip of stem.
  @override
  Offset get offsetForBeam {
    double? offsetX;
    double offsetY = size.height;

    if (stemDirection == StemDirection.down) {
      offsetX = NotationLayoutProperties.stemStrokeWidth / 2;
    }

    if (_accidental != null) {
      offsetX ??= noteheadSize.width;
      offsetX -= alignmentPosition.left;
    }

    return Offset(
      offsetX ?? noteheadSize.width,
      offsetY,
    );
  }

  /// Default stem length: `3.5*stave_space`.
  ///
  /// Stems for notes on more than one ledger line extend to the middle stave-line
  static double _calculateStemLength(Note note, NotationContext context) {
    if (note.type?.value.stemmed != true) {
      return 0.0;
    }

    double stemLength = NotationLayoutProperties.standardStemLength;

    var position = determinePosition(note, context.clef);

    int distance = 0;

    if (position >= ElementPosition.secondLedgerAbove) {
      distance = position.distance(ElementPosition.secondLedgerAbove) + 1;
    }

    if (position <= ElementPosition.secondLedgerBelow) {
      distance = position.distance(ElementPosition.secondLedgerBelow) + 1;
    }

    stemLength += distance * NotationLayoutProperties.staveSpace / 2;
    return stemLength;
  }

  static ElementPosition determinePosition(Note note, Clef? clef) {
    switch (note) {
      case GraceTieNote _:
        throw UnimplementedError(
          "Grace tie note is not implemented yet in renderer",
        );
      case GraceCueNote _:
        throw UnimplementedError(
          "Grace cue note is not implemented yet in renderer",
        );
      case CueNote _:
        throw UnimplementedError(
          "Cue note is not implemented yet in renderer",
        );
      case RegularNote _:
        NoteForm noteForm = note.form;
        Step? step;
        int? octave;
        switch (noteForm) {
          case Pitch _:
            step = noteForm.step;
            octave = noteForm.octave;
            // step = Step.B;
            // octave = 4;
            break;
          case Unpitched _:
            step = noteForm.displayStep;
            octave = noteForm.displayOctave;
          case Rest _:
            throw ArgumentError(
              "If note's form is `rest`, please use RestElemenent to render it",
            );
        }

        final position = ElementPosition(
          step: step,
          octave: octave,
        );

        if (clef == null) {
          return position;
        }

        // Unpitched notes probably shouldn't be transposed;
        return position.transpose(ElementPosition.transposeIntervalByClef(
          clef,
        ));

      default:
        throw UnimplementedError(
          "This error shouldn't occur, TODO: make switch exhaustively matched",
        );
    }
  }

  @override
  Size get size => calculateSize(
        note: note,
        clef: notationContext.clef,
        stemLength: stemLength,
        font: font,
        showFlag: false,
      );

  Size get noteheadSize => NoteheadElement(
        note: note,
      ).size(font);

  static Size calculateSize({
    required Note note,
    required Clef? clef,
    required double stemLength,
    required FontMetadata font,
    bool showFlag = true,
  }) {
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    var noteheadSize = NoteheadElement(
      note: note,
    ).size(font);

    double width = noteheadSize.width;
    double height = noteheadSize.height;

    if (stemLength != 0) {
      width = width - NotationLayoutProperties.stemStrokeWidth;

      var stemElement = StemElement(
        type: type,
        length: stemLength,
        showFlag: note.beams.isEmpty && showFlag,
      );

      width += stemElement.size.width;
      height += stemElement.size.height - noteheadSize.height / 2;
    }

    if (note.dots.isNotEmpty) {
      width += dotsSize(font).width;
      width += dotsOffset();

      ElementPosition position = determinePosition(note, clef);
      if (note.stem?.value == StemValue.down && position.numeric % 2 == 0) {
        height += dotsSize(font).height / 2;
      }
    }

    AccidentalValue? accidental = note.accidental?.value;

    if (accidental != null) {
      Size accidentalSize = AccidentalElement.calculateSize(accidental, font);
      width += accidentalSize.width;
      // Space between notehead and accidental.
      width += NotationLayoutProperties.staveSpace / 4;
    }

    return Size(width, height);
  }

  double get verticalAlignmentAxisOffset {
    if (_stemmed && stemDirection == StemDirection.up) {
      return stemLength;
    }

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stemDirection == StemDirection.down &&
        position.numeric % 2 == 0 &&
        _dots > 0) {
      return NotationLayoutProperties.staveSpace / 2 + _dotsSize.height / 2;
    }
    return NotationLayoutProperties.staveSpace / 2;
  }

  int get _dots {
    return note.dots.length;
  }

  double get _dotsRightOffset => dotsOffset();

  /// Calculates the offset for [_dots] based on the right side of the note.
  /// This offset is typically half of the stave space and is added to the note size.
  static double dotsOffset() {
    // Distance from note to dot is conventionally half the stave space.
    double defaultOffset = NotationLayoutProperties.staveSpace / 2;

    return defaultOffset;
  }

  Size get _dotsSize => dotsSize(font);

  static Size dotsSize(FontMetadata font) {
    const double referenceStaveHeight = 50;
    const Size defaultSize = Size(5, 4.95); // Size when stave height is 50;
    const double scaleFactor =
        NotationLayoutProperties.staveHeight / referenceStaveHeight;
    Size scaledDefaultSize = Size(
      defaultSize.width * scaleFactor,
      defaultSize.height * scaleFactor,
    );

    Size? glyphSize = font.glyphBBoxes[CombiningStaffPositions.augmentationDot]
        ?.toRect()
        .size;
    return glyphSize ?? scaledDefaultSize;
  }

  AccidentalValue? get _accidental => note.accidental?.value;

  @override
  Widget build(BuildContext context) {
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;
    LedgerLines? ledgerLines;

    if (showLedger) {
      ledgerLines = LedgerLines.fromElementPosition(position);
    }
    var notehead = NoteheadElement(
      note: note,
      ledgerLines: ledgerLines,
      // color: _voiceColors[note.editorialVoice.voice ?? "0"]!, // Colors by voice
    );

    var stemLeftPadding = NotationLayoutProperties.stemStrokeWidth / 2;
    var stemTopPadding = NotationLayoutProperties.defaultNoteheadHeight / 2;
    var stemBottomPadding = 0.0;

    if (stemDirection == StemDirection.up) {
      stemLeftPadding = noteheadSize.width;
      stemLeftPadding -= NotationLayoutProperties.stemStrokeWidth / 2;
      stemTopPadding = 0;
      stemBottomPadding = NotationLayoutProperties.defaultNoteheadHeight / 2;
    }

    stemLeftPadding += alignmentPosition.left.abs();

    double? dotsTopPosition;
    double? dotsBottomPosition;

    double dotsOffsetFromNotehead = position.numeric % 2 != 0
        ? noteheadSize.height / 2 // Between lines
        : NotationLayoutProperties.staveSpace; // On the line

    if (stemDirection == StemDirection.down) {
      // Somehow it works, probably because of pixel snapping nuances
      dotsOffsetFromNotehead -= (_dotsSize.height / 2).ceil();
      dotsTopPosition = dotsOffsetFromNotehead;
    }
    double dotVerticalOffset = 0;
    // When note is on drawn the line and it's stem is drawn down,
    // it's dot needs to be positioned above note.
    if (stemDirection == StemDirection.down &&
        position.numeric % 2 == 0 &&
        _dots > 0) {
      dotsOffsetFromNotehead = 0;
      dotVerticalOffset = _dotsSize.height / 2;
      dotsTopPosition = dotsOffsetFromNotehead;
    }

    if (stemDirection == StemDirection.up) {
      // Somehow it works, probably because of pixel snapping nuances
      dotsOffsetFromNotehead -= (_dotsSize.height / 2).floor();
      dotsBottomPosition = dotsOffsetFromNotehead;
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          Positioned(
            top: stemDirection == StemDirection.down ? dotVerticalOffset : null,
            bottom: stemDirection == StemDirection.up ? 0 : null,
            left: alignmentPosition.left.abs(),
            child: notehead,
          ),
          if (_dots > 0)
            Positioned(
              right: 0,
              top: dotsTopPosition,
              bottom: dotsBottomPosition,
              child: CustomPaint(
                size: _dotsSize,
                painter: DotsPainter(_dots, AugmentationDot.defaultSpacing),
              ),
            ),
          if (_accidental != null)
            Positioned(
              left: 0,
              top: stemDirection == StemDirection.down
                  ? dotVerticalOffset
                  : null,
              bottom: stemDirection == StemDirection.up ? 0 : null,
              child: AccidentalElement(
                accidental: _accidental!,
                font: font,
              ),
            ),
          if (_stemmed)
            Padding(
              padding: EdgeInsets.only(
                bottom: stemBottomPadding,
                top: stemTopPadding + dotVerticalOffset,
                left: stemLeftPadding,
              ),
              child: StemElement(
                length: stemLength,
                type: type,
                direction: stemDirection!,
                showFlag: note.beams.isEmpty && showFlag,
              ),
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
      StringProperty(
        'Position',
        position.toString(),
        defaultValue: null,
        level: level,
        showName: true,
      ),
    );
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
    String? flagSmufl = type.upwardFlag;

    if (direction == StemDirection.down) {
      flagSmufl = type.downwardFlag;
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

extension NoteVisualInformation on NoteTypeValue {
  bool get stemmed {
    switch (this) {
      case NoteTypeValue.n1024th:
        return true;
      case NoteTypeValue.n512th:
        return true;
      case NoteTypeValue.n256th:
        return true;
      case NoteTypeValue.n128th:
        return true;
      case NoteTypeValue.n64th:
        return true;
      case NoteTypeValue.n32nd:
        return true;
      case NoteTypeValue.n16th:
        return true;
      case NoteTypeValue.eighth:
        return true;
      case NoteTypeValue.quarter:
        return true;
      case NoteTypeValue.half:
        return true;
      case NoteTypeValue.whole:
        return false;
      case NoteTypeValue.breve:
        return false;
      case NoteTypeValue.long:
        return false;
      case NoteTypeValue.maxima:
        return false;
    }
  }

  String? get upwardFlag {
    switch (this) {
      case NoteTypeValue.n1024th:
        return '\uE24E';
      case NoteTypeValue.n512th:
        return '\uE24C';
      case NoteTypeValue.n256th:
        return '\uE24A';
      case NoteTypeValue.n128th:
        return '\uE248';
      case NoteTypeValue.n64th:
        return '\uE246';
      case NoteTypeValue.n32nd:
        return '\uE244';
      case NoteTypeValue.n16th:
        return '\uE242';
      case NoteTypeValue.eighth:
        return '\uE240';
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

  String? get downwardFlag {
    switch (this) {
      case NoteTypeValue.n1024th:
        return '\uE24F';
      case NoteTypeValue.n512th:
        return '\uE24D';
      case NoteTypeValue.n256th:
        return '\uE24B';
      case NoteTypeValue.n128th:
        return '\uE249';
      case NoteTypeValue.n64th:
        return '\uE247';
      case NoteTypeValue.n32nd:
        return '\uE245';
      case NoteTypeValue.n16th:
        return '\uE243';
      case NoteTypeValue.eighth:
        return '\uE241';
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

/// Enumerates the possible placements of ledger lines in relation to a note.
/// Ledger lines can be positioned either above or below a note symbol.
enum LedgerPlacement {
  /// Indicates that the ledger line(s) is positioned above the note symbol.
  above,

  /// Indicates that the ledger line(s) is positioned below the note symbol.
  below,
}

/// Represents the configuration of ledger lines for a particular note or element.
class LedgerLines {
  /// The number of ledger lines needed for the note or element.
  final int count;

  /// The placement of the ledger lines relative to the note or element.
  final LedgerPlacement placement;

  /// Indicates whether the ledger line extends through or intersects the note's head.
  /// When set to `true`, the ledger line will pass through the note's head, which is typically
  /// seen for notes that are directly adjacent to the staff.
  final bool extendsThroughNote;

  LedgerLines({
    required this.count,
    required this.placement,
    required this.extendsThroughNote,
  });

  static LedgerLines? fromElementPosition(ElementPosition position) {
    const middleDistanceToOuterLine = 4;
    int distance = position.distanceFromMiddle;

    var placement = LedgerPlacement.below;
    // if positive
    if (!distance.isNegative) {
      placement = LedgerPlacement.above;
    }
    distance = distance.abs();

    if (distance <= middleDistanceToOuterLine + 1) return null;
    distance -= middleDistanceToOuterLine;

    return LedgerLines(
      count: (distance / 2).floor(),
      placement: placement,
      extendsThroughNote: ((distance / 2) % 1) == 0,
    );
  }

  /// Creates a copy of the current [LedgerLines] instance with optional modifications.
  LedgerLines copyWith({
    int? count,
    LedgerPlacement? placement,
    bool? extendsThroughNote,
  }) {
    return LedgerLines(
      count: count ?? this.count,
      placement: placement ?? this.placement,
      extendsThroughNote: extendsThroughNote ?? this.extendsThroughNote,
    );
  }

  @override
  String toString() =>
      '_LedgerLines(count: $count, placement: $placement, extendsThroughNote: $extendsThroughNote)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LedgerLines &&
        other.count == count &&
        other.placement == placement &&
        other.extendsThroughNote == extendsThroughNote;
  }

  @override
  int get hashCode =>
      count.hashCode ^ placement.hashCode ^ extendsThroughNote.hashCode;
}
