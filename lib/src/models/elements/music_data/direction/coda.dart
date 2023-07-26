import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';

// /The coda type is the visual indicator of a coda sign. The exact glyph can be specified with the smufl attribute. A sound element is also needed to guide playback applications reliably.
class Coda implements DirectionType {
  PrintStyleAlign printStyleAlign;

  String? id;

  String? smufl;

  Coda({
    required this.printStyleAlign,
  });
}
