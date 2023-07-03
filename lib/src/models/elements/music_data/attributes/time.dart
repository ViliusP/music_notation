import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator.
///
/// The symbol attribute is used to indicate common and cut time symbols as well as a single number display.
///
/// Multiple pairs of beat and beat-type elements are used for composite time signatures with multiple denominators,
/// such as 2/4 + 3/8. A composite such as 3+2/8 requires only one beat/beat-type pair.
///
/// The print-object attribute allows a time signature to be specified but not printed,
/// as is the case for excerpts from the middle of a score. The value is "yes" if not present.
///
/// The optional number attribute refers to staff numbers within the part.
/// If absent, the time signature applies to all staves in the part.
sealed class Time {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a time signature to apply to only the specified staff in the part.
  /// If absent, the time signature applies to all staves in the part.
  int? number;

  /// Indicates how to display a time signature,
  /// such as by using common and cut time symbols or a single number display.
  TimeSymbol symbol;

  /// Indicates how to display the arrangement between the [beats] and [beatType] values in a time signature.
  TimeSeparator separator;

  PrintStyleAlign printStyleAlign;

  bool printObject;

  String? id;

  Time({
    this.number,
    this.symbol = TimeSymbol.normal,
    this.separator = TimeSeparator.none,
    this.printStyleAlign = const PrintStyleAlign.empty(),
    this.printObject = true,
    this.id,
  });

  static int? _numberFromXml(XmlElement xmlElement) {
    String? rawNumber = xmlElement.getAttribute("number");

    if (rawNumber == null) {
      return null;
    }

    int? number = int.tryParse(rawNumber);

    if (number == null || number < 1) {
      throw MusicXmlFormatException(
        message: "'number' in 'time' must be positive integer",
        xmlElement: xmlElement,
      );
    }

    return number;
  }

  static TimeSeparator _seperatorFromXml(XmlElement xmlElement) {
    String? rawSeparator = xmlElement.getAttribute("separator");

    if (rawSeparator == null) {
      return TimeSeparator.none;
    }

    TimeSeparator? separator = TimeSeparator.fromString(rawSeparator);

    if (separator == null) {
      throw MusicXmlTypeException(
        message: "'separator' in 'time' must be time-seperator",
        xmlElement: xmlElement,
      );
    }

    return separator;
  }

  static TimeSymbol _symbolFromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.getAttribute("symbol");

    if (rawValue == null) {
      return TimeSymbol.normal;
    }

    TimeSymbol? value = TimeSymbol.fromString(rawValue);

    if (value == null) {
      throw MusicXmlTypeException(
        message: "'symbol' in 'time' must be time-symbol",
        xmlElement: xmlElement,
      );
    }

    return value;
  }

  factory Time.fromXml(XmlElement xmlElement) {
    try {
      return TimeBeat.fromXml(xmlElement);
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }

    try {
      return SenzaMisura.fromXml(xmlElement);
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }

    throw XmlElementContentException(
      message: "Invalid 'time' element content",
      xmlElement: xmlElement,
    );
  }
}

/// Represents the time element of a musical score in the form of beat notation.
/// The [TimeBeat] class is a subclass of the [Time] class and adds information about the
/// interchangeable dual time signatures in addition to the beat notation.
class TimeBeat extends Time {
  /// A list of time signatures for the beat notation.
  List<TimeSignature> timeSignatures;

  /// Represents the second in a pair of interchangeable dual time signatures,
  /// such as the 6/8 in 3/4 (6/8). It is optional and can be null.
  Interchangeable? interchangeable;

  TimeBeat({
    required this.timeSignatures,
    this.interchangeable,
    super.number,
    super.symbol,
    super.separator,
    super.printStyleAlign,
    super.printObject,
    super.id,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'beats': XmlQuantifier.required,
      'beat-type': XmlQuantifier.required,
    }: XmlQuantifier.oneOrMore,
    'interchangeable': XmlQuantifier.optional,
  };

  /// Creates an instance of the [TimeBeat] from an XML element.
  /// It parses the XML element to extract the necessary information
  /// for the creation of the [TimeBeat] object.
  /// If the XML element does not provide valid values,
  /// [XmlElementContentException] or [MusicXmlTypeException] will be thrown.
  factory TimeBeat.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var childElements = xmlElement.childElements.toList();

    Interchangeable? interchangeable;
    List<TimeSignature> timeSignatures = [];

    for (int i = 0; i < childElements.length ~/ 2 * 2; i += 2) {
      XmlElement beatsElement = childElements[i];
      validateTextContent(beatsElement);
      XmlElement beatTypeElement = childElements[i + 1];
      validateTextContent(beatTypeElement);

      timeSignatures.add(
        TimeSignature(
          beats: beatsElement.innerText,
          beatType: beatTypeElement.innerText,
        ),
      );

      if (childElements.length % 2 != 0 &&
          childElements[i + 2].name.local == "interchangeable") {
        interchangeable = Interchangeable.fromXml(childElements[i + 2]);
      }
    }

    bool? printObject = YesNo.fromXml(xmlElement, CommonAttributes.printObject);

    return TimeBeat(
      timeSignatures: timeSignatures,
      interchangeable: interchangeable,
      number: Time._numberFromXml(xmlElement),
      symbol: Time._symbolFromXml(xmlElement),
      separator: Time._seperatorFromXml(xmlElement),
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
      printObject: printObject ?? true,
      id: xmlElement.getAttribute("id"),
    );
  }
}

