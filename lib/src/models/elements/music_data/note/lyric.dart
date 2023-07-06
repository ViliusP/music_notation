import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The text underlays for lyrics in MusicXML.
///
/// Lyrics are matched with notes in the order they are provided, regardless
/// of the lyric number. Lyrics can contain text, elision and syllabic elements.
///
/// If not otherwise specified:
/// - The justify value is center.
/// - The placement value is below.
/// - The valign value is baseline.
/// - The halign value matches the justify value.
///
/// For more details go to
/// [The \<lyric\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/lyric/).
class Lyric {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  /// Contains the main content of the lyric, which may include text, syllabic
  /// information, and lyric extender lines.
  LyricContent content;

  /// Provides editorial and related information.
  Editorial editorial;

  /// Indicates the end of a line of lyrics, which is used in Karaoke and other
  /// applications. This field originates from RP-017 for Standard MIDI File
  /// Lyric meta-events.
  Empty? endLine;

  /// Indicates the end of a paragraph of lyrics, which is used in Karaoke and
  /// other applications. This field originates from RP-017 for Standard MIDI
  /// File Lyric meta-events.
  Empty? endParagraph;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the lyric line number when multiple lines are present.
  String? number;

  /// Indicates the type of the lyric (e.g., verse or chorus).
  String? name;

  /// Specifies the horizontal alignment of the lyric text.
  /// This can be left, center, or right.
  HorizontalAlignment? justify;

  /// The positioning attributes of the lyric.
  Position position;

  /// Specifies whether the lyric appears above or below the music staff.
  Placement? placement;

  /// Indicates the color of an element.
  Color color;

  /// Indicates whether the lyric should be printed. This can override a note's
  /// `print lyric` attribute in cases where only some lyrics on a note are printed.
  bool printObject;

  /// Specifies which lyrics should be sung during repeated sections.
  String? timeOnly;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Lyric({
    required this.content,
    this.editorial = const Editorial.empty(),
    this.endLine,
    this.endParagraph,
    this.number,
    this.name,
    this.justify,
    this.position = const Position.empty(),
    this.placement,
    this.color = const Color.empty(),
    this.printObject = false,
    this.timeOnly,
    this.id,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _baseXmlExpectedOrder = {
    'end-line': XmlQuantifier.optional,
    'end-paragraph': XmlQuantifier.optional,
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
  };

  /// Reads the [xmlElement] and constructs a [Lyric] instance
  /// with the appropriate content and attributes.
  ///
  /// The method will throw an [XmlElementContentException] or
  /// [XmlSequenceException] if the XML element does not have the expected
  /// structure or content for a lyric.
  factory Lyric.fromXml(XmlElement xmlElement) {
    LyricContent? content;

    var extendElement = xmlElement.getElement("extend");
    var textElement = xmlElement.getElement("text");

    if (textElement != null) {
      content = TextLyric.fromXml(xmlElement);
    }
    if (extendElement != null && textElement == null) {
      validateSequence(
        xmlElement,
        {"extend": XmlQuantifier.required}..addAll(_baseXmlExpectedOrder),
      );
      content = Extend.fromXml(xmlElement);
    }

    if (xmlElement.getElement("laughing") != null) {
      validateSequence(
        xmlElement,
        {"laughing": XmlQuantifier.required}..addAll(_baseXmlExpectedOrder),
      );
      content = Laughing();
    }

    if (xmlElement.getElement("humming") != null) {
      validateSequence(
        xmlElement,
        {"humming": XmlQuantifier.required}..addAll(_baseXmlExpectedOrder),
      );
      content = Humming();
    }

    if (content == null) {
      throw XmlElementContentException(
        message: "Content is required for lyrics",
        xmlElement: xmlElement,
      );
    }

    var endLineElement = xmlElement.getElement("end-line");
    validateEmptyContent(endLineElement);
    var endParagraph = xmlElement.getElement("end-paragraph");
    validateEmptyContent(endParagraph);

    bool? printObject = YesNo.fromXml(
      xmlElement,
      CommonAttributes.printObject,
    );

    return Lyric(
      // -- Content --
      content: content,
      editorial: Editorial.fromXml(xmlElement),
      endLine: endLineElement != null ? const Empty() : null,
      endParagraph: endParagraph != null ? const Empty() : null,
      // -- Attributes --
      color: Color.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
      id: xmlElement.getAttribute("id"),
      justify: HorizontalAlignment.fromXml(xmlElement),
      name: xmlElement.getAttribute("name"),
      number: xmlElement.getAttribute("number"),
      placement: Placement.fromXml(xmlElement),
      printObject: printObject ?? true,
      timeOnly: TimeOnly.fromXml(xmlElement),
    );
  }
}

/// Represents the different types of content that a lyric can have.
sealed class LyricContent {}

/// A laughing voice. This may be used for special notation in vocal music.
class Laughing implements LyricContent {}

/// A humming voice. This may be used for special notation in vocal music.
class Humming implements LyricContent {}

/// A section of lyric text. A single lyric can have multiple text sections.
sealed class LyricText {}

class TextLyric implements LyricContent {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The parts of the lyric text, which can include syllables and elision characters.
  List<LyricText> textParts;

  /// An extender line for the lyric, which indicates the duration of a syllable or word.
  Extend? extend;

  TextLyric({
    required this.textParts,
    this.extend,
  });
  // Field(s): quantifier

  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'syllabic': XmlQuantifier.optional,
    'text': XmlQuantifier.required,
    {
      {
        "elision": XmlQuantifier.required,
        "syllabic": XmlQuantifier.optional,
      }: XmlQuantifier.optional,
      'text': XmlQuantifier.required
    }: XmlQuantifier.zeroOrMore,
    'extend': XmlQuantifier.optional,
  };

  /// Constructs a [TextLyric] instance from an [xmlElement].
  ///
  /// This method reads the XML element and constructs a TextLyric instance
  /// with the appropriate text parts and extend attribute.
  ///
  /// The method will throw an [XmlSequenceException] if the XML element
  /// does not have the expected structure or content for a text lyric.
  factory TextLyric.fromXml(XmlElement xmlElement) {
    validateSequence(
      xmlElement,
      {}
        ..addAll(_xmlExpectedOrder)
        ..addAll(Lyric._baseXmlExpectedOrder),
    );
    bool needToBreak = false;
    List<LyricText> textParts = [];
    for (var childElement in xmlElement.childElements) {
      switch (childElement.name.local) {
        case "syllabic":
          textParts.add(Syllabic.fromXml(childElement));
          break;
        case "text":
          textParts.add(TextElementData.fromXml(childElement));
          break;
        case "elision":
          textParts.add(Elision.fromXml(childElement));
          break;
        default:
          needToBreak = true;
          break;
      }
      if (needToBreak) break;
    }

    var extendElement = xmlElement.getElement("extend");

    return TextLyric(
      textParts: textParts,
      extend: extendElement != null ? Extend.fromXml(extendElement) : null,
    );
  }
}

/// Represents an Extend element in MusicXML.
///
/// An Extend element is used to indicate a word extension or melisma in lyrics,
/// or an extension of a figured bass notation.
///
/// The word extensions or melisma lines in lyrics occur when a single syllable
/// of a word in a lyric extends, or is sung across, more than one note. Similarly,
/// figured bass extensions occur when the same number is implied over several changes of harmony.
///
/// For more details go to
/// [The \<extend\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/extend/)
class Extend implements LyricContent {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //
  /// The position of this. It can be used to explicitly control element's
  /// vertical and horizontal positions.
  final Position position;

