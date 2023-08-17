import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

/// Helper widget that sets vertical position of element in staff.
class MeasureElement extends StatelessWidget {
  final double left;
  final double bottom;

  final Widget child;

  final ElementPosition position;

  const MeasureElement({
    super.key,
    required this.position,
    required this.child,
    this.left = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    var fromBottom = position.step.calculateOffset(position.octave).dy;

    return Positioned(
      left: left,
      bottom: bottom + -fromBottom + 5,
      child: child,
    );
  }
}

extension SymbolPosition on Step {
  /// Calculates offset needed to draw on staff.
  Offset calculateOffset(int octave) {
    double offsetY;

    switch (this) {
      case Step.B:
        offsetY = 2;
      case Step.A:
        offsetY = 1;
      case Step.G:
        offsetY = 0;
      case Step.F:
        offsetY = -1;
      case Step.E:
        offsetY = -2;
      case Step.D:
        offsetY = -3;
      case Step.C:
        offsetY = -4;
    }
    return Offset(0, (NotationLayoutProperties.staveSpace / 2) * -offsetY) +
        Offset(0, (octave - 4) * -42);
  }
}
  // VisualMusicElement transpose(int positions) {
  //   var position = ElementPosition.fromInt(
  //     this.position.numericPosition + positions,
  //   );

  //   return copyWith(position: position);
  // }