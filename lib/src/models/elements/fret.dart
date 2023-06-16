import 'package:music_notation/src/models/text.dart';

/// The fret element is used with tablature notation and chord diagrams.
///
/// Fret numbers start with 0 for an open string and 1 for the first fret.
class Fret {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  int value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Font includes:
  /// - A comma-separated list of font names;
  /// - One of the CSS sizes or a numeric point size.
  /// - Normal or italic style.
  /// - Normal or bold weight.
  Font font;

  /// Indicates the color of an element.
  Color color;

  Fret({
    required this.value,
    required this.font,
    required this.color,
  });
}
