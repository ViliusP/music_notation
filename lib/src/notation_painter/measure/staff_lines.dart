import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

class StaffLines extends StatelessWidget {
  final double bottom;

  const StaffLines({
    super.key,
    required this.bottom,
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

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: bottom,
            child: CustomPaint(
              size: Size(constraints.maxWidth, layoutProperties.staveHeight),
              painter: StaffLinesPainter(
                extraStaveLineCount: debugSettings?.extraStaveLineCount ?? 0,
                extraStaveLines:
                    debugSettings?.extraStaveLines ?? ExtraStaveLines.none,
                spacing: layoutProperties.staveSpace,
                thickness: layoutProperties.staveLineThickness,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class Barline extends StatelessWidget {
  /// Bottom position of base baseline.
  final double baseline;

  /// Height of base barline
  final double baseHeight;
  final BarlineExtension type;
  final BarlineLocation location;

  const Barline({
    super.key,
    required this.type,
    required this.location,
    required this.baseline,
    required this.baseHeight,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double? left;
    double? right;
    switch (location) {
      case BarlineLocation.start:
        left = 0;
        break;
      case BarlineLocation.end:
        right = 0;
        break;
    }

    return LayoutBuilder(builder: (context, constraints) {
      double bottom;
      double height;
      switch (type) {
        case BarlineExtension.none:
          height = baseHeight;
          bottom = baseline;
          break;
        case BarlineExtension.both:
          height = constraints.maxHeight;
          bottom = 0;
          break;
        case BarlineExtension.top:
          bottom = baseline;
          height = constraints.maxHeight - baseline;
          break;
        case BarlineExtension.bottom:
          height = baseline + baseHeight;
          bottom = 0;
          break;
      }
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: bottom,
            left: left,
            right: right,
            child: CustomPaint(
              size: Size(layoutProperties.barlineThickness, height),
              painter: BarlinePainter(),
            ),
          ),
        ],
      );
    });
  }
}
