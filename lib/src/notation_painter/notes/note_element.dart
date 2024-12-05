import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/augmentation_dots.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/notation_painter/utilities/padding_extensions.dart';
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
  final SimpleNoteElement note;

  final AccidentalElement? accidental;

  final AugmentationDots? dots;

  @override
  final ElementPosition position;

  @override
  final double duration;

  bool get _stemmed => (note.stem?.length ?? 0) > 0;

  @override
  double get baseStemLength => note.stem?.length ?? 0;

  @override
  StemDirection? get stemDirection => note.stem?.direction;

  final FontMetadata font;

  final String? voice;

  final List<Beam> beams;

  /// Create [NoteElement] from musicXML [note].
  factory NoteElement.fromNote({
    Key? key,
    required Note note,
    required FontMetadata font,
    Clef? clef,
    double? stemLength,
    bool showFlag = true,
    bool showLedger = true,
  }) {
    AccidentalElement? accidental;
    if (note.accidental != null) {
      accidental = AccidentalElement(
        type: note.accidental!.value,
        font: font,
      );
    }

    ElementPosition position = determinePosition(note, clef);

    NoteTypeValue type = note.type?.value ?? NoteTypeValue.quarter;

    double baseStemLength = stemLength ?? _calculateStemLength(note, position);
    StemElement? stem;
    StemDirection? stemDirection = note.stem == null
        ? null
        : StemDirection.fromStemValue(note.stem!.value);

    if (stemDirection != null) {
      stem = StemElement(
        type: type,
        font: font,
        length: baseStemLength,
        showFlag: note.beams.isEmpty && showFlag,
        direction: stemDirection,
      );
    }

    AugmentationDots? dots;
    if (note.dots.isNotEmpty) {
      dots = AugmentationDots(count: note.dots.length, font: font);
    }

    return NoteElement._(
      key: key,
      note: SimpleNoteElement(
        head: NoteheadElement(
          type: type,
          font: font,
          ledgerLines: LedgerLines.fromElementPosition(position),
        ),
        stem: stem,
      ),
      font: font,
      accidental: accidental,
      position: position,
      duration: note.determineDuration(),
      voice: note.editorialVoice.voice,
      beams: note.beams,
      dots: dots,
    );
  }

  const NoteElement._({
    super.key,
    required this.note,
    required this.accidental,
    this.dots,
    required this.position,
    required this.duration,
    required this.font,
    this.voice,
    this.beams = const [],
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
      if (position.numeric % 2 == 0 && dots != null) {
        top -= dots!.baseSize.height / 2;
      }
    }

    // if (_accidental != null && stemDirection == StemDirection.down) {
    //   AlignmentPosition accidentalAlignmentPosition = AccidentalElement(
    //     accidental: _accidental!,
    //     font: font,
    //   ).alignmentPosition;

    //   top = (accidentalAlignmentPosition.top ?? 0);
    // }

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

    if (accidental != null) {
      Size accidentalSize = accidental!.baseSize;
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

    if (accidental != null) {
      offsetX ??= note.head.baseSize.width;
      offsetX -= alignmentPosition.left;
    }

    return Offset(
      offsetX ?? note.head.baseSize.width,
      offsetY,
    );
  }

  /// Default stem length: `3.5*stave_space`.
  ///
  /// Stems for notes on more than one ledger line extend to the middle stave-line
  static double _calculateStemLength(Note note, ElementPosition position) {
    if (note.type?.value.stemmed != true) {
      return 0.0;
    }

    double stemLength = NotationLayoutProperties.baseStandardStemLength;

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
        position: position,
        font: font,
        dots: dots,
        accidental: accidental,
      );

  static Size calculateBaseSize({
    required SimpleNoteElement note,
    required AugmentationDots? dots,
    required AccidentalElement? accidental,
    required ElementPosition position,
    required FontMetadata font,
  }) {
    Size noteSize = note.baseSize;

    double height = noteSize.height;
    double width = noteSize.width;

    if (dots != null) {
      Size dotsSize = dots.baseSize;

      width += dotsSize.width;
      width += AugmentationDots.defaultBaseOffset;

      if (note.stem?.direction == StemDirection.down &&
          position.numeric % 2 == 0) {
        height += dotsSize.height / 2;
      }
    }

    if (accidental != null) {
      Size accidentalSize = accidental.baseSize;

      width += accidentalSize.width;
      // Space between notehead and accidental.
      width += 1 / 4; // ???????????????????????

      AlignmentPosition accidentalPosition = accidental.alignmentPosition;

      height += (accidentalPosition.top?.abs() ?? 0) / 2;
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
        dots != null) {
      return 1 / 2 + dots!.baseSize.height / 2;
    }
    return 1 / 2;
  }

  Alignment get _dotsAlignment {
    if (stemDirection == StemDirection.down) {
      return Alignment.topRight;
    }
    return Alignment.bottomRight;
  }

  EdgeInsets get _dotsPadding {
    if (dots == null) {
      return VerticalEdgeInsets(top: 0, bottom: 0);
    }

    double dotsTopPosition = 0;
    double dotsBottomPosition = 0;

    var augmentationDotHeight = dots!.baseSize.height;

    double dotsOffsetFromNotehead = position.numeric % 2 != 0
        ? note.head.baseSize.height / 2 // Between lines
        : 1; // On the line

    if (stemDirection == StemDirection.down) {
      dotsOffsetFromNotehead -= (augmentationDotHeight / 2);
      dotsTopPosition = dotsOffsetFromNotehead;
    }
    // When note is on drawn the line and it's stem is drawn down,
    // it's dot needs to be positioned above note.
    if (stemDirection == StemDirection.down && position.numeric % 2 == 0) {
      dotsOffsetFromNotehead = 0;
      dotsTopPosition = dotsOffsetFromNotehead;
    }

    if (stemDirection == StemDirection.up) {
      dotsOffsetFromNotehead -= (augmentationDotHeight / 2);
      dotsBottomPosition = dotsOffsetFromNotehead;
    }

    return EdgeInsets.only(
      left: AugmentationDots.defaultBaseOffset,
      top: dotsTopPosition,
      bottom: dotsBottomPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    // NotationLayoutProperties layoutProperties =
    //     NotationProperties.of(context)?.layout ??
    //         NotationLayoutProperties.standard();

    return SizedBox.fromSize(
      size: baseSize.scaledByContext(context),
      child: Row(
        children: [
          if (accidental != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: 0,
                left: 0,
              ),
              child: Align(
                alignment: _dotsAlignment,

                // left: 0,
                // top: stemDirection == StemDirection.down ? 0 : null,
                // bottom: stemDirection == StemDirection.up ? 0 : null,
                child: accidental,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: note,
          ),
          if (dots != null)
            Padding(
              padding: _dotsPadding.scaledByContext(context),
              child: Align(
                alignment: _dotsAlignment,
                child: dots,
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
