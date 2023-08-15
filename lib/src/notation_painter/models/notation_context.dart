import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';

class NotationContext {
  final Clef? clef;
  final double? divisions;
  final Time? time;

  NotationContext({
    required this.divisions,
    required this.clef,
    required this.time,
  });

  NotationContext copyWith({
    Clef? clef,
    double? divisions,
    Time? time,
  }) {
    return NotationContext(
      clef: clef ?? this.clef,
      divisions: divisions ?? this.divisions,
      time: time ?? this.time,
    );
  }
}
