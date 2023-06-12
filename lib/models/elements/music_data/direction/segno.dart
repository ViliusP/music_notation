import 'package:music_notation/models/elements/music_data/direction/direction_type.dart';
import 'package:music_notation/models/printing.dart';

/// The segno type is the visual indicator of a segno sign.
///
/// The exact glyph can be specified with the smufl attribute.
///
/// A sound element is also needed to guide playback applications reliably.
///
/// Always empty.
class Segno implements DirectionType {
  PrintStyleAlign printStyleAlign;

  String? id;

  /// xs:attribute name="smufl" type="smufl-segno-glyph-name"/>
  /// Specifies the exact glyph to be used for the segno sign.
  String? smufl;

  Segno({
    required this.printStyleAlign,
    this.id,
    this.smufl,
  });
}
