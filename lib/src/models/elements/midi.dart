import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Corresponds to the DeviceName meta event in Standard MIDI Files.
/// Unlike the DeviceName meta event, there can be multiple [MidiDevice] per MusicXML part.
///
/// More information at [The \<midi-device\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-device/)
class MidiDevice {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// In musicXML, it is content of midi-device element.
  ///
  /// Type of [string](https://www.w3.org/TR/xmlschema-2/#string). By definition, it can be empty.
  final String name;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// A number from 1 to 16 that can be used with the unofficial MIDI 1.0 port (or cable) meta event.
  final int? port;

  /// Refers to the score instrument assigned to this device.
  ///
  /// If missing, the device assignment affects all score instrument elements in the score part.
  ///
  /// Type of [IDREF](https://www.w3.org/TR/xmlschema-2/#IDREF). Cannot be empty.
  final String? id;

  MidiDevice({
    required this.name,
    this.port,
    this.id,
  });

  factory MidiDevice.fromXml(XmlElement xmlElement) {
    String? portElement = xmlElement.getAttribute('port');
    int? maybePort = int.tryParse(xmlElement.getAttribute('port') ?? '');
    if (portElement != null &&
        (maybePort == null || !Midi.midi16.isValid(maybePort))) {
      String message = Midi.midi16.generateValidationError("port", portElement);
      throw MusicXmlFormatException(
        message: message,
        xmlElement: xmlElement,
        source: portElement,
      );
    }

    String? id = xmlElement.getAttribute('id');
    if (id?.isEmpty == true) {
      throw MusicXmlFormatException(
        message: "'id' attribute in 'midi-device' cannot be empty",
        xmlElement: xmlElement,
        source: id,
      );
    }

    String content = xmlElement.innerText;
    if (xmlElement.childElements.isNotEmpty) {
      throw InvalidElementContentException(
        message: "'midi-device' must have only one text child",
        xmlElement: xmlElement,
      );
    }
    return MidiDevice(
      name: content,
      port: maybePort,
      id: id,
    );
  }

  /// TODO: finish and test.
  XmlElement toXml() {
    throw UnimplementedError();
  }
}

/// Defines MIDI 1.0 instrument playback.
/// The [MidiInstrument] can be a part of either the score instrument element
/// at the start of a part, or the sound element within a part.
class MidiInstrument {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The midi-channel element specifies a MIDI 1.0 channel numbers ranging from 1 to 16.
  ///
  /// Type: midi-16.
  final int? midiChannel;

  /// The midi-name element corresponds to a ProgramName meta-event within a Standard MIDI File.
  final String? midiName;

  /// The midi-bank element specifies a MIDI 1.0 bank number ranging from 1 to 16,384.
  final int? midiBank;

  /// The midi-program element specifies a MIDI 1.0 program number ranging from 1 to 128.
  final int? midiProgram;

  /// For unpitched instruments, the midi-unpitched element specifies a MIDI 1.0 note number ranging from 1 to 128.
  ///
  /// It is usually used with MIDI banks for percussion.
  ///
  /// Note that MIDI 1.0 note numbers are generally specified from 0 to 127 rather than the 1 to 128 numbering used in this element.
  final int? midiUnpitched;

  /// The volume element value is a percentage of the maximum ranging from 0 to 100, with decimal values allowed.
  ///
  /// This corresponds to a scaling value for the MIDI 1.0 channel volume controller.
  final double? volume;

  /// The pan and elevation elements allow placing of sound in a 3-D space relative to the listener.
  ///
  /// Both are expressed in degrees ranging from -180 to 180.
  ///
  /// For pan, 0 is straight ahead, -90 is hard left, 90 is hard right, and -180 and 180 are directly behind the listener.
  final double? pan;

  /// The elevation and pan elements allow placing of sound in a 3-D space relative to the listener.
  ///
  /// Both are expressed in degrees ranging from -180 to 180.
  ///
  /// For elevation, 0 is level with the listener, 90 is directly above, and -90 is directly below.
  final double? elevation;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Refers to the score-instrument affected by the change
  final String id;

