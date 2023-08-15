import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/clef_painter.dart';

class AttributesElements {
  static List<double> calculateSpacings(Attributes attributes) {
    return [];
  }
}

class ClefElement extends StatelessWidget {
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

  ElementPosition get position {
    Step? step;
    int? octave;

    switch (clef.sign) {
      case ClefSign.G:
        step = Step.G;
        octave = 4;
      case ClefSign.F:
        step = Step.D;
        octave = 5;
      case ClefSign.C:
        step = Step.C;
        octave = 4;
      case ClefSign.percussion:
        step = Step.B;
        octave = 4;
      case ClefSign.tab:
        throw UnimplementedError(
          "'${clef.sign}' clef sign is not implemented in renderer yet",
        );
      default:
        break;
    }
    if (step == null || octave == null) {
      throw UnimplementedError(
        "'${clef.sign}' clef sign is not implemented in renderer yet",
      );
    }
    return ElementPosition(octave: octave, step: step);
  }

  const ClefElement({super.key, required this.clef});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClefPainter(_symbol),
    );
  }
}
