import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dot.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/painters/dots_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

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
        font: font,
        type: note.type?.value ?? NoteTypeValue.quarter,
      ).size;

  static Size calculateSize({
    required Note note,
    required Clef? clef,
    required double stemLength,
    required FontMetadata font,
    bool showFlag = true,
  }) {
    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    var noteheadSize = NoteheadElement(
      font: font,
      type: note.type?.value ?? NoteTypeValue.quarter,
    ).size;

    double width = noteheadSize.width;
    double height = noteheadSize.height;

    if (stemLength != 0) {
      width = width - NotationLayoutProperties.stemStrokeWidth;

      var stemElement = StemElement(
        type: type,
        length: stemLength,
        showFlag: note.beams.isEmpty && showFlag,
        font: font,
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

    StemElement? stem;

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: stemLength,
        showFlag: note.beams.isEmpty && showFlag,
        direction: stemDirection!,
      );
    }

    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          SimpleNoteElement(
            stem: stem,
            notehead: NoteheadElement(
              type: type,
            font: font,
            ledgerLines: LedgerLines.fromElementPosition(position),
            ),
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
              child: AccidentalElement,
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
