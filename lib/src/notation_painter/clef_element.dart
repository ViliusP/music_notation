import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/clef_painter.dart';

class ClefElement extends StatelessWidget implements MeasureWidget {
  final Clef clef;

  String get _symbol {
    switch (clef.sign) {
      case ClefSign.G:
        return '\uE050';
      case ClefSign.F:
        return '\uE062';
      case ClefSign.C:
        return '\uE05C';
      case ClefSign.percussion:
        return '\uE069';
      case ClefSign.tab:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
      // symbol = '\uE06D';
      default:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
    }
  }

  @override
  double get positionalOffset {
    switch (clef.sign) {
      case ClefSign.G:
        return -10;
      case ClefSign.F:
        return 35;
      case ClefSign.C:
        // TODO: adjust
        return -21;
      case ClefSign.percussion:
        // TODO: adjust
        return -21;
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

  @override
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

  const ClefElement({super.key, required this.clef});

  @override
  Size get size {
    switch (clef.sign) {
      case ClefSign.G:
        return const Size(32, 88);
      case ClefSign.F:
        return const Size(34, 51);
      case ClefSign.C:
        // TODO: adjust
        return const Size(33, 42);
      case ClefSign.percussion:
        // TODO: adjust
        return const Size(33, 42);
      case ClefSign.tab:
        // TODO: adjust
        return const Size(33, 42);
      default:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
    }
  }

  Offset get _paintingOffset {
    switch (clef.sign) {
      case ClefSign.G:
        return const Offset(0, 65.5);
      case ClefSign.F:
        return const Offset(0, 74);
      case ClefSign.C:
        // TODO: adjust
        return const Offset(0, 65);
      case ClefSign.percussion:
        // TODO: adjust
        return const Offset(0, 65);
      case ClefSign.tab:
        // TODO: adjust
        return const Offset(0, 65);
      default:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: ClefPainter(_symbol, _paintingOffset),
    );
  }

  @override
  // TODO: implement alignmentOffset
  double get alignmentOffset => throw UnimplementedError();
}
