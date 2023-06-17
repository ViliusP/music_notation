import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The footnote element specifies editorial information that appears in footnotes in the printed score.
///
/// It is defined within a group due to its multiple uses within the MusicXML schema.
class Footnote {
  FormattedText value;
  Footnote({
    required this.value,
  });
}

/// The editorial group specifies editorial information for a musical element.
class Editorial {
  Footnote? footnote;

  Level? level;

  Editorial({
    this.footnote,
    this.level,
  });

  Editorial.empty();

  static Editorial fromXml(XmlElement xmlElement) {
    return Editorial();
  }
}

/// The level type is used to specify editorial information for different MusicXML elements.
///
/// The content contains identifying and/or descriptive text about the editorial status of the parent element.
///
/// If the reference attribute is yes, this indicates editorial information that is for display only and should not affect playback.
///
/// For instance, a modern edition of older music may set reference="yes" on the attributes containing the music's original clef, key, and time signature.
/// It is no if not specified.
///
/// The type attribute indicates whether the editorial information applies to the start of a series of symbols, the end of a series of symbols, or a single symbol.
///
/// It is single if not specified for compatibility with earlier MusicXML versions.
class Level {
  String value;
  bool reference;
  LevelDisplay display;

  Level({
    required this.value,
    required this.reference,
    required this.display,
  });
}

/// The level-display attribute group specifies three common ways to indicate editorial indications:
///
/// putting parentheses or square brackets around a symbol, or making the symbol a different size.
///
/// If not specified, they are left to application defaults.
///
/// It is used by the level and accidental elements.
class LevelDisplay {
  /// Specifies whether or not parentheses are put around a symbol for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  bool? parentheses;

  /// Specifies whether or not brackets are put around a symbol for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  bool? bracket;

  /// Specifies the symbol size to use for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  SymbolSize? size;

  LevelDisplay({
    this.parentheses,
    this.bracket,
    this.size,
  });

  factory LevelDisplay.fromXml(XmlElement xmlElement) {
    String? rawParentheses = xmlElement.getAttribute("parentheses");
    bool? parentheses;

    if (rawParentheses != null) {
      parentheses = YesNo.toBool(rawParentheses);
    }

    String? rawBracket = xmlElement.getAttribute("bracket");
    bool? bracket;

    if (rawBracket != null) {
      bracket = YesNo.toBool(rawBracket);
    }

    String? rawSimbolSize = xmlElement.getAttribute("symbol-size");
    SymbolSize? size;

    if (rawSimbolSize != null) {
      size = SymbolSize.fromString(rawSimbolSize);
    }

    return LevelDisplay(
      parentheses: parentheses,
      bracket: bracket,
      size: size,
    );
  }
}
