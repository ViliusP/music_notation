import 'package:music_notation/src/models/exceptions.dart';
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

/// The midi-instrument type defines MIDI 1.0 instrument playback.
///
/// The midi-instrument element can be a part of either the score-instrument element at the start of a part, or the sound element within a part.
///
/// The id attribute refers to the score-instrument affected by the change.
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

  factory MidiInstrument.fromXml(XmlElement xmlElement) {
    String? midiChannelElement = xmlElement.getAttribute('port');

    int? maybeMidiChannel = int.tryParse(xmlElement.getAttribute('port') ?? '');

    if (midiChannelElement != null &&
        (maybeMidiChannel == null || !Midi.midi16.isValid(maybeMidiChannel))) {
      String message = Midi.midi16.generateValidationError(
        "port",
        midiChannelElement,
      );
      throw InvalidXmlElementException(
        message: message,
        xmlElement: xmlElement,
      );
    }

    /// TODO: more validation

    return MidiInstrument(
      midiChannel:
          int.tryParse(xmlElement.getElement('midi-channel')?.text ?? ''),
      midiName: xmlElement.getElement('midi-name')?.text,
      midiBank: int.tryParse(xmlElement.getElement('midi-bank')?.text ?? ''),
      midiProgram:
          int.tryParse(xmlElement.getElement('midi-program')?.text ?? ''),
      midiUnpitched:
          int.tryParse(xmlElement.getElement('midi-unpitched')?.text ?? ''),
      volume: double.tryParse(xmlElement.getElement('volume')?.text ?? ''),
      pan: double.tryParse(xmlElement.getElement('pan')?.text ?? ''),
      elevation:
          double.tryParse(xmlElement.getElement('elevation')?.text ?? ''),
      id: xmlElement.getAttribute('id')!,
    );
  }

  XmlElement toXml() {
    List<XmlNode> children = [];

    if (midiChannel != null) {
      children.add(XmlElement(
          XmlName('midi-channel'), [], [XmlText(midiChannel.toString())]));
    }

    if (midiName != null) {
      children.add(XmlElement(XmlName('midi-name'), [], [XmlText(midiName!)]));
    }

    if (midiBank != null) {
      children.add(
          XmlElement(XmlName('midi-bank'), [], [XmlText(midiBank.toString())]));
    }

    if (midiProgram != null) {
      children.add(XmlElement(
          XmlName('midi-program'), [], [XmlText(midiProgram.toString())]));
    }

    if (midiUnpitched != null) {
      children.add(XmlElement(
          XmlName('midi-unpitched'), [], [XmlText(midiUnpitched.toString())]));
    }

    if (volume != null) {
      children
          .add(XmlElement(XmlName('volume'), [], [XmlText(volume.toString())]));
    }

    if (pan != null) {
      children.add(XmlElement(XmlName('pan'), [], [XmlText(pan.toString())]));
    }

    if (elevation != null) {
      children.add(XmlElement(
          XmlName('elevation'), [], [XmlText(elevation.toString())]));
    }

    return XmlElement(XmlName('midi-instrument'),
        [XmlAttribute(XmlName('id'), id)], children);
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
    // ArgumentError('Value must start with acc, medRenFla, medRenNatura, medRenShar, or kievanAccidental');
    return value >= min && value <= max;
  }

  String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid $name value: $value";
}
