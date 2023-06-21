import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Corresponds to the DeviceName meta event in Standard MIDI Files.
/// Unlike the DeviceName meta event, there can be multiple [MidiDevice] per MusicXML part.
///
/// More information at [The \<midi-device\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/midi-device/)
class MidiDevice {
  final String name;

  /// A number from 1 to 16 that can be used with the unofficial MIDI 1.0 port (or cable) meta event.
  final int? port;

  /// Refers to the score instrument assigned to this device.
  ///
  /// If missing, the device assignment affects all score instrument elements in the score part.
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
      throw InvalidMusicXmlType(
        message: message,
        xmlElement: xmlElement,
      );
    }

    String? id = xmlElement.getAttribute('id');

    if (id?.isEmpty == true) {
      throw InvalidMusicXmlType(
        message: "'id' attribute in 'midi-device' cannot be empty",
        xmlElement: xmlElement,
      );
    }
    String? content = xmlElement.firstChild?.value;

    if (xmlElement.children.length != 1 || content == null) {
      throw InvalidXmlElementException(
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

  factory MidiInstrument.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? midiChannelElement = xmlElement.getElement('midi-channel');
    int? midiChannel = int.tryParse(
      midiChannelElement?.firstChild?.value ?? '',
    );
    if (midiChannelElement != null &&
        (midiChannel == null || !Midi.midi16.isValid(midiChannel))) {
      throw InvalidMusicXmlType(
        message: "'midi-channel' content must be midi-16 data type",
        xmlElement: xmlElement,
      );
    }

    XmlElement? midiNameElement = xmlElement.getElement('midi-name');
    String? midiName = midiNameElement?.firstChild?.value;
    if (midiNameElement != null && (midiName == null || midiName.isEmpty)) {
      throw InvalidXmlElementException(
        message: "'midi-name' must have non empty text content",
        xmlElement: xmlElement,
      );
    }

    XmlElement? midiBankElement = xmlElement.getElement('midi-bank');
    int? midiBank = int.tryParse(
      midiBankElement?.firstChild?.value ?? '',
    );
    if (midiBankElement != null &&
        (midiBank == null || !Midi.midi16384.isValid(midiBank))) {
      throw InvalidMusicXmlType(
        message: "'midi-bank' content must be midi-16384",
        xmlElement: xmlElement,
      );
    }

    XmlElement? midiProgramElement = xmlElement.getElement('midi-program');
    int? midiProgram = int.tryParse(
      midiProgramElement?.firstChild?.value ?? '',
    );
    if (midiProgramElement != null &&
        (midiProgram == null || !Midi.midi128.isValid(midiProgram))) {
      throw InvalidMusicXmlType(
        message: "'midi-program' content must be midi-128",
        xmlElement: xmlElement,
      );
    }

    XmlElement? midiUnpitchedElement = xmlElement.getElement('midi-unpitched');
    int? midiUnpitched = int.tryParse(
      midiUnpitchedElement?.firstChild?.value ?? '',
    );
    if (midiUnpitchedElement != null &&
        (midiUnpitched == null || !Midi.midi128.isValid(midiUnpitched))) {
      throw InvalidMusicXmlType(
        message: "'midi-unpitched' content must be midi-128",
        xmlElement: xmlElement,
      );
    }

    XmlElement? volumeElement = xmlElement.getElement('volume');
    double? volume = double.tryParse(
      volumeElement?.firstChild?.value ?? '',
    );
    if (volumeElement != null && (volume == null || !Percent.isValid(volume))) {
      throw InvalidMusicXmlType(
        message: "'volume' content must be percent (double between 1 and 100)",
        xmlElement: xmlElement,
      );
    }

    XmlElement? panElement = xmlElement.getElement('pan');
    double? pan = double.tryParse(
      panElement?.firstChild?.value ?? '',
    );
    if (panElement != null && (pan == null || !RotationDegrees.isValid(pan))) {
      throw InvalidMusicXmlType(
        message: "'pan' content must be rotation-degrees",
        xmlElement: xmlElement,
      );
    }

    XmlElement? elevationElement = xmlElement.getElement('elevation');
    double? elevation = double.tryParse(
      elevationElement?.firstChild?.value ?? '',
    );
    if (elevationElement != null &&
        (elevation == null || !RotationDegrees.isValid(elevation))) {
      throw InvalidMusicXmlType(
        message: "'elevation' content must be rotation-degrees",
        xmlElement: xmlElement,
      );
    }

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
