import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/painters/time_beat_painter.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/size_extensions.dart';

class TimeBeatElement extends StatelessWidget implements MeasureWidget {
  final TimeBeat timeBeat;

  @override
  AlignmentPosition get alignmentPosition {
    return AlignmentPosition(
      top: -2,
      left: 0,
    );
  }

  @override
  Size get baseSize => const Size(20 / 12, 4);

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
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

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
    Size smuflSize = Size(20 / 12, 2).scaledByContext(context);

    return SizedBox.fromSize(
      size: baseSize.scaledByContext(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topSmufl != null)
            CustomPaint(
              size: smuflSize,
              painter: TimeBeatPainter(
                topSmufl,
                layoutProperties.staveSpace,
              ),
            ),
          if (bottomSmufl != null)
            CustomPaint(
              size: smuflSize,
              painter: TimeBeatPainter(
                bottomSmufl,
                layoutProperties.staveSpace,
              ),
            ),
        ],
      ),
    );
  }
}