/// Represent the second in a pair of interchangeable dual time signatures,
/// such as the 6/8 in 3/4 (6/8).
///
/// A separate symbol attribute value is available compared to the time element's symbol attribute,
/// which applies to the first of the dual time signatures.
class Interchangeable {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Represents the relationship between the beats and beat-type values
  /// in dual time signatures.
  TimeRelation? timeRelation;

  /// A list of time signatures for the second of the dual time signatures.
  List<TimeSignature> timeSignatures;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates how to display the arrangement between the beats and
  /// beat-type values in the second of the dual time signatures.
  TimeSymbol symbol;

  /// Indicates how to display the second of the dual time signatures,
  /// such as by using common and cut time symbols or a single number display.
  TimeSeparator timeSeparator;

  Interchangeable({
    this.timeRelation,
    required this.timeSignatures,
    this.symbol = TimeSymbol.normal,
    this.timeSeparator = TimeSeparator.none,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'beats': XmlQuantifier.required,
      'beat-type': XmlQuantifier.required,
    }: XmlQuantifier.oneOrMore,
    // time-relation in example is below time signature group,
    // but in website and musicxml.xsd above it.
    'time-relation': XmlQuantifier.optional,
  };

  /// Creates an instance of the `Interchangeable` class from an XML element.
  /// It parses the XML element to extract the necessary
  /// information for the creation of the `Interchangeable` object.
  /// If the XML element does not provide valid values,
  /// [XmlElementContentException] or [MusicXmlTypeException] will be thrown.
  factory Interchangeable.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var childElements = xmlElement.childElements.toList();

    TimeRelation? timeRelation;
    List<TimeSignature> timeSignatures = [];

    for (int i = 0; i < childElements.length ~/ 2 * 2; i += 2) {
      XmlElement beatsElement = childElements[i];
      validateTextContent(beatsElement);
      XmlElement beatTypeElement = childElements[i + 1];
      validateTextContent(beatTypeElement);

      timeSignatures.add(TimeSignature(
        beats: beatsElement.innerText,
        beatType: beatTypeElement.innerText,
      ));

      if (childElements.length % 2 != 0 &&
          childElements[i + 2].name.local == "time-relation") {
        validateTextContent(childElements[i + 2]);
        timeRelation = TimeRelation.fromString(childElements[i + 2].innerText);
        if (timeRelation == null) {
          throw MusicXmlTypeException(
            message:
                "${childElements[i + 2].innerText} is not valid time-relation value",
            xmlElement: xmlElement,
          );
        }
      }
    }

    return Interchangeable(
      timeSignatures: timeSignatures,
      timeRelation: timeRelation,
    );
  }
}

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator.
class TimeSignature {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Indicates the number of beats, as found in the numerator of a time signature.
  String beats;

  /// Indicates the beat unit, as found in the denominator of a time signature.
  String beatType;

  TimeSignature({
    required this.beats,
    required this.beatType,
  });
}

/// Indicates the symbol used to represent the interchangeable aspect of dual time signatures.
enum TimeRelation {
  parentheses,
  bracket,
  equals,
  slash,
  space,
  hyphen;

  static TimeRelation? fromString(String value) {
    return values.firstWhereOrNull((v) => v.name == value);
  }
}

/// Explicitly indicates that no time signature is present.The optional element
/// content indicates the symbol to be used, if any, such as an X.
///
/// The time element's symbol attribute is not used when a senza-misura element is present.
class SenzaMisura extends Time {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Indicates the symbol to be used, if any, such as an X.
  String content;

  SenzaMisura({
    this.content = "",
    super.number,
    super.symbol,
    super.separator,
    super.printStyleAlign,
    super.printObject,
    super.id,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'senza-misura': XmlQuantifier.required,
  };

  factory SenzaMisura.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? senzaMisuraElement = xmlElement.getElement("senza-misura");
    validateTextContent(senzaMisuraElement);

    bool? printObject = YesNo.fromXml(
      xmlElement,
      CommonAttributes.printObject,
    );

    return SenzaMisura(
      content: senzaMisuraElement!.innerText,
      number: Time._numberFromXml(xmlElement),
      symbol: Time._symbolFromXml(xmlElement),
      separator: Time._seperatorFromXml(xmlElement),
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
      printObject: printObject ?? true,
      id: xmlElement.getAttribute("id"),
    );
  }
}

/// Indicates how to display a time signature.
enum TimeSymbol {
  /// Common time symbol.
  common,

  /// Cut time symbol.
  cut,

  /// Single number with an implied denominator.
  singleNumber,

  /// Indicates that the beat-type should be represented with the corresponding
  /// downstem note rather than a number.
  note,

  /// Indicates that the beat-type should be represented with a dotted downstem
  /// note that corresponds to three times the beat-type value, and a numerator
  /// that is one third the beats value.
  dottedNote,

  /// Usual fractional display, and is the implied symbol type if none is specified.
  normal;

  static TimeSymbol? fromString(String value) {
    return values.firstWhereOrNull(
      (element) => element.name == hyphenToCamelCase(value),
    );
  }
}

/// Indicates how to display the arrangement between the beats and beat-type
/// values in a time signature. The default value is none.
enum TimeSeparator {
  /// Represents no separator with the beats and beat-type arranged vertically.
  none,

  /// Horizontal line with the beats and beat-type arranged on either side of the separator line.
  horizontal,

  /// Diagonal line with the beats and beat-type arranged on either side of the separator line.
  diagonal,

  /// Vertical line with the beats and beat-type arranged on either side of the separator line.
  vertical,

  /// Represents no separator with the beats and beat-type arranged horizontally.
  adjacent;

  static TimeSeparator? fromString(String value) {
    return values.firstWhereOrNull((element) => element.name == value);
  }
}
