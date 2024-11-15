import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/time_beat_painter.dart';

class TimeBeatElement extends StatelessWidget implements MeasureWidget {
  final TimeBeat timeBeat;

  @override
  AlignmentPosition get alignmentPosition {
    return AlignmentPosition(
      top: -NotationLayoutProperties.defaultStaveSpace * 2,
      left: 0,
    );
  }

  @override
  Size get size => const Size(20, NotationLayoutProperties.defaultStaveHeight);

  @override
  ElementPosition get position => const ElementPosition(
        step: Step.B,
        octave: 4,
      );

  static String _integerToSmufl(int num) {
    final unicodeValue = 0xE080 + num;
    return String.fromCharCode(unicodeValue);
  }

  const TimeBeatElement({
    super.key,
    required this.timeBeat,
  });

  @override
  Widget build(BuildContext context) {
    if (timeBeat.timeSignatures.length > 1) {
      throw UnimplementedError(
        "multiple beat and beat type in one time-beat are not implemented in renderer yet",
      );
    }
    var signature = timeBeat.timeSignatures.firstOrNull;

    String? topSmufl;
    String? bottomSmufl;
    if (signature != null) {
      topSmufl = _integerToSmufl(int.parse(signature.beats));
      bottomSmufl = _integerToSmufl(int.parse(signature.beatType));
    }
    Size smuflSize =
        const Size(20, NotationLayoutProperties.defaultStaveHeight / 2);

    return SizedBox.fromSize(
      size: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topSmufl != null)
            CustomPaint(
              size: smuflSize,
              painter: TimeBeatPainter(topSmufl),
            ),
          if (bottomSmufl != null)
            CustomPaint(
              size: smuflSize,
              painter: TimeBeatPainter(bottomSmufl),
            ),
        ],
      ),
    );
  }
}