  /// The color for visual highlights or analysis purposes.
  final Color color;

  /// Indicates if this is the start, stop, or continuation of the extension.
  /// Before Version 3.0 this attribute was not available, and an [Extend] was
  /// always treated as the start of the extension.
  final StartStopContinue? type;

  const Extend({
    this.position = const Position.empty(),
    this.color = const Color.empty(),
    this.type,
  });

  /// Factory constructor to build the [Extend] instance from the provided [XmlElement].
  ///
  /// The XmlElement must be validated for empty content before passing to this constructor.
  /// It will throw a [XmlElementContentException] if invalid content is provided.
  factory Extend.fromXml(XmlElement xmlElement) {
    validateEmptyContent(xmlElement);
    return Extend(
      color: Color.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
      type: StartStopContinue.fromXml(xmlElement, false),
    );
  }
}

/// An elision between lyric syllables. The text content specifies the symbol
/// used to display the elision. Common values are a no-break space (Unicode 00A0),
/// an underscore (Unicode 005F), or an undertie (Unicode 203F).
///
/// If the text content is empty, the smufl attribute is used to specify the
/// symbol to use. Its value is a SMuFL canonical glyph name that starts with lyrics.
/// The SMuFL attribute is ignored if the elision glyph is already specified by
/// the text content. If neither text content nor a smufl attribute are present,
/// the elision glyph is application-specific.
///
/// For more details go to
/// [The \<elision\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/elision/).
class Elision implements LyricText {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The symbol used to display the elision, such as a no-break space,
  /// underscore, or undertie.
  final String? value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the font. This includes:
  /// - A comma-separated list of font names;
  /// - One of the CSS sizes or a numeric point size.
  /// - Normal or italic style.
  /// - Normal or bold weight.
  final Font font;

  /// Indicates the color of an element. If not specified, the color is
  /// determined by the application.
  final Color color;

  /// Specifies the SMuFL canonical glyph name that starts with "lyrics" to use
  /// as the elision symbol if the element text content is empty. It is ignored
  /// if the elision glyph is already specified by the text content. If neither
  /// text content nor a smufl attribute are present, the elision glyph is application-specific.
  final String? smufl;

  static const _smuflLyricsGlyphNameRegex = r'^lyrics.*$';

  Elision({
    this.value,
    this.font = const Font.empty(),
    this.color = const Color.empty(),
    this.smufl,
  });

