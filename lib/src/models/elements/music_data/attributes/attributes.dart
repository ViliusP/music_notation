import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attribute_directive.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/measure_styles.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/part_symbol.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/staff_details.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Musical information that typically changes on measure boundaries.
/// This includes key and time signatures, clefs, transpositions, and staving.
/// When attributes are changed mid-measure, it affects the music in score order,
/// not in MusicXML document order.
class Attributes implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  Editorial editorial;

  /// Musical notation duration is commonly represented as fractions.
  /// The divisions element indicates
  /// how many divisions per quarter note are used to indicate a note's duration.
  /// For example, if duration = 1 and divisions = 2, this is an eighth note duration.
  /// Duration and divisions are used directly for generating sound output,
  /// so they must be chosen to take tuplets into account.
  ///
  /// Using a divisions element lets us use just one number to represent a duration for each note in the score,
  /// while retaining the full power of a fractional representation.
  /// If maximum compatibility with Standard MIDI 1.0 files is important,
  /// do not have the divisions value exceed 16383.
  double? divisions;

  /// Represents a key signature.
  /// Both traditional and non-traditional key signatures are supported.
  /// The optional number attribute refers to staff numbers.
  /// If absent, the key signature applies to all staves in the part.
  List<Key> keys;

  /// Time signatures are represented by the beats element
  /// for the numerator and the beat-type element for the denominator.
  List<Time> times;

  /// The staves element is used if there is more than one staff represented in the given part
  /// (e.g., 2 staves for typical piano parts).
  /// If absent, a value of 1 is assumed.
  ///
  /// Staves are ordered from top to bottom in a part in numerical order, with staff 1 above staff 2.
  int staves;

  /// Indicates how a symbol for a multi-staff part is indicated in the score.
  PartSymbol? partSymbol;

  /// The [instruments] is only used if more than one instrument is represented in the part
  /// (e.g., oboe I and II where they play together most of the time).
  ///
  /// If absent, a value of 1 is assumed.
  int instruments;

  /// Clefs are represented by a combination of sign, line, and clef-octave-change elements.
  List<Clef> clefs;

  /// Indicate different types of staves.
  List<StaffDetails> staffDetails;

  /// [Transposition] is base class for [Transpose] and [ForPart].
  ///
  /// ### transpose
  /// If the part is being encoded for a transposing instrument in written vs. concert pitch,
  /// the transposition must be encoded in the transpose element using the transpose type.
  ///
  /// ### for-part
  /// The for-part element is used in a concert score to indicate the transposition
  /// for a transposed part created from that score.
  ///
  /// It is only used in score files that contain a concert-score element in the defaults.
  ///
  /// This allows concert scores with transposed parts to be represented in a single uncompressed MusicXML file.
  List<Transposition> tranpositions;

  /// Directives are like directions, but can be grouped together with attributes for convenience.
  ///
  /// This is typically used for tempo markings at the beginning of a piece of music.
  ///
  /// This element was deprecated in Version 2.0 in favor of the direction element's directive attribute.
  ///
  /// Language names come from ISO 639, with optional country subcodes from ISO 3166.
  List<AttributeDirective> directives;

  /// Indicates a special way to print partial to multiple measures within a part.
  ///
  /// This includes multiple rests over several measures, repeats of beats,
  /// single, or multiple measures, and use of slash notation.
  List<MeasureStyle> measureStyles;

  Attributes({
    this.editorial = const Editorial.empty(),
    this.divisions,
    this.keys = const [],
    this.times = const [],
    this.staves = 1,
    this.partSymbol,
    this.instruments = 1,
    this.clefs = const [],
    this.staffDetails = const [],
    this.tranpositions = const [],
    this.directives = const [],
    this.measureStyles = const [],
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
    'divisions': XmlQuantifier.optional,
    'key': XmlQuantifier.zeroOrMore,
    'time': XmlQuantifier.zeroOrMore,
    'staves': XmlQuantifier.optional,
    'part-symbol': XmlQuantifier.optional,
    'instruments': XmlQuantifier.optional,
    'clef': XmlQuantifier.zeroOrMore,
    'staff-details': XmlQuantifier.zeroOrMore,
    // Exactly one of the following:
    'transpose': XmlQuantifier.zeroOrMore,
    'for-part': XmlQuantifier.zeroOrMore,
    //
    'directive': XmlQuantifier.zeroOrMore,
    'measure-style': XmlQuantifier.zeroOrMore,
  };

  static Attributes fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    // -------------    division   -------------
    // -------------      key      -------------
    // -------------      time     -------------
    // -------------     staves    -------------
    // -------------  part-sybol   -------------
    // -------------  instruments  -------------
    // -------------     clef      -------------
    // ------------- staff-details -------------
    // -------------   transpose   -------------
    // -------------   for-part    -------------
    // -------------   directive   -------------
    // ------------- measure-style -------------

    return Attributes(
      editorial: Editorial.fromXml(xmlElement),
      divisions: _divisionsFromXml(xmlElement),
      keys: xmlElement.findElements("key").map((e) => Key.fromXml(e)).toList(),
      times: _timesFromXml(xmlElement),
      staves: _stavesFromXml(xmlElement),
      partSymbol: _partSymbolFromXml(xmlElement),
      instruments: _instrumentsFromXml(xmlElement),
      clefs: _clefsFromXml(xmlElement),
      staffDetails: _staffDetailsFromXml(xmlElement),
      tranpositions: _transpositionsFromXml(xmlElement),
      directives: _directivesFromXml(xmlElement),
      measureStyles: _measureStylesFromXml(xmlElement),
    );
  }

  static double? _divisionsFromXml(XmlElement xmlElement) {
    XmlElement? divisionsElement = xmlElement.getElement("divisions");
    if (divisionsElement == null) {
      return null;
    }

    if (divisionsElement.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'divisions' element must have positive decimal content",
        xmlElement: divisionsElement,
      );
    }

    double? value = double.tryParse(divisionsElement.innerText);
    if (value == null || value < 0) {
      throw MusicXmlFormatException(
        message: "'divisions' value is not positive decimal",
        xmlElement: divisionsElement,
        source: divisionsElement.innerText,
      );
    }
    return value;
  }

  static List<Key> _keysFromXml(XmlElement xmlElement) {
    return [];
  }

  static List<Time> _timesFromXml(XmlElement xmlElement) {
    return [];
  }

  static int _stavesFromXml(XmlElement xmlElement) {
    return 1;
  }

  static PartSymbol _partSymbolFromXml(XmlElement xmlElement) {
    return PartSymbol();
  }

  static int _instrumentsFromXml(XmlElement xmlElement) {
    return 1;
  }

  static List<Clef> _clefsFromXml(XmlElement xmlElement) {
    return [];
  }

  static List<StaffDetails> _staffDetailsFromXml(XmlElement xmlElement) {
    return [];
  }

  static List<Transposition> _transpositionsFromXml(XmlElement xmlElement) {
    return [];
  }

  static List<AttributeDirective> _directivesFromXml(XmlElement xmlElement) {
    return [];
  }

  static List<MeasureStyle> _measureStylesFromXml(XmlElement xmlElement) {
    return [];
  }

  @override
  XmlElement toXml() {
    // TODO: implement toXml
    throw UnimplementedError();
  }
}

abstract class Transposition {
  String get name;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a transposition to apply to only the specified staff in the part.
  ///
  /// If absent, the transposition applies to all staves in the part.
  ///
  /// Per-staff transposition is most often used in parts that represent multiple instruments.
  int? number;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Transposition({
    this.number,
    this.id,
  });
}
