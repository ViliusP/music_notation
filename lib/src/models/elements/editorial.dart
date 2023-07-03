import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/exceptions.dart';
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
  final Footnote? footnote;

  final Level? level;

  Editorial({
    this.footnote,
    this.level,
  });

  const Editorial.empty()
      : footnote = null,
        level = null;

  static Editorial fromXml(XmlElement xmlElement) {
    return Editorial();
  }
}

/// Specifies editorial information for different MusicXML elements.
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

/// Represents an editorial level in MusicXML.
///
/// It defines whether symbols are surrounded by parentheses, brackets,
/// or are presented in a different size.
///
/// If any attribute is not specified, it is left to application defaults.
class LevelDisplay {
  /// Specifies whether or not parentheses are put around a symbol for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  final bool? parentheses;

  /// Specifies whether or not brackets are put around a symbol for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  final bool? bracket;

  /// Specifies the symbol size to use for an editorial indication.
  ///
  /// If not specified, it is left to application defaults.
  final SymbolSize? size;

  /// Creates a new instance of [LevelDisplay].
  ///
  /// All parameters are optional and default to `null`.
  LevelDisplay({
    this.parentheses,
    this.bracket,
    this.size,
  });

  /// Constructs an empty [LevelDisplay] object where all properties are `null`.
  const LevelDisplay.empty()
      : parentheses = null,
        bracket = null,
        size = null;

  /// Constructs a new [LevelDisplay] instance from an [XmlElement].
  ///
  /// If the any of attributes in the [xmlElement] is not a valid,
  /// it will throw a [MusicXmlTypeException].
  factory LevelDisplay.fromXml(XmlElement xmlElement) {
    String? rawSymbolSize = xmlElement.getAttribute("size");
    SymbolSize? size = SymbolSize.fromString(rawSymbolSize ?? "");

    if (rawSymbolSize != null && size == null) {
      throw MusicXmlTypeException(
        message: "$rawSymbolSize is not valid simbol size",
        xmlElement: xmlElement,
      );
    }

    return LevelDisplay(
      parentheses: YesNo.fromXml(xmlElement, "parentheses"),
      bracket: YesNo.fromXml(xmlElement, "bracket"),
      size: size,
    );
  }
}

// The common combination of editorial and voice information for a musical element.
class EditorialVoice extends Editorial {
  /// Musical events (e.g. notes, chords, rests) that proceeds linearly in time.
  ///
  /// The [voice] is used to distinguish between multiple voices in individual parts.
  /// It is defined within a [EditorialVoice] due to its multiple uses within
  /// the MusicXML schema.
  final String? voice;

  EditorialVoice({
    super.footnote,
    super.level,
    this.voice,
  });

  const EditorialVoice.empty()
      : voice = null,
        super.empty();

  factory EditorialVoice.fromXml(XmlElement xmlElement) {
    var editorial = Editorial.fromXml(xmlElement);

    return EditorialVoice(
      voice: xmlElement.getElement("voice")?.innerText,
      footnote: editorial.footnote,
      level: editorial.level,
    );
  }
}
