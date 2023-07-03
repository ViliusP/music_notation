import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The wedge type represents crescendo and diminuendo wedge symbols.
///
/// The type attribute is crescendo for the start of a wedge that is closed at the left side,
/// and diminuendo for the start of a wedge that is closed on the right side. Spread values are measured in tenths;
/// those at the start of a crescendo wedge or end of a diminuendo wedge are ignored. The niente attribute is yes if a circle appears at the point of the wedge,
/// indicating a crescendo from nothing or diminuendo to nothing.
///
/// It is no by default, and used only when the type is crescendo,
/// or the type is stop for a wedge that began with a diminuendo type.
///
/// The line-type is solid if not specified.
///
/// Always empty.
class Wedge {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The value is crescendo for the start of a wedge that is closed at the left side,
  /// diminuendo for the start of a wedge that is closed on the right side, and stop for the end of a wedge.
  WedgeType type;

  /// Distinguishes multiple wedges when they overlap in MusicXML document order.
  int number;

  /// Indicates the gap between the top and bottom of the wedge as measured in tenths.
  ///
  /// Ignored if specified at the start of a crescendo wedge or the end of a diminuendo wedge.
  double? spread;

  /// A value is yes indicates that a circle appears at the point of the wedge,
  /// indicating a crescendo from nothing or diminuendo to nothing.
  ///
  /// It is no if not specified, and used only when the type is crescendo,
  /// or the type is stop for a wedge that began with a diminuendo type.
  bool niente;

  LineType? lineType;

  DashedFormatting dashedFormatting;

  Position position;

  /// Indicates the color of an element.
  Color color;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Wedge({
    required this.type,
    required this.number,
    this.spread,
    required this.niente,
    this.lineType,
    required this.dashedFormatting,
    required this.position,
    required this.color,
    this.id,
  });

  factory Wedge.fromXml() {
    return Wedge(
      color: Color(),
      dashedFormatting: DashedFormatting(),
      niente: false,
      number: 1,
      position: Position(),
      spread: 0,
      type: WedgeType.diminuendo,
    );
  }
}

/// The wedge type is crescendo for the start of a wedge that is closed at the left side,
/// diminuendo for the start of a wedge that is closed on the right side, and stop for the end of a wedge.
///
/// The continue type is used for formatting wedges over a system break,
/// or for other situations where a single wedge is divided into multiple segments.
enum WedgeType {
  crescendo,
  diminuendo,
  stop,
  tContinue;
}
