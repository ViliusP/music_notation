import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/utilities.dart';
import 'package:xml/xml.dart';

/// Beam values include begin, continue, end, forward hook, and backward hook.
///
/// Each beam in a note is represented with a separate <beam> element with a different number attribute, starting with the eighth note beam using a value of 1.
class Beam {
  /// Specifies an ID that is unique to the entire document.
  String? id;

  BeamValue value;

  /// Indicates the color of an element.
  Color color;

  /// Deprecated as of Version 3.0. Formerly used for tremolos,
  ///
  /// it needs to be specified with a "yes" value for each <beam> using it.
  bool repeater;

  /// Beams that have a begin value may also have a fan attribute to indicate accelerandos and ritardandos using fanned beams.
  ///
  /// The fan attribute may also be used with a continue value if the fanning direction changes on that note.
  ///
  /// The value is none if not specified.
  Fan fan;

  /// Indicates eighth note through 1024th note beams using number values 1 thru 8 respectively.
  ///
  /// The default value is 1.
  ///
  /// Note that this attribute does not distinguish sets of beams that overlap, as it does for <slur> and other elements.
  /// Beaming groups are distinguished by being in different voices, and/or the presence or absence of <grace> and <cue> elements.
  int number;

  Beam({
    this.id,
    required this.value,
    required this.color,
    this.repeater = false,
    this.fan = Fan.none,
    this.number = 1,
  });

  factory Beam.fromXml(XmlElement xmlElement) {
    BeamValue? beamValue = BeamValue.fromString(xmlElement.innerText);

    if (beamValue == null) {
      throw XmlElementRequired(
        "Valid beam value is required: ${xmlElement.innerText}",
      );
    }

    String? repeaterAttribute = xmlElement.getAttribute("repeater");
    bool? repeater = YesNo.toBool(repeaterAttribute ?? "");

    // Checking if provided "repeater" attribute is valid yes-no value.
    if (repeaterAttribute != null && repeater == null) {
      final String message = YesNo.generateValidationError(
        "repeater",
        repeaterAttribute,
      );
      throw InvalidXmlElementException(
        message: message,
        xmlElement: xmlElement,
      );
    }

    String? fanAttribute = xmlElement.getAttribute("fan");
    Fan? fan = Fan.fromString(fanAttribute ?? "");
    if (fanAttribute != null && fan == null) {
      final String message =
          "Bad fan attribute value was provided: $fanAttribute";
      throw InvalidXmlElementException(
        message: message,
        xmlElement: xmlElement,
      );
    }

    String? numberAttribute = xmlElement.getAttribute("number");
    int? number = BeamLevel.tryParse(numberAttribute ?? "");
    if (numberAttribute != null && number == null) {
      final String message =
          "Bad number attribute value was provided: $fanAttribute";
      throw InvalidXmlElementException(
        message: message,
        xmlElement: xmlElement,
      );
    }

    return Beam(
      value: beamValue,
      id: xmlElement.getAttribute("id"),
      color: Color.fromXml(xmlElement),
      repeater: repeater ?? false,
      fan: fan ?? Fan.none,
      number: number ?? 1,
    );
  }
}

/// The beam-value type represents the type of beam associated with each of 8 beam levels (up to 1024th notes) available for each note.
enum BeamValue {
  begin,

  /// Continue is reserved keyword, so it was change to [bContinue].
  bContinue,
  end,
  forwardHook,
  backwardHook;

  static const _map = {
    'begin': begin,
    'continue': bContinue,
    'diamond': end,
    'forward hook': forwardHook,
    'backward hook': backwardHook,
  };

  /// Converts provided string value to [BeamValue].
  ///
  /// Returns null if that name does not exists.
  static BeamValue? fromString(String value) {
    return _map[value];
  }

  @override
  String toString() => inverseMap(_map)[this];
}

/// The fan type represents the type of beam fanning present on a note, used to represent accelerandos and ritardandos.
enum Fan {
  accel,
  rit,
  none;

  /// Converts provided string value to [Fan].
  ///
  /// Returns null if that name does not exists.
  static Fan? fromString(String value) {
    return Fan.values.firstWhereOrNull(
      (element) => element.name == value,
    );
  }

  @override
  String toString() => name;
}
