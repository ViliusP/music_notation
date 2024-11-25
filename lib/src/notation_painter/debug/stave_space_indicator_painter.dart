import 'package:flutter/rendering.dart';

/// Paints [count] duration dots as SMUFL symbol.
/// A duration dot that is larger than a staccato dot — often twice the size.
class StaveSpaceIndicatorPainter extends CustomPainter {
  final int multiplier;
  final double spacing;

  StaveSpaceIndicatorPainter({
    required this.multiplier,
    required this.spacing,
  });

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 0.25)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    if (multiplier == 0) return;

    int i = 0;
    double lineHeight = spacing;
    while (i * spacing < size.width) {
      canvas.drawLine(
        Offset(i * spacing, -lineHeight),
        Offset(i * spacing, lineHeight / 2),
        _paint,
      );
      canvas.drawLine(
        Offset(
          i * spacing,
          size.height - lineHeight / 2,
        ),
        Offset(
          i * spacing,
          size.height + lineHeight,
        ),
        _paint,
      );
      i += multiplier;
    }
  }

  @override
  bool shouldRepaint(StaveSpaceIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StaveSpaceIndicatorPainter oldDelegate) => false;
}
