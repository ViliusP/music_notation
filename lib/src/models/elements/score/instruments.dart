import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// The score-instrument type represents a single instrument within a score-part.
///
/// As with the score-part type, each score-instrument has a required ID attribute, a name, and an optional abbreviation.
///
/// A score-instrument type is also required if the score specifies MIDI 1.0 channels, banks, or programs.
/// An initial midi-instrument assignment can also be made here.
/// MusicXML software should be able to automatically assign reasonable channels
/// and instruments without these elements in simple cases,
/// such as where part names match General MIDI instrument names.
///
/// The [ScoreInstrument] element can also distinguish
/// multiple instruments of the same type that are on the same part,
/// such as Clarinet 1 and Clarinet 2 instruments within a Clarinets 1 and 2 part.
///
/// More information at [The \<score-instrument\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-instrument/).

class ScoreInstrument {
  /// An identifier for this. The [id] is unique to this document.
  final String id;

  /// The [instrumentName] is typically used within a software application,
  /// rather than appearing on the printed page of a score.
  final String instrumentName;

  /// The optional [instrumentAbbreviation] is typically used within a software application,
  /// rather than appearing on the printed page of a score.
  final String? instrumentAbbreviation;

  final VirtualInstrumentData virtualInstrumentData;

  ScoreInstrument({
    required this.id,
    required this.instrumentName,
    this.instrumentAbbreviation,
    required this.virtualInstrumentData,
  });

  // Field(s): quantifier
  static final Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'instrument-name': XmlQuantifier.required,
    'instrument-abbreviation': XmlQuantifier.optional,
  }..addAll(VirtualInstrumentData._xmlExpectedOrder);

  factory ScoreInstrument.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    String? id = xmlElement.getAttribute('id');

    if (id == null) {
      throw MissingXmlAttribute(
        message: "'id' attribute is required in 'score-instrument'",
        xmlElement: xmlElement,
      );
    }

    String? instrumentName =
        xmlElement.getElement('instrument-name')?.firstChild?.value;

    if (instrumentName == null) {
      throw XmlElementContentException(
        message: "'instrument-name' must have text content",
        xmlElement: xmlElement,
      );
    }

    XmlElement? instrumentAbbreviationElement =
        xmlElement.getElement('instrument-abbreviation');

    String? instrumentAbbreviation = instrumentAbbreviationElement?.value;

    if (instrumentAbbreviationElement != null &&
        instrumentAbbreviation == null) {
      throw XmlElementContentException(
        message: "'instrument-abbreviation' must should have text content",
        xmlElement: xmlElement,
      );
    }

    return ScoreInstrument(
      id: id,
      instrumentName: instrumentName,
      instrumentAbbreviation: instrumentAbbreviation,
      virtualInstrumentData: VirtualInstrumentData.fromXml(xmlElement),
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
      // if (virtualInstrumentData != null) {
      // TODO; implement virtualInstrumentData.toXml()
      // builder.element(
      //   'virtual-instrument-data',
      //   nest: virtualInstrumentData.toXml(),
      // );
      // }
    });
    return builder.buildDocument().rootElement;
  }
}

/// [VirtualInstrumentData] can be part of either the [ScoreInstrument] element at the start of a part,
/// or an [InstrumentChange] element within a part.
class VirtualInstrumentData {
  /// The [instrumentSound] element describes the default timbre of the [ScoreInstrument].
  ///
  /// This description is independent of a particular virtual or MIDI instrument specification
  /// and allows playback to be shared more easily between applications and libraries.
  final String? instrumentSound;

  /// Defines if performance is intended by [Solo] instrument or [Ensemble].
  final PerformanceType? performanceType;

  /// Defines a specific virtual instrument used for an [instrumentSound].
  final VirtualInstrument? virtualInstrument;

  VirtualInstrumentData({
    this.instrumentSound,
    this.performanceType,
    this.virtualInstrument,
  });

  /// This isn't used directly in this class.
  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'instrument-sound': XmlQuantifier.optional,
    'solo|ensemble': XmlQuantifier.optional,
    'virtual-instrument': XmlQuantifier.optional,
  };

  factory VirtualInstrumentData.fromXml(XmlElement xmlElement) {
    String? instrumentSound;
    PerformanceType? performanceType;
    VirtualInstrument? virtualInstrument;

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'instrument-sound':
          instrumentSound = child.firstChild?.value;
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

sealed class PerformanceType {}

/// The solo element is present if performance is intended by a solo instrument.
class Solo extends PerformanceType {
  static Solo fromXml(XmlElement xmlElement) {
    return Solo();
  }
}

/// The [Ensemble] is present if performance is intended by an ensemble such as an orchestral section.
///
/// The text of the ensemble element contains the size of the section,
/// or is empty if the ensemble size is not specified.
class Ensemble extends PerformanceType {
  final int? size;

  Ensemble({this.size});

  static Ensemble fromXml(XmlElement xmlElement) {
    /// Positive integer or empty.
    int? size;
    var rawSize = xmlElement.innerText;
    if (rawSize.isNotEmpty) {
      size = int.tryParse(rawSize);
    }
    if (rawSize.isNotEmpty && (size ?? 0) < 1) {
      throw XmlElementContentException(
        message: "Ensemble content must be positive number or empty",
        xmlElement: xmlElement,
      );
    }
    return Ensemble(size: size);
  }
}

/// Defines a specific virtual instrument used for an instrument sound.
class VirtualInstrument {
  /// Indicates the virtual instrument library name.
  final String? virtualLibrary;

  /// Indicates the library-specific name for the virtual instrument.
  final String? virtualName;

  VirtualInstrument({
    this.virtualLibrary,
    this.virtualName,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'virtual-library': XmlQuantifier.optional,
    'virtual-name': XmlQuantifier.optional,
  };

  factory VirtualInstrument.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    String? virtualLibrary;
    String? virtualName;

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'virtual-library':
          virtualLibrary = child.firstChild?.value;
          if (virtualLibrary == null) {
            throw XmlElementContentException(
              message: "'virtual-library' must have text in it's content",
              xmlElement: xmlElement,
            );
          }
          break;
        case 'virtual-name':
          virtualName = child.firstChild?.value;
          if (virtualName == null) {
            throw XmlElementContentException(
              message: "'virtual-name' must have text in it's content",
              xmlElement: xmlElement,
            );
          }
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
