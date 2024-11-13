import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';

class NotationContext {
  final Clef? clef;
  final Key? lastKey;
  final double? divisions;
  final Time? time;

  const NotationContext({
    required this.divisions,
    required this.clef,
    required this.time,
    required this.lastKey,
  });

  const NotationContext.empty()
      : this(
          divisions: null,
          clef: null,
          time: null,
          lastKey: null,
        );

  NotationContext copyWith({
    Clef? clef,
    double? divisions,
    Time? time,
    Key? lastKey,
  }) {
    return NotationContext(
      clef: clef ?? this.clef,
      divisions: divisions ?? this.divisions,
      time: time ?? this.time,
      lastKey: lastKey ?? this.lastKey,
    );
  }
}
