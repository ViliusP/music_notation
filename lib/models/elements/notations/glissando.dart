import 'package:music_notation/models/data_types/start_stop.dart';
import 'package:music_notation/models/elements/notations/notation.dart';
import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/text.dart';

/// Glissando and slide types both indicate rapidly moving from one pitch to the other so that individual notes are not discerned.
///
/// A glissando sounds the distinct notes in between the two pitches and defaults to a wavy line.
///
/// The optional text is printed alongside the line.
class Glissando {
  /// Text that is printed alongside the line.
  String? text;

  StartStop type;

  ///	Distinguishes multiple glissandos when they overlap in MusicXML document order.
  /// The default value is 1.
  int number = 1;

  /// Indicates the color of an element.
  Color color;

  /// Specifies if the line is solid, dashed, dotted, or wavy.
  LineType? lineType;

  DashedFormatting dashedFormatting;

  PrintStyle printStyle;

  String id;

  Glissando({
    this.text,
    required this.type,
    required this.number,
    required this.color,
    this.lineType,
    required this.dashedFormatting,
    required this.printStyle,
    required this.id,
  });
}
