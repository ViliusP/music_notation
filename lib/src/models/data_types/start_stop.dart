import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:xml/xml.dart';

/// An attribute of musical elements that can either start or stop, such as tuplets.
///
/// The values of start and stop refer to how an element appears in musical score order,
/// not in MusicXML document order. An element with a stop attribute may precede
/// the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music. For example, the stopping
/// point for a tuplet may appear in staff 1 before the starting point for
/// the tuplet appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
enum StartStop {
  /// Starting point of an element.
  start,

  /// Stopping point of an element.
  stop;

  static StartStop? fromString(String value) {
    return values.singleWhereOrNull((element) => element.name == value);
  }

  /// Extracts the StartStop from the given [xmlElement] if it exists and is valid.
  ///
  /// In musicXML, start-stop is always required 'type' attribute.
  ///
  /// If the [StartStop] attribute does not exist, it throws an [MissingXmlAttribute] exception.
  ///
  /// If it is not valid, it throws an [MusicXmlTypeException] exception.
  static StartStop fromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.getAttribute(CommonAttributes.type);

    if (rawValue == null) {
      throw MissingXmlAttribute(
        message: "${xmlElement.name} element must contain type attribute",
        xmlElement: xmlElement,
      );
    }

    StartStop? value = StartStop.fromString(rawValue);
    if (value == null) {
      throw MusicXmlTypeException(
        message: generateValidationError(rawValue),
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  /// Generates a validation error message for an invalid [StartStop] value.
  ///
  /// Parameters:
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the value is not a valid start-stop.
  static String generateValidationError(String value) =>
      "Type attribute is not a stop-start: $value";
}

/// An attribute of musical elements that can either start or stop, but also
/// need to refer to an intermediate point in the symbol, as for complex slurs
/// or for formatting of symbols across system breaks.
///
/// The values of start, stop, and continue refer to how an element appears in
/// musical score order, not in MusicXML document order. An element with a stop
/// attribute may precede the corresponding element with a start attribute
/// within a MusicXML document. This is particularly common in multi-staff music.
/// For example, the stopping point for a slur may appear in staff 1 before the
/// starting point for the slur appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
/// For example, a note that marks both the end of one slur and the start of a
/// new slur should have the incoming slur element with a type of stop precede
/// the outgoing slur element with a type of start.
///
/// For more details go to
/// [start-stop-continue data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/start-stop-continue/).
enum StartStopContinue {
  /// Starting point of an element.
  start,

  /// Stopping point of an element.
  stop,

  /// Continuation of an element, including system breaks.
  tContinue;

  /// Map representation of the enum.
  static const _map = {
    "start": start,
    "stop": stop,
    "tContinue": tContinue,
  };

  /// Converts a [String] to its corresponding [StartStopContinue] enum.
  ///
  /// If the [value] does not match any [StartStopContinue] values, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var startStopContinue = StartStopContinue.fromString("start");
  /// print(startStopContinue);  // Prints: StartStopContinue.start
  /// ```
  static StartStopContinue? fromString(String value) {
    return _map[value];
  }

  /// Parses an [XmlElement] to extract a [StartStopContinue] attribute.
  ///
  /// If the `type` attribute does not exist and [required] is `true`,
  /// throws a [MissingXmlAttribute] exception.
  ///
  /// If the `type` attribute exists but is not valid, throws a
  /// [MusicXmlTypeException] exception.
  ///
  /// If [required] is `false` and the `type` attribute does not exist,
  /// `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var xmlElement = XmlElement(XmlName("note"), [], [XmlText("start")]);
  /// var startStopContinue = StartStopContinue.fromXml(xmlElement);
  /// print(startStopContinue);  // Prints: StartStopContinue.start
  /// ```
  static StartStopContinue? fromXml(
    XmlElement xmlElement, [
    bool required = true,
  ]) {
    String? rawValue = xmlElement.getAttribute(CommonAttributes.type);

    if (rawValue == null && required) {
      throw MissingXmlAttribute(
        message: "${xmlElement.name} element must contain type attribute",
        xmlElement: xmlElement,
      );
    }
    if (rawValue == null && !required) {
      return null;
    }

    StartStopContinue? value = fromString(rawValue!);
    if (value == null) {
      throw MusicXmlTypeException(
        message: generateValidationError(rawValue),
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  /// Generates a validation error message for an invalid [StartStopContinue] value.
  ///
  /// Returns a validation error message indicating that the [value] is not a
  /// valid [StartStopContinue].
  static String generateValidationError(String value) =>
      "Type attribute is not a stop-start-continue: $value";
}

/// The start-stop-single type is used for an attribute of musical elements
/// that can be used for either multi-note or single-note musical elements, as for groupings.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
enum StartStopSingle {
  start,
  stop,
  single;
}

enum UpDownStopContinue {
  up,
  down,
  stop,
  tContinue;
}
