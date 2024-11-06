import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/dots_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';

/// A widget that displays augmentation dots next to a musical note.
///
/// Augmentation dots indicate rhythmic extensions to a note's duration.
/// This widget calculates the required size based on the number of dots,
/// spacing, and font metadata for rendering the dots accurately.
class AugmentationDot extends StatelessWidget {
  /// The number of augmentation dots to display.
  final int count;

  /// The spacing between each augmentation dot.
  final double spacing;

  /// Font metadata used for glyph dimensions and layout information.
  final FontMetadata font;

  /// The default offset for positioning [AugmentationDot] on the right side of the note.
  /// This offset is typically half of the stave space and is added to the note size,
  /// so the dot aligns correctly in musical notation.
  static const double defaultOffset = NotationLayoutProperties.staveSpace / 2;

  /// The default spacing between two augmentation dots.
  static const double defaultSpacing = 7;

  /// Calculates the total [size] of the augmentation dots.
  ///
  /// This method determines the combined width of all dots, factoring in
  /// spacing between them, and returns the required [Size] object.
  Size get size {
    Size singleDotSize = _singleDotSize(font);
    double width = count * singleDotSize.width + (spacing * (count - 1));
    return Size(width, singleDotSize.height);
  }

  /// Constructor for [AugmentationDot].
  ///
  /// - [count] - The number of augmentation dots to display. Must be greater than 0.
  /// - [font] - Font metadata for dot dimensions and alignment.
  /// - [spacing] - Optional, specifies the distance between dots. Defaults to [defaultSpacing].
  const AugmentationDot({
    super.key,
    required this.count,
    required this.font,
    this.spacing = defaultSpacing,
  })  : assert(count > 0), // Ensure at least one dot
        assert(spacing >= 0); // Ensure non-negative spacing

  /// Retrieves the size of a single augmentation dot based on [font] metadata.
  ///
  /// If the font provides specific glyph dimensions, those are used. Otherwise,
  /// a default size scaled to the current stave height is calculated and returned.
  static Size _singleDotSize(FontMetadata font) {
    Size? glyphSize = font.glyphBBoxes[CombiningStaffPositions.augmentationDot]
        ?.toRect()
        .size;

    if (glyphSize != null) return glyphSize;

    // Otherwise, use a default size scaled to the current stave height
    const double referenceStaveHeight = 50;
    const Size defaultSize = Size(5, 4.95); // Size when stave height is 50
    const double scaleFactor =
        NotationLayoutProperties.staveHeight / referenceStaveHeight;
    Size scaledDefaultSize = Size(
      defaultSize.width * scaleFactor,
      defaultSize.height * scaleFactor,
    );
    return scaledDefaultSize;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: DotsPainter(count, defaultSpacing),
    );
  }
}
