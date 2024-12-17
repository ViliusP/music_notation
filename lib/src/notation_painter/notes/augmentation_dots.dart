import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

/// A widget that displays augmentation dots next to a musical note.
///
/// Augmentation dots indicate rhythmic extensions to a note's duration.
/// This widget calculates the required size based on the number of dots,
/// spacing, and font metadata for rendering the dots accurately.
class AugmentationDots extends StatelessWidget {
  /// The number of augmentation dots to display.
  final int count;

  /// The spacing between each augmentation dot.
  final double? spacing;

  /// Font metadata used for glyph dimensions and layout information.
  final FontMetadata font;

  /// Constructor for [AugmentationDots].
  ///
  /// - [count] - The number of augmentation dots to display. Must be greater than 0.
  /// - [font] - Font metadata for dot dimensions and alignment.
  /// - [spacing] - Optional, specifies the distance between dots. Defaults to [defaultSpacing].
  const AugmentationDots({
    super.key,
    required this.count,
    required this.font,
    this.spacing,
  })  : assert(count > 0), // Ensure at least one dot
        assert((spacing ?? 0) >= 0); // Ensure non-negative spacing

  /// The default offset for positioning [AugmentationDots] on the right side of the note.
  /// This offset is typically half of the stave space and is added to the note size,
  /// so the dot aligns correctly in musical notation.
  static const double defaultBaseOffset = 1 / 2;

  /// Calculates the total size of the augmentation dots.
  ///
  /// This method determines the combined width of all dots, factoring in
  /// spacing between them, and returns the required [Size] object.
  Size get size {
    Size singleDotSize = _bbox.toSize();
    double width =
        (count * singleDotSize.width) + (_resolvedSpacing * (count - 1));

    return Size(width, singleDotSize.height);
  }

  Alignment get alignment => Alignment.centerLeft;

  ElementPosition get position => ElementPosition.staffMiddle;

  double get _resolvedSpacing => spacing ?? _bbox.toSize().width / 2;

  GlyphBBox get _bbox =>
      font.glyphBBoxes[CombiningStaffPositions.augmentationDot]!;

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    Size singleDotSize = _bbox.toSize().scaledByContext(context);

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : _resolvedSpacing.scaledByContext(context),
              ),
              child: CustomPaint(
                size: singleDotSize,
                painter: SimpleGlyphPainter(
                  SmuflGlyph.augmentationDot.codepoint,
                  font.glyphBBoxes[SmuflGlyph.augmentationDot]!,
                  layoutProperties.staveSpace,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