  /// Constructs an instance of [Elision] from the provided XML element.
  ///
  /// It validates the content and the attributes of the element and raises a
  /// [MusicXmlFormatException] if any of the validations fail.
  ///
  /// If [xmlElement] contains multiple children it throws [XmlElementContentException].
  factory Elision.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    var content = xmlElement.innerText;

    var smuflAttribute = xmlElement.getAttribute(CommonAttributes.smufl);

    if (smuflAttribute != null &&
        !RegExp(_smuflLyricsGlyphNameRegex).hasMatch(smuflAttribute)) {
      throw MusicXmlFormatException(
        message:
            "'smufl' attribute in 'elision' is not smufl lyrics glyph name",
        xmlElement: xmlElement,
        source: smuflAttribute,
      );
    }

    return Elision(
      value: content.isEmpty ? null : content,
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
      smufl: smuflAttribute,
    );
  }
}

/// Syllabic types in lyrics.
///
/// In music notation, lyrics often span multiple notes, especially in melismatic singing.
/// The [Syllabic] enum is used to describe the role of each syllable within a word.
///
/// For more details go to
/// [syllabic data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/syllabic/).
enum Syllabic implements LyricText {
  /// Single-syllable words.
  single,

  /// Word-beginning syllables.
  begin,

  /// Word-ending syllables.
  end,

  /// Mid-word syllables
  middle;

  /// Converts a [String] to its corresponding [Syllabic] enum.
  ///
  /// If the [value] does not match any [Syllabic] values, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var syllabic = Syllabic.fromString("begin");
  /// print(syllabic);  // Prints: Syllabic.begin
  /// ```
  static Syllabic? fromString(String value) => values.firstWhereOrNull(
        (element) => element.name == value,
      );

  /// Parses an [XmlElement] to extract a [Syllabic] value.
  ///
  /// If the `syllabic` element content is not text, throws a [XmlElementContentException].
  ///
  /// If the `syllabic` element content is not valid, throws a [MusicXmlTypeException].
  ///
  /// Example:
  /// ```dart
  /// var xmlElement = XmlElement(XmlName("syllabic"), [], [XmlText("end")]);
  /// var syllabic = Syllabic.fromXml(xmlElement);
  /// print(syllabic);  // Prints: Syllabic.end
  /// ```
  static Syllabic fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    var syllabic = fromString(xmlElement.innerText);

    if (syllabic == null) {
      throw MusicXmlTypeException(
        message: "'syllabic' element content is not valid syllabic",
        xmlElement: xmlElement,
      );
    }
    return syllabic;
  }
}

/// Represents a syllable or portion of a syllable for lyric text underlay in MusicXML.
///
/// A hyphen in the string content should only be used for an actual hyphenated word.
/// Language names for text elements come from ISO 639, with optional country
/// subcodes from ISO 3166.
class TextElementData implements LyricText {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The syllable or portion of a syllable represented by this object.
  String value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the font. This includes:
  /// - A comma-separated list of font names;
  /// - One of the CSS sizes or a numeric point size.
  /// - Normal or italic style.
  /// - Normal or bold weight.
  Font font;

  /// Indicates the color of an element.
  Color color;

  /// Specifies the decoration (like underline, overline, strike-through).
  TextDecoration decoration;

  /// Specifies the rotation of the text element around the alignment point.
  ///
  /// Positive values are clockwise rotations, while negative values are
  /// counter-clockwise rotations. The value should be between `-180` and `180` degrees.
  double? rotation;

  /// Specifies the tracking (spacing between letters) of the text element.
  ///
  /// Values are either normal, which allows flexibility of letter-spacing f
  /// or purposes of text justification, or a number representing the number of
  /// ems to add between each letter.
  ///
  /// The number may be negative in order to subtract space. If not specified,
  /// the value is considered normal.
  double? letterSpacing;

  /// The language, according to ISO 639 with optional country subcodes from ISO 3166.
  String? lang;

  /// The direction of the text, overriding the Unicode bidirectional text algorithm.
  TextDirection? direction;

  TextElementData({
    required this.value,
    this.font = const Font.empty(),
    this.color = const Color.empty(),
    this.decoration = const TextDecoration.empty(),
    this.rotation,
    this.letterSpacing,
    this.lang,
    this.direction,
  });

  /// Creates a [TextElementData] instance from an [XmlElement].
  ///
  /// Validates the content of the [XmlElement], and if it's not empty,
  /// assigns it to [value] and extracts all other properties from the attributes of [XmlElement].
  ///
  /// Throws [XmlElementContentException] if the content of the [XmlElement] is empty.
  factory TextElementData.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    var content = xmlElement.innerText;
    if (content.isEmpty) {
      throw XmlElementContentException(
        message: "'text' element content cannot be empty",
        xmlElement: xmlElement,
      );
    }

    return TextElementData(
      value: content,
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
      decoration: TextDecoration.fromXml(xmlElement),
      rotation: RotationDegrees.fromXml(xmlElement),
      letterSpacing: NumberOrNormal.fromXml(
        xmlElement,
        CommonAttributes.letterSpacing,
      ),
      lang: xmlElement.getAttribute("xml:lang"),
      direction: TextDirection.fromXml(xmlElement),
    );
  }
}