  MidiInstrument({
    this.midiChannel,
    this.midiName,
    this.midiBank,
    this.midiProgram,
    this.midiUnpitched,
    this.volume,
    this.pan,
    this.elevation,
    required this.id,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'midi-channel': XmlQuantifier.optional,
    'midi-name': XmlQuantifier.optional,
    'midi-bank': XmlQuantifier.optional,
    'midi-program': XmlQuantifier.optional,
    'midi-unpitched': XmlQuantifier.optional,
    'volume': XmlQuantifier.optional,
    'pan': XmlQuantifier.optional,
    'elevation': XmlQuantifier.optional,
  };

  static T? _parseMidiElements<T>({
    required XmlElement xmlElement,
    required String elementName,
    required T? Function(String) parser,
    required bool Function(T) isValid,
    required String typeName,
  }) {
    XmlElement? element = xmlElement.getElement(elementName);
    if (element?.childElements.isNotEmpty == true) {
      throw InvalidElementContentException(
        message: "'$elementName' content must be $typeName data type",
        xmlElement: xmlElement,
      );
    }
    String? rawValue = element?.innerText;
    T? value = parser(rawValue ?? "");
    if (rawValue != null && (value == null || !isValid(value))) {
      throw MusicXmlFormatException(
        message: "'$elementName' content must be $typeName",
        xmlElement: xmlElement,
        source: rawValue,
      );
    }
    return value;
  }

  factory MidiInstrument.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    // midi-channel
    int? midiChannel = _parseMidiElements<int>(
      xmlElement: xmlElement,
      elementName: 'midi-channel',
      isValid: Midi.midi16.isValid,
      parser: int.tryParse,
      typeName: 'midi-16',
    );

    // midi-name
    XmlElement? midiNameElement = xmlElement.getElement('midi-name');
    String? midiName = midiNameElement?.innerText;
    if (midiName?.isEmpty == true &&
        midiNameElement?.childElements.isNotEmpty == true) {
      throw InvalidElementContentException(
        message: "'midi-name' must have text content",
        xmlElement: xmlElement,
      );
    }

    // midi-bank
    int? midiBank = _parseMidiElements<int>(
      xmlElement: xmlElement,
      elementName: 'midi-bank',
      isValid: Midi.midi16384.isValid,
      parser: int.tryParse,
      typeName: 'midi-16384',
    );

    // midi-program
    int? midiProgram = _parseMidiElements<int>(
      xmlElement: xmlElement,
      elementName: 'midi-program',
      isValid: Midi.midi128.isValid,
      parser: int.tryParse,
      typeName: 'midi-128',
    );

    // midi-unpitched
    int? midiUnpitched = _parseMidiElements<int>(
      xmlElement: xmlElement,
      elementName: 'midi-unpitched',
      isValid: Midi.midi128.isValid,
      parser: int.tryParse,
      typeName: 'midi-128',
    );

    // volume
    double? volume = _parseMidiElements<double>(
      xmlElement: xmlElement,
      elementName: 'volume',
      isValid: Percent.isValid,
      parser: double.tryParse,
      typeName: 'percent',
    );

    // pan
    double? pan = _parseMidiElements<double>(
      xmlElement: xmlElement,
      elementName: 'pan',
      isValid: RotationDegrees.isValid,
      parser: double.tryParse,
      typeName: 'rotation-degrees',
    );

    // elevation
    double? elevation = _parseMidiElements<double>(
      xmlElement: xmlElement,
      elementName: 'elevation',
      isValid: RotationDegrees.isValid,
      parser: double.tryParse,
      typeName: 'rotation-degrees',
    );

    // ID
    String? id = xmlElement.getAttribute("id");

    if (id == null || id.isEmpty) {
      throw XmlAttributeRequired(
        message: "non-empty 'id' attribute required for 'midi-device' element",
        xmlElement: xmlElement,
      );
    }

    return MidiInstrument(
      midiChannel: midiChannel,
      midiName: midiName,
      midiBank: midiBank,
      midiProgram: midiProgram,
      midiUnpitched: midiUnpitched,
      volume: volume,
      pan: pan,
      elevation: elevation,
      id: id,
    );
  }

  /// TODO: finish and test.
  XmlElement toXml() {
    List<XmlNode> children = [];

    if (midiChannel != null) {
      children.add(
        XmlElement(
          XmlName('midi-channel'),
          [],
          [XmlText(midiChannel.toString())],
        ),
      );
    }

    if (midiName != null) {
      children.add(
        XmlElement(XmlName('midi-name'), [], [XmlText(midiName!)]),
      );
    }

    if (midiBank != null) {
      children.add(
        XmlElement(
          XmlName('midi-bank'),
          [],
          [XmlText(midiBank.toString())],
        ),
      );
    }

    if (midiProgram != null) {
      children.add(
        XmlElement(
          XmlName('midi-program'),
          [],
          [XmlText(midiProgram.toString())],
        ),
      );
    }

    if (midiUnpitched != null) {
      children.add(XmlElement(
        XmlName('midi-unpitched'),
        [],
        [XmlText(midiUnpitched.toString())],
      ));
    }

    if (volume != null) {
      children.add(
        XmlElement(
          XmlName('volume'),
          [],
          [XmlText(volume.toString())],
        ),
      );
    }

    if (pan != null) {
      children.add(
        XmlElement(XmlName('pan'), [], [XmlText(pan.toString())]),
      );
    }

    if (elevation != null) {
      children.add(
        XmlElement(
          XmlName('elevation'),
          [],
          [XmlText(elevation.toString())],
        ),
      );
    }

    return XmlElement(
      XmlName('midi-instrument'),
      [XmlAttribute(XmlName('id'), id)],
      children,
    );
  }
}

enum Midi {
  /// The midi-16 type is used to express MIDI 1.0 values that range from 1 to 16.
  midi16(1, 16),

  /// The midi-16384 type is used to express MIDI 1.0 values that range from 1 to 16,384.
  midi16384(1, 16384),

  /// The midi-128 type is used to express MIDI 1.0 values that range from 1 to 128.
  midi128(1, 128);

  const Midi(this.min, this.max);

  final int min;
  final int max;

  bool isValid(int value) {
    return value >= min && value <= max;
  }

  String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid $name value: $value";
}
