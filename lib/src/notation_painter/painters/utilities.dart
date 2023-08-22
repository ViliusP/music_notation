import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class PainterUtilities {
  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol, {
    Offset offset = Offset.zero,
  }) {
    const textStyle = TextStyle(
      fontFamily: 'Sebastian',
      fontSize: 48,
      color: Color.fromRGBO(0, 0, 0, 1.0),
    );
    final textPainter = TextPainter(
      text: TextSpan(text: symbol, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      offset,
    );
  }
}

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
/// TODO: need to take account of different voices on the same staff:
/// If you are writing two voices on the same staff, the stems for the upper
/// voice will go up, and the stems for the lower voice will go down.
// void _drawStemForColumn(
//   VisualNoteElement? lowestNote,
//   VisualNoteElement? highestNote, {
//   required StaffPainterContext context,
//   required Canvas canvas,
//   required Size size,
// }) {
//   // If only one note exists in column.
//   // if (lowestNote != null && lowestNote == highestNote && lowestNote.stemmed) {
//   //   var offset = context.offset +
//   //       lowestNote.defaultOffset +
//   //       lowestNote.position.step.calculateOffset(lowestNote.position.octave);

//   //   final StemValue stemDirection =
//   //       lowestNote.distanceFromMiddle < 0 ? StemValue.up : StemValue.down;

//   //   String? flagSymbol = stemDirection == StemValue.up
//   //       ? lowestNote.flagUpSymbol
//   //       : lowestNote.flagDownSymbol;

//   //   _drawStem(
//   //     noteOffset: offset,
//   //     flagSymbol: flagSymbol,
//   //     direction: stemDirection,
//   //     canvas: canvas,
//   //     size: size,
//   //   );
//   // }
//   if (lowestNote != null && highestNote != null && lowestNote != highestNote) {
//     StemValue stemDirection = StemValue.down;
//     if (lowestNote.distanceFromMiddle.abs() >
//         highestNote.distanceFromMiddle.abs()) {
//       stemDirection = StemValue.up;
//     }

//     // var lowestNoteOffsetY = context.offset +
//     //     lowestNote.defaultOffset +
//     //     lowestNote.position.step.calculateOffset(lowestNote.position.octave);

//     // var highestNoteOffsetY = context.offset +
//     //     highestNote.defaultOffset +
//     //     highestNote.position.step.calculateOffset(highestNote.position.octave);

//     // Offset notesOffset = lowestNoteOffsetY;
//     // if (lowestNote.distanceFromMiddle.abs() <
//     //     highestNote.distanceFromMiddle.abs()) {
//     //   notesOffset = highestNoteOffsetY;
//     // }

//     // String? flagSymbol = stemDirection == StemValue.up
//     //     ? lowestNote.flagUpSymbol
//     //     : lowestNote.flagDownSymbol;

//     // _drawStem(
//     //   noteOffset: notesOffset,
//     //   flagSymbol: flagSymbol,
//     //   direction: stemDirection,
//     //   canvas: canvas,
//     //   size: size,
//     //   stemHeight: NotationLayoutProperties.standardStemHeight +
//     //       lowestNoteOffsetY.dy -
//     //       highestNoteOffsetY.dy,
//     // );
//   }
// }

void _drawStem({
  required Offset noteOffset,
  String? flagSymbol,
  required StemValue direction,
  double stemHeight = NotationLayoutProperties.standardStemLength,
  required Canvas canvas,
  required Size size,
}) {
  // Stem offset note's offset. DX offset 15 values are chosen manually.
  Offset stemOffset = noteOffset +
      const Offset(
        15,
        NotationLayoutProperties.standardStemLength,
      );
  if (direction == StemValue.down) {
    stemOffset = noteOffset +
        const Offset(
          1,
          NotationLayoutProperties.standardStemLength,
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
    // canvas.drawLine(
    //   context.offset + Offset(-widthOutside, positionY),
    //   context.offset + Offset(noteheadWidth + widthOutside, positionY),
    //   Paint()
    //     ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    //     ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth,
    // );

    positionY += multiplier * NotationLayoutProperties.staveSpace;
  }
}
