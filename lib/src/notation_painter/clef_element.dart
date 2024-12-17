import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:music_notation/src/smufl/glyph_class.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

class ClefElement extends StatelessWidget {
  final Clef clef;
  final FontMetadata font;

  AlignmentOffset get offset => AlignmentOffset.fromBbox(left: 0, bBox: _bBox);

  const ClefElement({
    super.key,
    required this.clef,
    required this.font,
  });

  SmuflGlyph get _glyph {
    switch (clef.sign) {
      case ClefSign.G:
        if (clef.octaveChange != 0 && clef.octaveChange != null) {
          return ClefsG.gClef8vb;
        }
        return ClefsG.gClef;
      case ClefSign.F:
        if (clef.octaveChange != 0 && clef.octaveChange != null) {
          return ClefsF.fClef8vb;
        }
        return ClefsF.fClef;
      case ClefSign.C:
        return ClefsC.cClef;
      case ClefSign.percussion:
        return Clefs.unpitchedPercussionClef1;
      case ClefSign.tab:
        return Clefs.g6stringTabClef;
      default:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
    }
  }

  GlyphBBox get _bBox {
    return font.glyphBBoxes[_glyph]!;
  }

  ElementPosition get position {
    switch (clef.sign) {
      case ClefSign.G:
        return const ElementPosition(step: Step.G, octave: 4);
      case ClefSign.F:
        return const ElementPosition(step: Step.D, octave: 5);
      case ClefSign.C:
        return const ElementPosition(step: Step.C, octave: 4);
      case ClefSign.percussion:
        return const ElementPosition(step: Step.B, octave: 4);
      case ClefSign.tab:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
      default:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
    }
  }

  Size get size => _bBox.toSize();

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: size.scaledByContext(context),
      painter: SimpleGlyphPainter(
        _glyph.codepoint,
        _bBox,
        layoutProperties.staveSpace,
      ),
    );
  }
}
