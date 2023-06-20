import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// The score-instrument type represents a single instrument within a score-part.
///
/// As with the score-part type, each score-instrument has a required ID attribute, a name, and an optional abbreviation.
///
/// A score-instrument type is also required if the score specifies MIDI 1.0 channels, banks, or programs.
/// An initial midi-instrument assignment can also be made here.
/// MusicXML software should be able to automatically assign reasonable channels
/// and instruments without these elements in simple cases, such as where part names match General MIDI instrument names.
///
/// The score-instrument element can also distinguish multiple instruments of the same type that are on the same part,
/// such as Clarinet 1 and Clarinet 2 instruments within a Clarinets 1 and 2 part.
class ScoreInstrument {
  final String id;

  /// The instrument-name element is typically used within a software application,
  /// rather than appearing on the printed page of a score.
  final String instrumentName;
  final String? instrumentAbbreviation;

  /// The optional instrument-abbreviation element is typically used within a software application,
  /// rather than appearing on the printed page of a score.
  final VirtualInstrumentData? virtualInstrumentData;

  ScoreInstrument({
    required this.id,
    required this.instrumentName,
    this.instrumentAbbreviation,
    this.virtualInstrumentData,
  });

  factory ScoreInstrument.fromXml(XmlElement xmlElement) {
    String instrumentName =
        xmlElement.findElements('instrument-name').single.text;
    String? instrumentAbbreviation;
    var abbreviationElement =
        xmlElement.findElements('instrument-abbreviation').single;
    instrumentAbbreviation = abbreviationElement.text;
    VirtualInstrumentData? virtualInstrumentData;
    var virtualInstrumentDataElement =
        xmlElement.findElements('virtual-instrument-data').single;
    virtualInstrumentData =
        VirtualInstrumentData.fromXml(virtualInstrumentDataElement);
    String id = xmlElement.getAttribute('id') ?? '';
    return ScoreInstrument(
      instrumentName: instrumentName,
      instrumentAbbreviation: instrumentAbbreviation,
      virtualInstrumentData: virtualInstrumentData,
      id: id,
    );
  }

  XmlNode toXml() {
    final builder = XmlBuilder();
    builder.element('score-instrument', attributes: {'id': id}, nest: () {
      builder.element('instrument-name', nest: instrumentName);
      if (instrumentAbbreviation != null) {
        builder.element('instrument-abbreviation',
            nest: instrumentAbbreviation);
      }
      if (virtualInstrumentData != null) {
        // TODO; implement virtualInstrumentData.toXml()
        // builder.element(
        //   'virtual-instrument-data',
        //   nest: virtualInstrumentData.toXml(),
        // );
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// Virtual instrument data can be part of either the score-instrument element at the start of a part,
/// or an instrument-change element within a part.
class VirtualInstrumentData {
  /// The instrument-sound element describes the default timbre of the score-instrument.
  ///
  /// This description is independent of a particular virtual or MIDI instrument specification
  /// and allows playback to be shared more easily between applications and libraries.
  final String? instrumentSound;
  final PerformanceType? performanceType;
  // Assuming VirtualInstrument is defined elsewhere
  final VirtualInstrument? virtualInstrument;

  VirtualInstrumentData({
    this.instrumentSound,
    this.performanceType,
    this.virtualInstrument,
  });

  factory VirtualInstrumentData.fromXml(XmlElement xmlElement) {
    String? instrumentSound;
    PerformanceType? performanceType;
    VirtualInstrument? virtualInstrument;

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'instrument-sound':
          instrumentSound = child.text;
          break;
        case 'solo':
          performanceType = Solo.fromXml(child);
          break;
        case 'ensemble':
          performanceType = Ensemble.fromXml(child);
          break;
        case 'virtual-instrument':
          virtualInstrument = VirtualInstrument.fromXml(child);
          break;
      }
    }

    return VirtualInstrumentData(
      instrumentSound: instrumentSound,
      performanceType: performanceType,
      virtualInstrument: virtualInstrument,
    );
  }
}

abstract class PerformanceType {}

/// The solo element is present if performance is intended by a solo instrument.
class Solo extends PerformanceType {
  static Solo fromXml(XmlElement xmlElement) {
    return Solo();
  }
}

/// The ensemble element is present if performance is intended by an ensemble such as an orchestral section.
///
/// The text of the ensemble element contains the size of the section, or is empty if the ensemble size is not specified.
class Ensemble extends PerformanceType {
  final int? size;

  Ensemble({this.size});

  static Ensemble fromXml(XmlElement xmlElement) {
    /// Positive integer or empty.
    int? size;
    var sizeStr = xmlElement.text;
    if (sizeStr.isNotEmpty) {
      size = int.tryParse(sizeStr);
    }
    return Ensemble(size: size);
  }
}

/// The virtual-instrument element defines a specific virtual instrument used for an instrument sound.
class VirtualInstrument {
  // The virtual-library element indicates the virtual instrument library name.
  final String? virtualLibrary;

  /// The virtual-name element indicates the library-specific name for the virtual instrument.
  final String? virtualName;

  VirtualInstrument({
    this.virtualLibrary,
    this.virtualName,
  });

  factory VirtualInstrument.fromXml(XmlElement xmlElement) {
    String? virtualLibrary;
    String? virtualName;

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'virtual-library':
          virtualLibrary = child.text;
          break;
        case 'virtual-name':
          virtualName = child.text;
          break;
      }
    }

    return VirtualInstrument(
      virtualLibrary: virtualLibrary,
      virtualName: virtualName,
    );
  }
}

/// The [InstrumentChange] represents a change to the virtual instrument sound for a given [ScoreInstrument].
///
/// The [id] attribute refers to the [ScoreInstrument] affected by the change.
///
/// All [InstrumentChange] child elements can also be initially specified within the [ScoreInstrument] element.
class InstrumentChange extends VirtualInstrumentData {
  /// Refers to the score instrument affected by the change.
  String id;

  InstrumentChange({
    required this.id,
    super.instrumentSound,
    super.performanceType,
    super.virtualInstrument,
  });

  factory InstrumentChange.fromXml(XmlElement xmlElement) {
    final VirtualInstrumentData instrument = VirtualInstrumentData.fromXml(
      xmlElement,
    );

    /// TODO: Check id if.

    return InstrumentChange(
      id: "id",
      instrumentSound: instrument.instrumentSound,
      performanceType: instrument.performanceType,
      virtualInstrument: instrument.virtualInstrument,
    );
  }
}
