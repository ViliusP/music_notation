import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

/// Paints [count] duration dots as SMUFL symbol.
/// A duration dot that is larger than a staccato dot — often twice the size.
class StaveSpaceIndicatorPainter extends CustomPainter {
  final int verticalStaveLineSpacingMultiplier;

  StaveSpaceIndicatorPainter(this.verticalStaveLineSpacingMultiplier);

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 0.25)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    if (verticalStaveLineSpacingMultiplier == 0) return;

    int i = 0;
    double lineHeight = NotationLayoutProperties.defaultStaveSpace;
    while (i * NotationLayoutProperties.defaultStaveSpace < size.width) {
      canvas.drawLine(
        Offset(i * NotationLayoutProperties.defaultStaveSpace, -lineHeight),
        Offset(i * NotationLayoutProperties.defaultStaveSpace, lineHeight / 2),
        _paint,
      );
      canvas.drawLine(
        Offset(
          i * NotationLayoutProperties.defaultStaveSpace,
          size.height - lineHeight / 2,
        ),
        Offset(
          i * NotationLayoutProperties.defaultStaveSpace,
          size.height + lineHeight,
        ),
        _paint,
      );
      i += verticalStaveLineSpacingMultiplier;
    }
  }

  @override
  bool shouldRepaint(StaveSpaceIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StaveSpaceIndicatorPainter oldDelegate) => false;
}
