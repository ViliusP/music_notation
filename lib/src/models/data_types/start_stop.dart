import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// The start-stop type is used for an attribute of musical elements that can either start or stop, such as tuplets.
///
/// The values of start and stop refer to how an element appears in musical score order, not in MusicXML document order.
/// An element with a stop attribute may precede the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music.
/// For example, the stopping point for a tuplet may appear in staff 1 before the starting point for the tuplet appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note, their order within the MusicXML document should match the musical score order.
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
  /// In musicXML, start_stop is attribute and always required.
  ///
  /// If the [StartStop] attribute does not exist,
  /// it throws an [MissingXmlAttribute] exception.
  ///
  /// If it is not valid, it throws an [] exception.
  static StartStop fromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.getAttribute("type");

    if (rawValue == null) {
      throw MissingXmlAttribute(
        message: "${xmlElement.name} element must contain type attribute",
        xmlElement: xmlElement,
      );
    }

    StartStop? value = StartStop.fromString(rawValue);
    if (value == null) {
      throw MusicXmlFormatException(
        message: generateValidationError(rawValue),
        xmlElement: xmlElement,
        source: rawValue,
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

/// The start-stop-continue type is used for an attribute of musical elements that can either start or stop,
/// but also need to refer to an intermediate point in the symbol,
/// as for complex slurs or for formatting of symbols across system breaks.
///
/// The values of start, stop, and continue refer to how an element appears in musical score order,
/// not in MusicXML document order.
/// An element with a stop attribute may precede the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music.
/// For example, the stopping point for a slur may appear in staff 1 before the starting point for the slur appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
/// For example, a note that marks both the end of one slur and the start of a new slur
/// should have the incoming slur element with a type of stop precede the outgoing slur element with a type of start.
enum StartStopContinue {
  /// Starting point of an element.
  start,

  /// Stopping point of an element.
  stop,

  /// Continuation of an element, including system breaks.
  ///
  /// "continue".
  tContinue;
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
