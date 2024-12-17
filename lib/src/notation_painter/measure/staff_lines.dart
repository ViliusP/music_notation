import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/painters/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

class StaffLinesStack extends StatelessWidget {
  final double bottom;

  const StaffLinesStack({
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

    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: bottom,
            child: SizedBox.fromSize(
              size: Size(constraints.maxWidth, layoutProperties.staveHeight),
              child: StaffLines(),
            ),
          ),
        ],
      );
    });
  }
}

class StaffLines extends StatelessWidget {
  const StaffLines({super.key});

  @override
  Widget build(BuildContext context) {
    DebugSettings? debugSettings = DebugSettings.of(context);

    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: Size(double.maxFinite, layoutProperties.staveHeight),
      painter: StaffLinesPainter(
        extraStaveLineCount: debugSettings?.extraStaveLineCount ?? 0,
        extraStaveLines: debugSettings?.extraStaveLines ?? ExtraStaveLines.none,
        spacing: layoutProperties.staveSpace,
        thickness: layoutProperties.staveLineThickness,
      ),
    );
  }
}

class BarlineStack extends StatelessWidget {
  /// Bottom position of base baseline.
  final double baseline;

  /// Height of base barline
  final double baseHeight;
  final BarlineExtension type;
  final BarlineLocation location;

  const BarlineStack({
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

class PositionedBarlineElement extends BarlineElement implements MeasureWidget {
  @override
  final AlignmentOffset offset;

  @override
  final ElementPosition position;

  @override
  Size get size => throw UnimplementedError();

  // /// Bottom position of base baseline.
  // final double baseline;

  // /// Height of base barline
  // final BarlineExtension type;
  // final BarlineLocation location;

  const PositionedBarlineElement({
    super.key,
    required this.offset,
    required this.position,
    required super.height,
  });

  factory PositionedBarlineElement.extended({
    required double height,
    required BarlineExtension type,
    required ElementPosition position,
  }) {
    double adjustedHeight = switch (type) {
      BarlineExtension.none => height,
      BarlineExtension.both => double.maxFinite,
      BarlineExtension.top => double.maxFinite,
      BarlineExtension.bottom => double.maxFinite,
    };

    AlignmentOffset offset = switch (type) {
      BarlineExtension.none => AlignmentOffset.fromTop(
          top: 0,
          height: 4,
          left: 0,
        ),
      BarlineExtension.both => AlignmentOffset.zero(),
      BarlineExtension.top => AlignmentOffset.zero(),
      BarlineExtension.bottom => AlignmentOffset.zero(),
    };

    return PositionedBarlineElement(
      offset: offset,
      position: position,
      height: adjustedHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MusicElement(
      position: position,
      offset: offset,
      child: super.build(context),
    );
  }

  //   double? left;
  // double? right;
  // switch (location) {
  //   case BarlineLocation.start:
  //     left = 0;
  //     break;
  //   case BarlineLocation.end:
  //     right = 0;
  //     break;
  // }

  // double bottom;
  // double height;
  // switch (type) {
  //   case BarlineExtension.none:
  //     height = baseHeight;
  //     break;
  //   case BarlineExtension.both:
  //     height = constraints.maxHeight;
  //     break;
  //   case BarlineExtension.top:
  //     bottom = baseline;
  //     height = ;
  //     break;
  //   case BarlineExtension.bottom:
  //     height = baseline + baseHeight;
  //     bottom = 0;
  //     break;
  // }

  // Size size = Size.fromWidth(layoutProperties.barlineThickness);
}

class BarlineElement extends StatelessWidget {
  final double height;

  const BarlineElement({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return CustomPaint(
      size: Size(layoutProperties.barlineThickness, height),
      painter: BarlinePainter(),
    );
  }
}
