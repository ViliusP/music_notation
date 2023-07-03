import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// The [TimeModification] class represents durational changes in MusicXML,
/// including tuplets and double-note tremolos.
///
/// It shows the ratio between the actual notes being played and the number of
/// notes typically played for the same duration. This is often used to indicate
/// tuplets, where for example, three notes can be played in the time of two.
///
/// If the written note type of the tuplet is different from the surrounding notes
/// (e.g., an eighth-note triplet within quarter notes), this can be specified
/// with the [normalType] and [normalDots] properties.
///
/// More complex notations may require both a [TimeModification] and
/// a tuplet description for accurate representation.
///
/// For more details, refer to the MusicXML specification:
/// [The <time-modification> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/time-modification/).
class TimeModification {
  /// The number of notes that are played in the time typically taken by
  /// [normalNotes] number of notes.
  int actualNotes;

  /// The number of notes that are typically played in the time taken by
  /// [actualNotes] number of notes.
  int normalNotes;

  /// Specifies the written note type when different from the current note type.
  ///
  /// For example, it would be "eighth" for an eighth-note triplet within a quarter note context.
  NoteTypeValue? normalType;

  /// Specifies the number of dots for the written note type.
  ///
  /// This property can only exist if [normalType] is specified.
  int normalDots;

  /// Constructs a new [TimeModification] with the given values.
  ///
  /// All parameters except [actualNotes] and [normalNotes] are optional.
  TimeModification({
    required this.actualNotes,
    required this.normalNotes,
    this.normalType,
    this.normalDots = 0,
  });

  // Specifies the expected order of xml elements.
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'actual-notes': XmlQuantifier.required,
    'normal-notes': XmlQuantifier.required,
    {
      'normal-type': XmlQuantifier.required,
      'normal-dot': XmlQuantifier.zeroOrMore,
    }: XmlQuantifier.optional,
  };

  /// Constructs a new [TimeModification] instance from an [XmlElement].
  ///
  /// Validates the order and content of the xml elements.
  /// If [xmlElement] content sequence is in invalid order, it will throw a [XmlSequenceException].
  /// If any values are invalid, it will throw a [MusicXmlFormatException] or [MusicXmlTypeException].
  factory TimeModification.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement actualNotesElement = xmlElement.getElement("actual-notes")!;
    validateTextContent(actualNotesElement);
    int? actualNotes = int.tryParse(actualNotesElement.innerText);
    if (actualNotes == null || actualNotes < 0) {
      throw MusicXmlFormatException(
        message: "actual-notes value is not valid non negative integer",
        xmlElement: actualNotesElement,
        source: actualNotesElement.innerText,
      );
    }

    XmlElement normalNotesElement = xmlElement.getElement("normal-notes")!;
    validateTextContent(normalNotesElement);
    int? normalNotes = int.tryParse(normalNotesElement.innerText);
    if (normalNotes == null || normalNotes < 0) {
      throw MusicXmlFormatException(
        message: "normal-notes value is not valid non negative integer",
        xmlElement: normalNotesElement,
        source: normalNotesElement.innerText,
      );
    }

    XmlElement? normalTypeElement = xmlElement.getElement("normal-type");
    validateTextContent(normalTypeElement);
    NoteTypeValue? normalType = NoteTypeValue.fromString(
      normalTypeElement?.innerText ?? "",
    );
    if (normalTypeElement != null && normalType == null) {
      throw MusicXmlTypeException(
        message: "normal type value is not valid note type value",
        xmlElement: normalTypeElement,
      );
    }

    int normalDots = 0;
    if (normalType != null) {
      normalDots = xmlElement.findElements("normal-dot").length;
    }

    return TimeModification(
      actualNotes: actualNotes,
      normalNotes: normalNotes,
      normalType: normalType,
      normalDots: normalDots,
    );
  }
}
