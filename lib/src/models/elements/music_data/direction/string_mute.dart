import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';

/// The string-mute type represents string mute on and mute off symbols.
class StringMute implements DirectionType {
  // Specifies if the string mute is going on or off.
  ///
  /// XML: ```<xs:attribute name="type" type="on-off" use="required"/>```
  bool muted;

  /// See [PrintStyleAlign].
  PrintStyleAlign printStyleAlign;

  /// Specifies an ID that is unique to the entire document.
  String id;

  StringMute({
    required this.muted,
    required this.printStyleAlign,
    required this.id,
  });
}
