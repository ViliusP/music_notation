import 'package:music_notation/src/models/printing.dart';

/// Directives are like directions, but can be grouped together with attributes for convenience.
///
/// This is typically used for tempo markings at the beginning of a piece of music.
///
/// This element was deprecated in Version 2.0 in favor of the direction element's directive attribute.
///
/// Language names come from ISO 639, with optional country subcodes from ISO 3166.
class AttributeDirective {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  String value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  PrintStyle printStyle;

  /// Specifies the language used in the element content. It is Italian ("it") if not specified.
  String? lang;

  AttributeDirective({
    required this.value,
    required this.printStyle,
    this.lang,
  });
}
