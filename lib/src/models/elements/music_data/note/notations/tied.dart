import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';

/// <xs:element name="tied" type="tied"/>
/// The tied element represents the notated tie. The tie element represents the tie sound.
///
/// The number attribute is rarely needed to disambiguate ties, since note pitches will usually suffice.
/// The attribute is implied rather than defaulting to 1 as with most elements.
/// It is available for use in more complex tied notation situations.
///
/// Ties that join two notes of the same pitch together should be represented with a tied element on the first note with type="start" and a tied element on the second note with type="stop".
/// This can also be done if the two notes being tied are enharmonically equivalent, but have different step values.
/// It is not recommended to use tied elements to join two notes with enharmonically inequivalent pitches.
///
/// Ties that indicate that an instrument should be undamped are specified with a single tied element with type="let-ring".
///
/// Ties that are visually attached to only one note, other than undamped ties, should be specified with two tied elements on the same note, first type="start" then type="stop".
/// This can be used to represent ties into or out of repeated sections or codas.
class Tied {
  /// Indicates if this is the start, stop, or continuation of a tie,
  /// or if this is a tie indicating that an instrument should be undamped.
  TiedType type;

  /// Rarely needed to disambiguate ties, since note pitches will usually suffice.
  ///
  /// It is available for use in more complex tied notation situations.
  int? number;

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

  Tied({
    required this.type,
    this.number,
    this.lineType,
    required this.dashedFormatting,
    required this.position,
    this.placement,
    this.orientation,
    required this.bezier,
    required this.color,
  });
}

/// The tied-type type is used as an attribute of the tied element to specify where the visual representation of a tie begins and ends.
///
/// A tied element which joins two notes of the same pitch can be specified with tied-type start on the first note and tied-type stop on the second note.
///
/// To indicate a note should be undamped, use a single tied element with tied-type let-ring.
/// For other ties that are visually attached to a single note,
/// such as a tie leading into or out of a repeated section or coda, use two tied elements on the same note, one start and one stop.
///
/// In start-stop cases, ties can add more elements using a continue type.
/// This is typically used to specify the formatting of cross-system ties.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
/// For example, a note with a tie at the end of a first ending should have the tied element with a type of start precede the tied element with a type of stop.
enum TiedType {
  start,
  stop,
  tContinue,
  letRing;
}
