import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/debug/stave_space_indicator_painter.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';

class StaffLines extends StatelessWidget {
  final BarlineExtension startExtension;
  final BarlineExtension endExtension;
  final EdgeInsets measurePadding;

  const StaffLines({
    super.key,
    required this.startExtension,
    required this.endExtension,
    required this.measurePadding,
  });

  @override
  Widget build(BuildContext context) {
    // Map<BarlineExtension, Color> colors = {
    //   BarlineExtension.both: Color.fromRGBO(27, 114, 0, .5),
    //   BarlineExtension.bottom: Color.fromRGBO(255, 0, 0, .5),
    //   BarlineExtension.none: Color.fromRGBO(195, 0, 255, .5),
    //   BarlineExtension.top: Color.fromRGBO(4, 0, 255, .5),
    // };

    double calculatedStartOffset = 0;
    double calculatedStartHeight = BarlinePainter.size.height;
    if (startExtension == BarlineExtension.bottom) {
      calculatedStartHeight += measurePadding.bottom;
    }

    if (startExtension == BarlineExtension.both) {
      calculatedStartHeight += measurePadding.bottom;
      calculatedStartOffset -= measurePadding.top;
    }

    if (startExtension == BarlineExtension.top) {
      calculatedStartOffset -= measurePadding.top;
    }

    double calculatedEndOffset = 0;
    double calculatedEndHeight = BarlinePainter.size.height;
    if (endExtension == BarlineExtension.bottom) {
      calculatedEndHeight += measurePadding.bottom;
    }

    if (endExtension == BarlineExtension.both) {
      calculatedEndHeight += measurePadding.bottom;
      calculatedEndOffset -= measurePadding.top;
    }

    if (endExtension == BarlineExtension.top) {
      calculatedEndOffset -= measurePadding.top;
    }

    DebugSettings? debugSettings = DebugSettings.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (startExtension != BarlineExtension.none)
          Align(
            alignment: Alignment.centerLeft,
            child: CustomPaint(
              size: Size.fromWidth(BarlinePainter.size.width),
              painter: BarlinePainter(
                // color: colors[startExtension]!,
                offset: calculatedStartOffset,
                height: calculatedStartHeight,
                end: false,
              ),
            ),
          ),
        CustomPaint(
          painter: StaffLinesPainter(
            extraStaveLineCount: debugSettings?.extraStaveLineCount ?? 0,
            extraStaveLines:
                debugSettings?.extraStaveLines ?? ExtraStaveLines.none,
          ),
        ),
        if ((debugSettings?.verticalStaveLineSpacingMultiplier ?? 0) != 0)
          CustomPaint(
            painter: StaveSpaceIndicatorPainter(
              debugSettings?.verticalStaveLineSpacingMultiplier ?? 0,
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: CustomPaint(
            size: Size.fromWidth(BarlinePainter.size.width),
            painter: BarlinePainter(
              // color: colors[endExtension]!,
              offset: calculatedEndOffset,
              height: calculatedEndHeight,
            ),
          ),
        ),
      ],
    );
  }
}