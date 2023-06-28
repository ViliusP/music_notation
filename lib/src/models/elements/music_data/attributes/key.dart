import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';

/// The key type represents a key signature.
/// Both traditional and non-traditional key signatures are supported.
/// The optional number attribute refers to staff numbers.
/// If absent, the key signature applies to all staves in the part.
/// Key signatures appear at the start of each system unless the print-object attribute has been set to "no".
///
/// For more details go to
/// [The \<key\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key/).
abstract class Key {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The optional list of key-octave elements is used to
  /// specify in which octave each element of the key signature appears.
  List<KeyOctave> octaves;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a key signature to apply to only the specified staff in the part.
  /// If absent, the key signature applies to all staves in the part.
  int? number;

  PrintStyle printStyle;

  bool printObject;

  String? id;

  Key({
    this.octaves = const [],
    this.number,
    this.printStyle = const PrintStyle.empty(),
    this.printObject = true,
    this.id,
  });

  factory Key.fromXml(XmlElement xmlElement) {
    try {
      return TraditionalKey.fromXml(xmlElement);
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }
    try {
      return NonTraditionalKey.fromXml(xmlElement);
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }

    throw XmlElementContentException(
      message: "Invalid 'key' element content",
      xmlElement: xmlElement,
    );
  }
}

/// Represents a traditional key in the MusicXML standard.
///
/// A traditional key includes information about optional cancellation,
/// required number of fifths, and optional mode. The `fifths` indicates
/// the number of sharps or flats in a traditional key signature and `mode`
/// indicates major, minor, or other modes.
///
/// Represents the traditional key in the MusicXML format.
class TraditionalKey extends Key {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Indicates that the old key signature should be cancelled before the new one appears.
  Cancel? cancel;

  /// Represents the number of flats or sharps in a traditional key signature.
  ///
  /// Negative numbers are used for flats and positive numbers for sharps,
  /// reflecting the key's placement within the circle of fifths (hence the element name).
  int fifths;

  /// The mode type is used to specify major/minor and other mode distinctions.
  ///
  /// Valid mode values include major, minor, dorian, phrygian, lydian, mixolydian, aeolian, ionian, locrian, and none.
  Mode? mode;

  TraditionalKey({
    this.cancel,
    required this.fifths,
    this.mode,
    super.octaves,
    super.printStyle,
    super.printObject,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'cancel': XmlQuantifier.optional,
    'fifths': XmlQuantifier.required,
    'mode': XmlQuantifier.optional,
    'key-octave': XmlQuantifier.zeroOrMore,
  };

  /// Creates an instance of the [TraditionalKey] class from the given [XmlElement].
  ///
  /// This factory constructor parses the provided XML element to read the necessary
  /// information to instantiate a `TraditionalKey`. The `fifths` element, which
  /// represents the number of flats or sharps in the key, is required.
  ///
  /// The `cancel` and `mode` elements are optional. If present, they are used
  /// to specify the `cancel` field and `mode` respectively. If these elements are
  /// not found, the corresponding fields will be set to null.
  ///
  /// The provided XML element should represent a valid 'key' as per MusicXML standard.
  /// If the XML doesn't conform to the standard, exceptions [XmlElementContentException] or
  /// [MusicXmlFormatException] may be thrown.
  factory TraditionalKey.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? cancelElement = xmlElement.getElement('cancel');
    XmlElement? fifthsElement = xmlElement.getElement('fifths');
    if (fifthsElement == null) {
      throw XmlElementContentException(
        message: "'fifths' element is required for tradition key",
        xmlElement: xmlElement,
      );
    }
    if (fifthsElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message: "'fifths' element must only have fifths type content",
        xmlElement: xmlElement,
      );
    }
    int? fifths = int.tryParse(fifthsElement.innerText);

    if (fifths == null) {
      throw MusicXmlFormatException(
        message: "'fifths' element content is not type of fifths",
        xmlElement: xmlElement,
        source: fifthsElement.innerText,
      );
    }

    XmlElement? modeElement = xmlElement.getElement('mode');
    if (modeElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'mode' element must only have mode type content",
        xmlElement: xmlElement,
      );
    }
    Mode? mode = Mode.fromString(modeElement?.innerText ?? "");
    if (modeElement != null && mode == null) {
      throw MusicXmlTypeException(
        message: "'${modeElement.innerText}' is not type of mode",
        xmlElement: xmlElement,
      );
    }

    return TraditionalKey(
      cancel: cancelElement != null ? Cancel.fromXml(cancelElement) : null,
      fifths: fifths,
      mode: mode,
      octaves: xmlElement
          .findElements('key-octave')
          .map((e) => KeyOctave.fromXml(e))
          .toList(),
    );
  }
}

/// Type to specify major/minor and other mode distinctions.
///
/// For more details go to
/// [mode data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/mode/).
enum Mode {
  major,
  minor,
  dorian,
  phrygian,
  lydian,
  mixolydian,
  aeolian,
  ionian,
  locrian,
  none;

