import 'package:flutter/widgets.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
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
  static const double defaultOffset =
      defaultBaseOffset * NotationLayoutProperties.defaultStaveSpace;

  static const double defaultBaseOffset = 1 / 2;

  /// The default spacing between two augmentation dots.
  ///
  /// *Value taken from [_defaultSize].
  static const double defaultSpacing =
      NotationLayoutProperties.defaultStaveHeight / 50 * 4.95 / 2;

  /// Calculates the total [size] of the augmentation dots.
  ///
  /// This method determines the combined width of all dots, factoring in
  /// spacing between them, and returns the required [Size] object.
  Size get baseSize {
    Size singleDotSize = _baseDotSize(font);
    double width = count * singleDotSize.width + (spacing * (count - 1));

    return Size(width, singleDotSize.height);
  }

  AlignmentPosition get alignmentPosition => AlignmentPosition(
        left: 0,
        top: baseSize.height / 2,
      );

  ElementPosition get position => ElementPosition.staffMiddle;

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
  static Size _baseDotSize(FontMetadata font) {
    Size? glyphSize = font.glyphBBoxes[CombiningStaffPositions.augmentationDot]
        ?.toRect(1)
        .size;

    if (glyphSize != null) return glyphSize;

    return _defaultBaseSize;
  }

  static const Size _defaultBaseSize = Size(
    0.4,
    0.396,
  );

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    Size singleDotSize = _baseDotSize(font).byContext(context);

    return SizedBox.fromSize(
      size: baseSize.byContext(context),
      child: Stack(
        children: [
          for (int i = 0; i < count; i++)
            Positioned(
              left: (singleDotSize.width * i) + (spacing * i),
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
