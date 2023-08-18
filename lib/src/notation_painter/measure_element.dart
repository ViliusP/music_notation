import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';

/// Helper widget that sets vertical position of element in staff.
class MeasureElement extends StatelessWidget {
  final double left;
  final double bottom;

  final Clef? clef;

  final Widget child;

  ElementPosition get position => _position.transpose(_transposeInterval);
  final ElementPosition _position;

  int get _transposeInterval {
    if (child is NoteElement && (child as NoteElement).note.form is Rest) {
      return 0;
    }

    int transpose = 0;

    switch (clef?.sign) {
      case ClefSign.F:
        transpose = 12;
        break;
      default:
    }
    // Different transpose values of key signatures.
    if (child is KeySignature) {
      switch (clef?.sign) {
        case ClefSign.F:
          transpose = -2;
          break;
        default:
      }
    }
    return transpose;
  }

  const MeasureElement({
    super.key,
    required ElementPosition position,
    required this.child,
    this.left = 0,
    this.bottom = 0,
    this.clef,
  }) : _position = position;

  @override
  Widget build(BuildContext context) {
    var fromBottom = position.offset.dy;

    return Positioned(
      left: left,
      bottom: bottom + -fromBottom + 5,
      child: child,
    );
  }
}

extension ElementPositionOffset on ElementPosition {
  Offset get offset {
    double offsetY;

    switch (step) {
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
    return Offset(0, -(NotationLayoutProperties.staveSpace / 2) * offsetY) +
        Offset(0, (octave - 4) * -42);
  }
}
