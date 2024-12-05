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
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dot.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

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
  final ElementPosition position;

  @override
  final StemDirection? stemDirection;

  @override
  final double baseStemLength;

  @override
  final double duration;

  bool get _stemmed => baseStemLength != 0;

  final bool showLedger;
  final bool showFlag;

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
      font: font,
      baseStemLength: stemLength ?? _calculateStemLength(note, notationContext),
      showLedger: showLedger,
      showFlag: showFlag,
      duration: note.determineDuration(),
      stemDirection: note.stem == null
          ? null
          : StemDirection.fromStemValue(note.stem!.value),
      position: determinePosition(note, notationContext.clef),
    );
  }

  const NoteElement._({
    super.key,
    required this.note,
    required this.position,
    required this.baseStemLength,
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
      bottom = -1 / 2;
    }

    if (_stemmed && stemDirection == StemDirection.down) {
      top = -1 / 2;
      if (position.numeric % 2 == 0 && _dots > 0) {
        top -= baseDotsSize(font).height / 2;
      }
    }

    if (_accidental != null && stemDirection == StemDirection.down) {
      AlignmentPosition accidentalAlignmentPosition =
          AccidentalElement.calculateAlignmentPosition(_accidental!, font);

      top = (accidentalAlignmentPosition.top ?? 0);
    }

    if (top == null && bottom == null) {
      top = -1 / 2;
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
      leftOffset -= 1 / 4;
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
    double offsetY = baseSize.height;

    if (stemDirection == StemDirection.down) {
      offsetX = NotationLayoutProperties.baseStemStrokeWidth / 2;
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

    double stemLength = NotationLayoutProperties.baseStandardStemLength;

    var position = determinePosition(note, context.clef);

    int distance = 0;

    if (position >= ElementPosition.secondLedgerAbove) {
      distance = position.distance(ElementPosition.secondLedgerAbove) + 1;
    }

    if (position <= ElementPosition.secondLedgerBelow) {
      distance = position.distance(ElementPosition.secondLedgerBelow) + 1;
    }

    stemLength += distance * .5;
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
  Size get baseSize => calculateBaseSize(
        note: note,
        clef: notationContext.clef,
        stemLength: baseStemLength,
        stemDirection: stemDirection,
        font: font,
        showFlag: false, // ????
      );

  Size get noteheadSize => NoteheadElement(
        font: font,
        type: note.type?.value ?? NoteTypeValue.quarter,
      ).baseSize;

  static Size calculateBaseSize({
    required Note note,
    required ElementPosition position,
    required double stemLength,
    required StemDirection? stemDirection,
    required FontMetadata font,
    bool showFlag = true,
  }) {
    double width = 0;
    double height = 0;

    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    NoteheadElement notehead = NoteheadElement(
      font: font,
      type: note.type?.value ?? NoteTypeValue.quarter,
    );

    StemElement? stem;

    if (stemLength != 0 && stemDirection != null) {
      stem = StemElement(
        type: type,
        length: stemLength,
        showFlag: note.beams.isEmpty && showFlag,
        direction: stemDirection,
        font: font,
      );
    }

    SimpleNoteElement noteElement = SimpleNoteElement(
      notehead: notehead,
      stem: stem,
    );

    Size noteSize = noteElement.baseSize;

    height = noteSize.height;
    width = notehead.baseSize.width;

    if (note.dots.isNotEmpty) {
      width += baseDotsSize(font).width;
      width += baseDotsOffset;

      ElementPosition position = determinePosition(note, clef);
      if (note.stem?.value == StemValue.down && position.numeric % 2 == 0) {
        height += baseDotsSize(font).height / 2;
      }
    }

    AccidentalValue? accidental = note.accidental?.value;

    if (accidental != null) {
      Size accidentalSize = AccidentalElement.calculateSize(accidental, font);
      width += accidentalSize.width;
      // Space between notehead and accidental.
      width += 1 / 4;

      AlignmentPosition accidentalAlignmentPosition =
          AccidentalElement.calculateAlignmentPosition(accidental, font);

      height += (accidentalAlignmentPosition.top?.abs() ?? 0) / 2;
    }

    return Size(width, height);
  }

  double get verticalAlignmentAxisOffset {
    if (_stemmed && stemDirection == StemDirection.up) {
      return baseStemLength;
    }

    // When note is on drawn the line and it's stem is drawn down,
    // the dots size must be taken in the account.
    if (stemDirection == StemDirection.down &&
        position.numeric % 2 == 0 &&
        _dots > 0) {
      return 1 / 2 + baseDotsSize(font).height / 2;
    }
    return 1 / 2;
  }

  int get _dots {
    return note.dots.length;
  }

  static Size baseDotsSize(FontMetadata font) {
    return AugmentationDot(count: 1, font: font).baseSize;
  }

  AccidentalValue? get _accidental => note.accidental?.value;

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    Size dotsSize = baseDotsSize(font).scaledByContext(context);

    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    double? dotsTopPosition;
    double? dotsBottomPosition;

    double dotsOffsetFromNotehead = position.numeric % 2 != 0
        ? noteheadSize.height / 2 // Between lines
        : layoutProperties.staveSpace; // On the line

    if (stemDirection == StemDirection.down) {
      // Somehow it works, probably because of pixel snapping nuances
      dotsOffsetFromNotehead -= (dotsSize.height / 2).ceil();
      dotsTopPosition = dotsOffsetFromNotehead;
    }
    // When note is on drawn the line and it's stem is drawn down,
    // it's dot needs to be positioned above note.
    if (stemDirection == StemDirection.down &&
        position.numeric % 2 == 0 &&
        _dots > 0) {
      dotsOffsetFromNotehead = 0;
      dotsTopPosition = dotsOffsetFromNotehead;
    }

    if (stemDirection == StemDirection.up) {
      // Somehow it works, probably because of pixel snapping nuances
      dotsOffsetFromNotehead -= (dotsSize.height / 2).floor();
      dotsBottomPosition = dotsOffsetFromNotehead;
    }

    AccidentalElement? accidentalElement;

    if (_accidental != null) {
      accidentalElement = AccidentalElement(
        accidental: _accidental!,
        font: font,
      );
    }

    StemElement? stem;

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: baseStemLength,
        showFlag: note.beams.isEmpty && showFlag,
        direction: stemDirection!,
      );
    }

    return SizedBox.fromSize(
      size: baseSize.scaledByContext(context),
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
                child: AugmentationDot(
                  count: _dots,
                  font: font,
                )),
          if (accidentalElement != null)
            Positioned(
              left: 0,
              top: stemDirection == StemDirection.down ? 0 : null,
              bottom: stemDirection == StemDirection.up ? 0 : null,
              child: accidentalElement,
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
