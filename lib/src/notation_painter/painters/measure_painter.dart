import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/models/visual_note_element.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/utilties.dart';
import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

class MeasurePainter extends CustomPainter {
  final MeasureSequence sequence;

  MeasurePainter(this.sequence);

  @override
  void paint(Canvas canvas, Size size) {
    _paintMeasure(
      sequence: sequence,
      canvas: canvas,
      size: size,
    );
  }

  /// Painting noteheads, it should fill the space between two lines, touching
  /// the stave-line on each side of it, but without extending beyond either line.
  ///
  /// Notes on a line should be precisely centred on the stave-line.
  void _paintMeasure({
    required MeasureSequence sequence,
    required Canvas canvas,
    required Size size,
  }) {
    final context = StaffPainterContext();

    for (var column in sequence) {
      VisualNoteElement? lowestNote;
      VisualNoteElement? highestNote;
      double? rightMargin;
      for (var element in column) {
        var musicElement = element;
        if (musicElement == null) continue;
        if (musicElement.defaultMargins != null) {
          context.moveX(musicElement.defaultMargins!.left);
          rightMargin = musicElement.defaultMargins!.right;
        }

        var offset = context.offset +
            musicElement.defaultOffset +
            musicElement.position.step
                .calculteOffset(musicElement.position.octave);

        // 'highestNote' is same as note before.
        // The stem is always placed between the two notes of an interval of a 2nd,
        // with the upper note always to the right, the lower note always to the left.
        if (highestNote != null && musicElement is VisualNoteElement) {
          var distance = (highestNote.position.numericPosition -
                  musicElement.position.numericPosition)
              .abs();
          if (distance == 1) {
            offset += const Offset(14, 0);
          }
        }

        PainterUtilities.drawSmuflSymbol(
          canvas,
          // offset,
          musicElement.symbol,
        );
        if (musicElement is VisualNoteElement) {
          lowestNote ??= musicElement;
          highestNote = musicElement;
        }
      }
      if (lowestNote != null) {
        // _paintLedgerLines(
        //   count: lowestNote.ledgerLines,
        //   noteheadWidth: lowestNote.noteheadWidth,
        //   canvas: canvas,
        //   size: size,
        //   context: context,
        // );
      }
      _drawStemForColumn(
        lowestNote,
        highestNote,
        canvas: canvas,
        size: size,
        context: context,
      );

      context.moveX(rightMargin ?? 48);
    }
  }

  /// Notes below line 3 have up stems on the right side of the notehead.
  ///
  /// Notes on or above line 3 have down stems on the left side of the notehead.
  ///
  /// The stem is awalys placed between the two notes of an interval of a 2nd,
  /// with the upper note always to the right, the lower note always to the left.
  ///
  /// When two notes share a stem:
  /// - If the interval above the middle line is greater, the stem goes down;
  /// - If the interval below the middle line is geater, the stem goes up;
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
  /// TODO: need to take account of different voices on the same staff:
  /// If you are writing two vocies on the same staff, the stems for the upper
  /// voice will go up, and the stems for the lower voice will go down.
  void _drawStemForColumn(
    VisualNoteElement? lowestNote,
    VisualNoteElement? highestNote, {
    required StaffPainterContext context,
    required Canvas canvas,
    required Size size,
  }) {
    // If only one note exists in column.
    // if (lowestNote != null && lowestNote == highestNote && lowestNote.stemmed) {
    //   var offset = context.offset +
    //       lowestNote.defaultOffset +
    //       lowestNote.position.step.calculteOffset(lowestNote.position.octave);

    //   final StemValue stemDirection =
    //       lowestNote.distanceFromMiddle < 0 ? StemValue.up : StemValue.down;

    //   String? flagSymbol = stemDirection == StemValue.up
    //       ? lowestNote.flagUpSymbol
    //       : lowestNote.flagDownSymbol;

    //   _drawStem(
    //     noteOffset: offset,
    //     flagSymbol: flagSymbol,
    //     direction: stemDirection,
    //     canvas: canvas,
    //     size: size,
    //   );
    // }
    if (lowestNote != null &&
        highestNote != null &&
        lowestNote != highestNote) {
      StemValue stemDirection = StemValue.down;
      if (lowestNote.distanceFromMiddle.abs() >
          highestNote.distanceFromMiddle.abs()) {
        stemDirection = StemValue.up;
      }

      var lowestNoteOffsetY = context.offset +
          lowestNote.defaultOffset +
          lowestNote.position.step.calculteOffset(lowestNote.position.octave);

      var highestNoteOffsetY = context.offset +
          highestNote.defaultOffset +
          highestNote.position.step.calculteOffset(highestNote.position.octave);

      Offset notesOffset = lowestNoteOffsetY;
      if (lowestNote.distanceFromMiddle.abs() <
          highestNote.distanceFromMiddle.abs()) {
        notesOffset = highestNoteOffsetY;
      }

      // String? flagSymbol = stemDirection == StemValue.up
      //     ? lowestNote.flagUpSymbol
      //     : lowestNote.flagDownSymbol;

      // _drawStem(
      //   noteOffset: notesOffset,
      //   flagSymbol: flagSymbol,
      //   direction: stemDirection,
      //   canvas: canvas,
      //   size: size,
      //   stemHeight: NotationLayoutProperties.standardStemHeight +
      //       lowestNoteOffsetY.dy -
      //       highestNoteOffsetY.dy,
      // );
    }
  }

