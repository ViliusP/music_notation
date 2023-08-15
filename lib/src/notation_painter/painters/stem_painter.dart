import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class StemPainter extends CustomPainter {
  /// Smufl symbol for flag.
  final String? flagSmufl;

  static const strokeWidth = NotationLayoutProperties.stemStrokeWidth;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    ..strokeWidth = strokeWidth;

  StemPainter({
    required this.flagSmufl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // void _drawStem({
    //   required Offset noteOffset,
    //   ,
    //   ,
    //   double stemHeight = ,

    // Stem offset note's offset. DX offset 15 values are chosen manually.
    // Offset stemOffset = noteOffset +
    //     const Offset(
    //       15,
    //       NotationLayoutProperties.standardStemLength,
    //     );
    // if (direction == StemValue.down) {
    //   stemOffset = noteOffset +
    //       const Offset(
    //         1,
    //         NotationLayoutProperties.standardStemLength,
    //       );
    // }

    // int stemHeightMultiplier = direction == StemValue.down ? 1 : -1;

    canvas.drawLine(Offset.zero, Offset(0, size.height), _paint);
    if (flagSmufl != null) {
      // var stemFlagOffset = direction == StemValue.down
      //     ? noteOffset - Offset(0, -stemHeight)
      //     : noteOffset + Offset(15, -stemHeight);

      PainterUtilities.drawSmuflSymbol(
        canvas,
        flagSmufl!,
        offset: Offset(0, -size.height),
      );
    }
  }

  @override
  bool shouldRepaint(StemPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StemPainter oldDelegate) => false;
}
