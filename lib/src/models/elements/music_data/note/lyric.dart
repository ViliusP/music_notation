import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/music_data/note/note.dart';
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

/// The laughing element represents a laughing voice.
class EmptyLaughing extends LyricContent {}

/// The humming element represents a humming voice.
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

/// The extend type represents lyric word extension / melisma lines as well as figured bass extensions.
///
/// The optional type and position attributes are added in Version 3.0 to provide better formatting control.
class Extend extends LyricContent {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //
  Position position;
  Color color;

  Extend({
    required this.position,
    required this.color,
  });

  factory Extend.fromXml(XmlElement xmlElement) {
    return Extend(
      color: Color(),
      position: Position(),
    );
  }
}

/// The elision type represents an elision between lyric syllables.
///
/// The text content specifies the symbol used to display the elision.
///
/// Common values are a no-break space (Unicode 00A0), an underscore (Unicode 005F), or an undertie (Unicode 203F).
///
/// If the text content is empty, the smufl attribute is used to specify the symbol to use. Its value is a SMuFL canonical glyph name that starts with lyrics.
///
/// The SMuFL attribute is ignored if the elision glyph is already specified by the text content.
///
/// If neither text content nor a smufl attribute are present, the elision glyph is application-specific.
class Elision {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  String value;

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

  /// smufl-lyrics-glyph-name
  String smufl;

  Elision({
    required this.value,
    required this.font,
    required this.color,
    required this.smufl,
  });
}

/// Lyric hyphenation is indicated by the syllabic type.
///
/// The single, begin, end, and middle values represent single-syllable words, word-beginning syllables, word-ending syllables, and mid-word syllables, respectively.
enum Syllabic {
  single,
  begin,
  end,
  middle;
}

/// The text-element-data type represents a syllable or portion of a syllable for lyric text underlay.
///
/// A hyphen in the string content should only be used for an actual hyphenated word.
/// Language names for text elements come from ISO 639, with optional country subcodes from ISO 3166.
class TextElementData {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  String value;

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

  TextDecoration decoration;

  /// The rotation attribute is used to rotate text around the alignment point specified by the halign and valign attributes.
  ///
  /// Positive values are clockwise rotations, while negative values are counter-clockwise rotations.
  ///
  /// type of "text-rotation" -> "rotation-degrees".
  ///
  /// Minimum -180.
  /// Maximum 180.
  double? textRotation;

  /// Specifies text tracking. Values are either normal,
  /// which allows flexibility of letter-spacing for purposes of text justification
  /// or a number representing the number of ems to add between each letter.
  ///
  /// The number may be negative in order to subtract space. The value is normal if not specified.
  ///
  /// Null means "normal".
  double? letterSpacing;

  String? lang;

  TextDirection? direction;

  TextElementData({
    required this.value,
    required this.font,
    required this.color,
    required this.decoration,
    this.textRotation,
    this.letterSpacing,
    this.lang,
    this.direction,
  });
}