  void _drawStem({
    required Offset noteOffset,
    String? flagSymbol,
    required StemValue direction,
    double stemHeight = NotationLayoutProperties.standardStemHeight,
    required Canvas canvas,
    required Size size,
  }) {
    // Stem offset note's offset. DX offset 15 values are chosen manually.
    Offset stemOffset = noteOffset +
        const Offset(
          15,
          NotationLayoutProperties.standardStemHeight,
        );
    if (direction == StemValue.down) {
      stemOffset = noteOffset +
          const Offset(
            1,
            NotationLayoutProperties.standardStemHeight,
          );
    }

    int stemHeightMultiplier = direction == StemValue.down ? 1 : -1;

    canvas.drawLine(
      stemOffset,
      stemOffset + Offset(0, stemHeightMultiplier * stemHeight),
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 1.0)
        ..strokeWidth = NotationLayoutProperties.stemStrokeWidth,
    );
    if (flagSymbol != null) {
      var stemFlagOffset = direction == StemValue.down
          ? noteOffset - Offset(0, -stemHeight)
          : noteOffset + Offset(15, -stemHeight);

      PainterUtilities.drawSmuflSymbol(
        canvas,
        // stemFlagOffset,
        flagSymbol,
      );
    }
  }

  void _paintLedgerLines({
    required int count,
    required double noteheadWidth,
    required Canvas canvas,
    required Size size,
    required StaffPainterContext context,
  }) {
    if (count == 0) {
      return;
    }
    const double widthOutside = 4;
    int multiplier = count.isNegative ? 1 : -1;

    double startingY = count.isNegative ? 48 : 0;

    var positionY =
        (startingY + NotationLayoutProperties.staveSpace) * multiplier;
    for (var i = 0; i < count.abs(); i++) {
      canvas.drawLine(
        context.offset + Offset(-widthOutside, positionY),
        context.offset + Offset(noteheadWidth + widthOutside, positionY),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth,
      );

      positionY += multiplier * NotationLayoutProperties.staveSpace;
    }
  }

  @override
  bool shouldRepaint(MeasurePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MeasurePainter oldDelegate) => false;
}

extension SymbolPosition on Step {
  /// Calculates offset needed to draw on staff.
  Offset calculteOffset(int octave) {
    double offsetY;

    switch (this) {
      case Step.B:
        offsetY = 2;
      case Step.A:
        offsetY = 1;
      case Step.G:
        offsetY = 0;
      case Step.F:
        offsetY = -1;
      case Step.E:
        offsetY = -2;
      case Step.D:
        offsetY = -3;
      case Step.C:
        offsetY = -4;
    }
    return Offset(0, (NotationLayoutProperties.staveSpace / 2) * -offsetY) +
        Offset(0, (octave - 4) * -42);
  }
}

enum LedgerPlacement {
  above,
  below;
}
