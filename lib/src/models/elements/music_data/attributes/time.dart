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

class TimeBeat extends Time {
  List<TimeSignature> timeSignatures;

  Interchangeable? interchangeable;

  TimeBeat({
    required this.timeSignatures,
    this.interchangeable,
    required super.number,
    required super.printStyleAlign,
    required super.printObject,
  });
}

/// The interchangeable type is used to represent the second in a pair of interchangeable dual time signatures,
/// such as the 6/8 in 3/4 (6/8).
///
/// A separate symbol attribute value is available compared to the time element's symbol attribute,
/// which applies to the first of the dual time signatures.
class Interchangeable {
  TimeRelation? timeRelation;

  List<TimeSignature> timeSignatures;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  TimeSymbol symbol;

  TimeSeparator timeSeparator;

  Interchangeable({
    this.timeRelation,
    required this.timeSignatures,
    required this.symbol,
    required this.timeSeparator,
  });
}

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator.
class TimeSignature {
  /// The beats element indicates the number of beats, as found in the numerator of a time signature.
  String beats;

  /// The beat-type element indicates the beat unit, as found in the denominator of a time signature.
  String beatType;

  TimeSignature({
    required this.beats,
    required this.beatType,
  });
}

enum TimeRelation {
  parentheses,
  bracket,
  equals,
  slash,
  space,
  hyphen;
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
