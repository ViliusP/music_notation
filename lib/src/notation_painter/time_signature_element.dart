import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';

class TimeSignatureElement extends StatelessWidget {
  final TimeBeat timeBeat;

  final FontMetadata font;

  AlignmentOffset get offset => AlignmentOffset.center(left: 0, size: size);

  Size get size {
    double height = 0;
    double width = 0;

    for (var column in _glyphGrid) {
      double columnHeight = 0;
      double columnWidth = 0;

      for (var glyph in column) {
        Size glyphSize = font.glyphBBoxes[glyph]!.toSize();

        columnHeight += glyphSize.height;
        columnWidth = max(columnWidth, glyphSize.width);
      }
      width += columnWidth;
      height = max(height, columnHeight);
    }

    return Size(
      width,
      height,
    );
  }

  ElementPosition get position => const ElementPosition(
        step: Step.B,
        octave: 4,
      );

  List<List<SmuflGlyph>> get _glyphGrid {
    List<List<SmuflGlyph>> grid = [];
    switch (timeBeat.symbol) {
      case TimeSymbol.common:
        grid.add([SmuflGlyph.timeSigCommon]);
        break;
      case TimeSymbol.cut:
        grid.add([SmuflGlyph.timeSigCutCommon]);
        break;
      case TimeSymbol.singleNumber:
        grid.add([numberToGlyph(timeBeat.timeSignatures.first.beats)]);
        break;
      case TimeSymbol.normal:
        for (var signature in timeBeat.timeSignatures) {
          if (signature.beats.contains("+")) {
            throw UnimplementedError(
              "Composite time signatures aren't implemented yet",
            );
          }
          if (grid.isNotEmpty) {
            grid.add([SmuflGlyph.timeSigPlus]);
          }

          grid.add(
            [numberToGlyph(signature.beats), numberToGlyph(signature.beatType)],
          );
        }
        break;
      case TimeSymbol.dottedNote:
      case TimeSymbol.note:
        throw UnimplementedError(
          "'TimeSymbol.note', 'TimeSymbol.dottedNote' time signatures aren't implemented yet",
        );
    }
    return grid;
  }

  static numberToGlyph(String number) {
    switch (number) {
      case "0":
        return SmuflGlyph.timeSig0;
      case "1":
        return SmuflGlyph.timeSig1;
      case "2":
        return SmuflGlyph.timeSig2;
      case "3":
        return SmuflGlyph.timeSig3;
      case "4":
        return SmuflGlyph.timeSig4;
      case "5":
        return SmuflGlyph.timeSig5;
      case "6":
        return SmuflGlyph.timeSig6;
      case "7":
        return SmuflGlyph.timeSig7;
      case "8":
        return SmuflGlyph.timeSig8;
      case "9":
        return SmuflGlyph.timeSig9;
      default:
        return SmuflGlyph.timeSigX;
    }
  }

  const TimeSignatureElement({
    super.key,
    required this.timeBeat,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    if (timeBeat.interchangeable != null) {
      throw UnimplementedError(
        "interchangeable time beat are not implemented in renderer yet",
      );
    }

    return SizedBox.fromSize(
      size: size.scaledByContext(context),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _glyphGrid
              .map((glyphColumn) => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: glyphColumn
                        .map(
                          (glyph) => CustomPaint(
                            size: font.glyphBBoxes[glyph]!
                                .toSize()
                                .scaledByContext(context),
                            painter: SimpleGlyphPainter(
                              glyph.codepoint,
                              font.glyphBBoxes[glyph]!,
                              layoutProperties.staveSpace,
                            ),
                          ),
                        )
                        .toList(),
                  ))
              .toList()),
    );
  }
}
