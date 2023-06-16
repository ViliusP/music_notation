import 'package:music_notation/models/printing.dart';

/// The style-text type represents a text element with a print-style attribute group.
class StyleText {
  String value;

  PrintStyle printStyle;

  StyleText({
    required this.value,
    required this.printStyle,
  });
}
