import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

/// Paints [count] duration dots as SMUFL symbol.
/// A duration dot that is larger than a staccato dot — often twice the size.
class DotsPainter extends CustomPainter {
  final int count;

  DotsPainter(this.count);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < count; i++) {
      PainterUtilities.drawSmuflSymbol(
        canvas,
        SmuflGlyph.augmentationDot.codepoint,
        offset: Offset(
          7 * i.toDouble(),
          -NotationLayoutProperties.staveSpace * 2 + size.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(DotsPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DotsPainter oldDelegate) => false;
}
