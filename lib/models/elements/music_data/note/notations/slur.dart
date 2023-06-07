import 'package:music_notation/models/data_types/start_stop.dart';
import 'package:music_notation/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/models/elements/music_data/note/note.dart';
import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/text.dart';

/// Slur types are empty. Most slurs are represented with two elements: one with a start type, and one with a stop type.
///
/// Slurs can add more elements using a continue type.
///
/// This is typically used to specify the formatting of cross-system slurs, or to specify the shape of very complex slurs.
class Slur {
  StartStopContinue type;

  /// Distinguishes multiple slurs when they overlap in MusicXML document order.
  int number = 1;

  /// Specifies if the line is solid, dashed, dotted, or wavy.
  LineType? lineType;

  /// Attribute group.
  DashedFormatting dashedFormatting;

  /// Attribute group.
  Position position;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement? placement;

  /// Indicates whether slurs and ties are overhand (tips down) or underhand (tips up).
  ///
  /// This is distinct from the placement attribute used by any notation type.
  Orientation? orientation;

  /// Attribute group.
  Bezier bezier;

  /// Indicates the color of an element.
  Color color;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Slur({
    required this.type,
    this.number = 1,
    this.lineType,
    required this.dashedFormatting,
    required this.position,
    this.placement,
    this.orientation,
    required this.bezier,
    required this.color,
    this.id,
  });
}
