import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The lyric type represents text underlays for lyrics.
///
/// Two text elements that are not separated by an elision element are part of the same syllable,
/// but may have different text formatting.
///
/// The MusicXML XSD is more strict than the DTD in enforcing this
/// by disallowing a second syllabic element unless preceded by an elision element.
///
/// The lyric number indicates multiple lines, though a name can be used as well.
/// Common name examples are verse and chorus.
///
/// Justification is center by default; placement is below by default.
/// Vertical alignment is to the baseline of the text and horizontal alignment matches justification.
///
/// The print-object attribute can override a note's print-lyric attribute in cases where only some lyrics on a note are printed,
/// as when lyrics for later verses are printed in a block of text rather than with each note.
///
/// The time-only attribute precisely specifies which lyrics are to be sung which time through a repeated section.
class Lyric {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  LyricContent content;

  Editorial? editorial;

  /// The end-line element comes from RP-017 for Standard MIDI File Lyric meta-events.
  ///
  /// It facilitates lyric display for Karaoke and similar applications.
  Empty? endLine;

  /// The end-paragraph element comes from RP-017 for Standard MIDI File Lyric meta-events.
  ///
  /// It facilitates lyric display for Karaoke and similar applications.
  Empty? endParagraph;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the lyric line when multiple lines are present.
  String? number;

  /// Indicates the name of the lyric type. Common examples are verse and chorus.
  String? name;

  /// Indicates left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  HorizontalAlignment? justify;

  Position position;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement placement;

  /// Indicates the color of an element.
  Color color;

  bool printObject = false;

  /// Specifies which lyrics are to be sung which times through a repeated section.
  String? timeOnly;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Lyric({
    required this.content,
    this.editorial,
    this.endLine,
    this.endParagraph,
    this.number,
    this.name,
    this.justify,
    required this.position,
    required this.placement,
    required this.color,
    this.printObject = false,
    this.timeOnly,
    this.id,
  });

  factory Lyric.fromXml(XmlElement xmlElement) {
    const String n = "";

    LyricContent? content;

    switch (n) {
      case _LyricContentNames.extend:
        content = Extend.fromXml(xmlElement);
        break;
      case _LyricContentNames.laughing:
        content = EmptyLaughing();
        break;
      case _LyricContentNames.humming:
        content = EmptyHumming();
        break;
      case _LyricContentNames.syllabic:
      case _LyricContentNames.text:
        content = LyricSequence.fromXml(xmlElement);
        break;
      default:
        break;
    }

    if (content == null) {
      throw XmlElementContentException(
        message: "Content is required for lyrics",
        xmlElement: xmlElement,
      );
    }

    return Lyric(
      color: const Color.empty(),
      placement: Placement.above,
      position: Position(),
      content: content,
    );
  }
}

class _LyricContentNames {
  static const extend = "extend";
  static const laughing = "laughing";
  static const humming = "humming";
  static const syllabic = "syllabic";
  static const text = "text";
}

abstract class LyricContent {}

/// Represents a laughing voice
class EmptyLaughing extends LyricContent {}

/// Represents a humming voice.
class EmptyHumming extends LyricContent {}

class LyricSequence extends LyricContent {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  Syllabic? syllabic;
  TextElementData text;

  List<ElisionSyllabicText>? elisionSyllabicTextList;

  Extend? extend;

  LyricSequence({
    required this.syllabic,
    required this.text,
  });

  factory LyricSequence.fromXml(XmlElement xmlElement) {
    return LyricSequence(
      syllabic: Syllabic.begin,
      text: TextElementData(
        value: "",
        color: Color(),
        decoration: TextDecoration(),
        font: Font(),
      ),
    );
  }
}

class ElisionSyllabicText {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  Elision elision;
  Syllabic? syllabic;
  TextElementData text;

  ElisionSyllabicText({
    required this.elision,
    this.syllabic,
    required this.text,
  });
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
class Elision {
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

/// Lyric hyphenation is indicated by the syllabic type.
enum Syllabic {
  /// Single-syllable words.
  single,

  /// Word-beginning syllables.
  begin,

  /// Word-ending syllables.
  end,

  /// Mid-word syllables
  middle;
}

/// Represents a syllable or portion of a syllable for lyric text underlay in MusicXML.
///
/// A hyphen in the string content should only be used for an actual hyphenated word.
/// Language names for text elements come from ISO 639, with optional country
/// subcodes from ISO 3166.
class TextElementData {
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
