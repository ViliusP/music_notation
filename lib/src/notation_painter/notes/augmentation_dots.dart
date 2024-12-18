import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
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
  final double spacing;

  /// Font metadata used for glyph dimensions and layout information.
  final FontMetadata font;

  /// The default offset for positioning [AugmentationDots] on the right side of the note.
  /// This offset is typically half of the stave space and is added to the note size,
  /// so the dot aligns correctly in musical notation.
  static const double defaultBaseOffset = 1 / 2;

  /// The default spacing between two augmentation dots.
  ///
  /// *Value taken from [_defaultSize].
  static const double _defaultSpacing = 2.376;

  /// Calculates the total size of the augmentation dots.
  ///
  /// This method determines the combined width of all dots, factoring in
  /// spacing between them, and returns the required [Size] object.
  Size get size {
    Size singleDotSize = _baseDotSize(font);
    double width = count * singleDotSize.width + (spacing * (count - 1));

    return Size(width, singleDotSize.height);
  }

  AlignmentPosition get alignmentPosition => AlignmentPosition(
        left: 0,
        bottom: -size.height / 2,
      );

  ElementPosition get position => ElementPosition.staffMiddle;

  /// Constructor for [AugmentationDots].
  ///
  /// - [count] - The number of augmentation dots to display. Must be greater than 0.
  /// - [font] - Font metadata for dot dimensions and alignment.
  /// - [spacing] - Optional, specifies the distance between dots. Defaults to [defaultSpacing].
  const AugmentationDots({
    super.key,
    required this.count,
    required this.font,
    this.spacing = _defaultSpacing,
  })  : assert(count > 0), // Ensure at least one dot
        assert(spacing >= 0); // Ensure non-negative spacing

  /// Retrieves the size of a single augmentation dot based on [font] metadata.
  ///
  /// If the font provides specific glyph dimensions, those are used. Otherwise,
  /// a default size scaled to the current stave height is calculated and returned.
  static Size _baseDotSize(FontMetadata font) {
    return font.glyphBBoxes[CombiningStaffPositions.augmentationDot]!
        .toRect()
        .size;
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    Size singleDotSize = _baseDotSize(font).scaledByContext(context);

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Row(
        children: [
          for (int i = 0; i < count; i++)
            Padding(
              padding: EdgeInsets.only(
                left: (singleDotSize.width * i) + (spacing * i),
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