  static Mode? fromString(String value) {
    return values.firstWhereOrNull((e) => e.name == value);
  }
}

/// A cancel element indicates that the old key signature should be cancelled before the new one appears.
/// This will always happen when changing to C major or A minor and need not be specified then.
///
/// For more details go to
/// [The \<cancel\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/cancel/).
class Cancel {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Matches the fifths value of the cancelled key signature
  /// (e.g., a cancel of -2 will provide an explicit cancellation
  /// for changing from B flat major to F major).
  int value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates where the cancellation appears relative to the new key signature.
  ///
  /// It is left if not specified.
  CancelLocation location;

  Cancel({
    required this.value,
    this.location = CancelLocation.left,
  });

  factory Cancel.fromXml(XmlElement xmlElement) {
    if (xmlElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message: "'cancel' element must only have fifths type content",
        xmlElement: xmlElement,
      );
    }
    int? fifths = int.tryParse(xmlElement.innerText);
    if (fifths == null) {
      throw MusicXmlFormatException(
        message: "'fifths' element content is not type of fifths",
        xmlElement: xmlElement,
        source: xmlElement.innerText,
      );
    }

    String? rawLocation = xmlElement.getAttribute("location");

    CancelLocation? location = CancelLocation.fromString(rawLocation ?? "");

    if (rawLocation != null && location == null) {
      throw MusicXmlTypeException(
        message: "'$rawLocation' is not type of CancelLocation.",
        xmlElement: xmlElement,
      );
    }

    return Cancel(
      value: fifths,
      location: location ?? CancelLocation.left,
    );
  }
}

/// Indicate where a key signature cancellation appears relative to a new key signature:
/// to the left, to the right, or before the barline and to the left.
///
/// It is [left] by default. For mid-measure key elements,
/// a cancel-location of before-barline should be treated like a cancel-location of left.
///
/// Example usage:
///
/// ```dart
/// var location = CancelLocation.fromString('before-barline');
/// print(location);  // prints: CancelLocation.beforeBarline
/// ```
///
/// For more details go to
/// [cancel-location data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/cancel-location/).
enum CancelLocation {
  /// Cancellations appears to the left of the new key signature.
  left,

  /// Cancellations appears to the right of the new key signature.
  right,

  /// Cancellations appears before the barline.
  beforeBarline;

  /// Converts a [value] string to its corresponding [CancelLocation] enum value.
  ///
  /// The [value] string is expected to match one of the [CancelLocation] enum names
  /// (case insensitive, with hyphen-separated words).
  /// If there is no match, this method returns `null`.
  ///
  /// Example:
  ///
  /// ```dart
  /// var location = CancelLocation.fromString('left');
  /// print(location);  // prints: CancelLocation.left
  /// ```
  static CancelLocation? fromString(String value) {
    return values.firstWhereOrNull(
      (v) => v.name == hyphenToCamelCase(value),
    );
  }
}

/// A class representing a non-traditional key in the MusicXML format.
///
/// In contrast to a traditional key, a non-traditional key consists
/// of a list of non-traditional key contents,
/// which specify the step (pitch without octave or accidental),
/// the alter (microtonal alteration), and an optional accidental.
class NonTraditionalKey extends Key {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The list of non-traditional key content objects.
  ///
  /// Each [NonTraditionalKeyContent] object represents a unique alteration
  /// of step and alter, with an optional accidental.
  List<NonTraditionalKeyContent> content;

  NonTraditionalKey({
    this.content = const [],
    super.octaves,
    super.printStyle,
    super.printObject,
  });

  /// A mapping that describes the expected order of XML elements.
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'key-step': XmlQuantifier.required,
      'key-alter': XmlQuantifier.required,
      'key-accidental': XmlQuantifier.optional,
    }: XmlQuantifier.zeroOrMore,
    'key-octave': XmlQuantifier.zeroOrMore,
  };

  /// Creates a new instance of [NonTraditionalKey] from a parsed XML element.
  ///
  /// This factory method validates the sequence of the given [xmlElement]
  /// based on the [_xmlExpectedOrder] mapping, then constructs and returns
  /// a new [NonTraditionalKey] object.
  ///
  /// If the content of any XML element does not match the expected type or order,
  /// a [MusicXmlFormatException] or [MusicXmlTypeException] is thrown.
  factory NonTraditionalKey.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    List<KeyOctave> octaves = [];
    List<NonTraditionalKeyContent> content = [];

    Step? step;
    double? alter;
    KeyAccidental? accidental;

    for (var (index, childElement) in xmlElement.childElements.indexed) {
      switch (childElement.name.local) {
        case 'key-step':
          if (index != 0) {
            content.add(NonTraditionalKeyContent(
              step: step!,
              alter: alter!,
              accidental: accidental,
            ));
          }
          validateTextContent(childElement);
          step = Step.fromString(childElement.innerText);
          if (step == null) {
            throw MusicXmlTypeException(
              message: '${childElement.innerText} is not valid step',
              xmlElement: xmlElement,
            );
          }
          alter = null;
          accidental = null;
          break;
        case 'key-alter':
          validateTextContent(childElement);
          alter = double.tryParse(childElement.innerText);
          if (alter == null) {
            throw MusicXmlFormatException(
              message: '${childElement.innerText} is not semitones',
              xmlElement: xmlElement,
              source: childElement.innerText,
            );
          }
          break;
        case 'key-accidental':
          accidental = KeyAccidental.fromXml(childElement);
          break;
        default:
          break;
      }
      if (childElement.name.local == 'key-octave') {
        octaves.add(KeyOctave.fromXml(childElement));
      }
    }
    // Adds the last one
    content.add(NonTraditionalKeyContent(
      step: step!,
      alter: alter!,
      accidental: accidental,
    ));

    bool? printObject = YesNo.fromXml(xmlElement, CommonAttributes.printObject);

    return NonTraditionalKey(
      content: content,
      octaves: octaves,
      printStyle: PrintStyle.fromXml(xmlElement),
      printObject: printObject ?? true,
    );
  }
}

