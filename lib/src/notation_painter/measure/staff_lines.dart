import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/debug/stave_space_indicator_painter.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

class StaffLines extends StatelessWidget {
  const StaffLines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Map<BarlineExtension, Color> colors = {
    //   BarlineExtension.both: Color.fromRGBO(27, 114, 0, .5),
    //   BarlineExtension.bottom: Color.fromRGBO(255, 0, 0, .5),
    //   BarlineExtension.none: Color.fromRGBO(195, 0, 255, .5),
    //   BarlineExtension.top: Color.fromRGBO(4, 0, 255, .5),
    // };

    DebugSettings? debugSettings = DebugSettings.of(context);

    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return SizedBox(
      height: layoutProperties.staveHeight,
      child: Stack(
        fit: StackFit.loose,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: StaffLinesPainter(
              extraStaveLineCount: debugSettings?.extraStaveLineCount ?? 0,
              extraStaveLines:
                  debugSettings?.extraStaveLines ?? ExtraStaveLines.none,
              height: layoutProperties.staveHeight,
              spacing: layoutProperties.staveSpace,
              thickness: layoutProperties.staveLineThickness,
            ),
          ),
          if ((debugSettings?.verticalStaveLineSpacingMultiplier ?? 0) != 0)
            CustomPaint(
              painter: StaveSpaceIndicatorPainter(
                multiplier:
                    debugSettings?.verticalStaveLineSpacingMultiplier ?? 0,
                spacing: layoutProperties.staveHeight,
              ),
            ),
        ],
      ),
    );
  }
}

class Barlines extends StatelessWidget {
  final BarlineExtension startExtension;
  final BarlineExtension endExtension;

  // Measure padding
  final VerticalEdgeInsets padding;

  const Barlines({
    super.key,
    required this.startExtension,
    required this.endExtension,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    Size size = Size(
      layoutProperties.barlineThickness,
      4.0.scaledByContext(context), // must be corrected
    );

    double calculatedStartOffset = 0;
    double calculatedStartHeight = size.height;
    if (startExtension == BarlineExtension.bottom) {
      calculatedStartHeight += padding.bottom;
    }

    if (startExtension == BarlineExtension.both) {
      calculatedStartHeight += padding.bottom;
      calculatedStartOffset -= padding.top;
    }

    if (startExtension == BarlineExtension.top) {
      calculatedStartOffset -= padding.top;
    }

    double calculatedEndOffset = 0;
    double calculatedEndHeight = size.height;
    if (endExtension == BarlineExtension.bottom) {
      calculatedEndHeight += padding.bottom;
    }

    if (endExtension == BarlineExtension.both) {
      calculatedEndHeight += padding.bottom;
      calculatedEndOffset -= padding.top;
    }

    if (endExtension == BarlineExtension.top) {
      calculatedEndOffset -= padding.top;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (startExtension != BarlineExtension.none)
          Align(
            alignment: Alignment.centerLeft,
            child: CustomPaint(
              size: Size.fromWidth(size.width),
              painter: BarlinePainter(
                // color: colors[startExtension]!,
                offset: calculatedStartOffset,
                height: calculatedStartHeight,
                end: false, thicknes: layoutProperties.barlineThickness,
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: CustomPaint(
            size: Size.fromWidth(size.width),
            painter: BarlinePainter(
              // color: colors[endExtension]!,
              offset: calculatedEndOffset,
              height: calculatedEndHeight,
              thicknes: layoutProperties.barlineThickness,
            ),
          ),
        ),
      ],
    );
  }
}