class NonTraditionalKeyContent {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The step (pitch class) of this non-traditional key content.
  ///
  /// The step is represented by an instance of the [Step] enum,
  /// which includes values from A to G.
  Step step;

  /// The microtonal alteration of the step for this non-traditional key content.
  ///
  /// This is represented as a double, where 1.0 represents a one semitone sharp,
  /// -1.0 represents a one semitone flat, 0.5 represents a quarter tone sharp, etc.
  double alter;

  /// The [KeyAccidental] for this non-traditional key content.
  ///
  /// This is optional, and may be `null` if no accidental is specified.
  KeyAccidental? accidental;

  NonTraditionalKeyContent({
    required this.step,
    required this.alter,
    this.accidental,
  });
}

/// Representes a key accidental in MusicXML format.
///
/// Indicates the accidental to be displayed in the key signature.
/// It is used for disambiguating microtonal accidentals.
/// The different element names indicate the different meaning of altering
/// notes in a scale versus altering a sounding pitch.
class KeyAccidental {
  /// Indicates the type of the accidental
  /// (sharp, flat, natural, double-sharp, flat-flat, etc.).
  final AccidentalValue value;

  /// Specifies a Standard Music Font Layout (SMuFL) accidental character by its canonical glyph name.
  final String? smufl;

  KeyAccidental({
    required this.value,
    this.smufl,
  });

  /// Parses the provided [XmlElement] and uses itscontent and attributes
  /// to initialize a new [KeyAccidental] object.
  ///
  /// The content of the [XmlElement] is used to determine the [AccidentalValue].
  /// The optional "smufl" attribute of the [XmlElement] is used to set the [smufl] property.
  ///
  /// If the [XmlElement] has multiple children or nested elements,
  /// an [XmlElementContentException] is thrown.
  factory KeyAccidental.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    return KeyAccidental(
      value: AccidentalValue.fromXml(xmlElement),
      smufl: xmlElement.getAttribute("smufl"),
    );
  }
}

/// Specifies in which octave an element of a key signature appears.
///
/// For more details go to
/// [The \<key-octave\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/key-octave/).
class KeyOctave {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The octave value using the same values as the display-octave element
  ///
  /// Octaves are represented by the numbers 0 to 9,
  /// where 4 indicates the octave started by middle C.
  int value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// A positive integer that refers to the key signature element in left-to-right order.
  int number;

  /// If set to yes, then the number refers to the canceling key signature specified
  /// by the cancel element in the parent [key] element.
  ///
  /// It cannot be set to yes if there is no corresponding cancel element within the parent [key] element.
  /// It is no if absent.
  bool cancel;

  KeyOctave({
    required this.value,
    required this.number,
    this.cancel = false,
  });

  factory KeyOctave.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    String rawValue = xmlElement.innerText;
    int? value = int.tryParse(rawValue);
    if (value == null || value < 0 || value > 9) {
      throw MusicXmlFormatException(
        message: "provided value is not valid key octave value",
        xmlElement: xmlElement,
        source: rawValue,
      );
    }

    String? numberAttribute = xmlElement.getAttribute("number");
    if (numberAttribute == null) {
      throw MissingXmlAttribute(
        message: "'number' attribute is required for 'key-octave' element",
        xmlElement: xmlElement,
      );
    }
    int? number = int.tryParse(numberAttribute);
    if (number == null || number < 1) {
      throw MusicXmlFormatException(
        message: "provided value is not valid positive integer",
        xmlElement: xmlElement,
        source: numberAttribute,
      );
    }

    bool? cancel = YesNo.fromXml(xmlElement, 'cancel');

    return KeyOctave(
      value: value,
      number: number,
      cancel: cancel ?? false,
    );
  }
}
