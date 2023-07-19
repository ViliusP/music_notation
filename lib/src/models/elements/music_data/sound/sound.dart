import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/sound/swing.dart';
import 'package:music_notation/src/models/elements/score/instruments.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/music_data/note/play.dart';
import 'package:music_notation/src/models/elements/music_data/offset.dart';
import 'package:music_notation/src/models/elements/midi.dart';

/// The sound element contains general playback parameters. They can stand alone
/// within a part/measure, or be a component element within a direction.
class Sound implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Instrument changes, MIDI devices, MIDI instruments, and playback techniques
  /// are changed using the instrument-change, midi-device, midi-instrument, and
  /// play elements. When there are multiple instances of these elements, they
  /// should be grouped together by instrument using the id attribute values.
  List<SoundSequence> soundSequence;

  Swing? swing;

  /// Indicates that the sound takes place offset from the current score position.
  /// If the sound element is a child of a direction element, the sound offset
  /// element overrides the direction offset element if both elements are present.
  /// Note that the offset reflects the intended musical position for the change
  /// in sound. It should not be used to compensate for latency issues in
  /// particular hardware configurations.
  Offset? offset;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Tempo is expressed in quarter notes per minute.
  ///
  /// If 0, the sound-generating program should prompt the user at the time of
  /// compiling a sound (MIDI) file.
  double? tempo;

  /// Dynamics (or MIDI velocity) are expressed as a percentage of the default
  /// forte value (90 for MIDI 1.0).
  double? dynamics;

  /// Indicates to go back to the beginning of the movement.
  /// When used it always has the value "yes".
  ///
  /// By default, a dacapo attribute indicates that the jump should occur the
  /// first time through. The times that jumps occur can be changed by using
  /// the time-only attribute.
  bool? dacapo;

  /// Indicates the end point for a backward jump to a segno sign.
  /// If there are multiple jumps,
  /// the value of these parameters can be used to name and distinguish them.
  String? segno;

  /// Indicates the starting point for a backward jump to a segno sign.
  /// If there are multiple jumps,
  /// the value of these parameters can be used to name and distinguish them.
  ///
  /// By default, a dalsegno attribute indicates that the jump should occur the
  /// first time through. The times that jumps occur can be changed by using
  /// the time-only attribute.
  String? dalsegno;

  /// Indicates the end point for a forward jump to a coda sign.
  /// If there are multiple jumps,
  /// the value of these parameters can be used to name and distinguish them.
  String? coda;

  /// Indicates the starting point for a forward jump to a coda sign.
  /// If there are multiple jumps,
  /// the value of these parameters can be used to name and distinguish them.
  ///
  /// By default, a tocoda attribute indicates the jump should occur the second time through.
  /// The times that jumps occur can be changed by using the time-only attribute.
  String? tocoda;

  /// If the segno or coda attributes are used,
  /// the divisions attribute can be used to indicate the number of divisions per quarter note.
  /// Otherwise sound and MIDI generating programs may have to recompute this.
  double? divisions;

  /// Indicates that a forward repeat sign is implied but not displayed.
  /// It is used for example in two-part forms with repeats,
  /// such as a minuet and trio where no repeat is displayed at the start of the trio.
  /// This usually occurs after a barline. When used it always has the value of "yes".
  bool? forwardRepeat;

  /// Follows the final note or rest in a movement with a da capo or dal segno direction.
  /// If numeric, the value represents the actual duration of the final note or rest,
  /// which can be ambiguous in written notation and different among parts and voices.
  /// The value may also be "yes" to indicate no change to the final duration.
  String? fine;

  /// Indicates which times to apply the sound element
  /// if the <sound> element applies only particular times through a repeat.
  String? timeOnly;

  /// Indicates which times to apply the sound element
  /// if the [Sound] element applies only particular times through a repeat.
  bool? pizzicato;

  /// Allows placing of sound in a 3-D space relative to the listener,
  /// expressed in degrees ranging from -180 to 180. 0 is straight ahead,
  /// -90 is hard left, 90 is hard right, and -180 and 180 are directly behind the listener.
  ///
  /// Deprecated as of Version 2.0.
  /// The [pan] element in the [MidiInstrument] element should be used instead.
  /// If both are present, the [pan] element takes priority.
  double? pan;

  /// Allows placing of sound in a 3-D space relative to the listener,
  /// expressed in degrees ranging from -180 to 180.
  /// 0 is level with the listener, 90 is directly above, and -90 is directly below.
  ///
  /// Deprecated as of Version 2.0.
  /// The [elevation] element in the <midi-instrument> element should be used instead.
  /// If both are present, the <elevation> element takes priority.
  double? elevation;

  /// Effects playback of the the common right piano pedal and its MIDI controller equivalent.
  /// The yes value indicates the pedal is depressed; no indicates the pedal is released.
  /// A numeric value from 0 to 100 may also be used for half pedaling.
  /// This value is the percentage that the pedal is depressed.
  /// A value of 0 is equivalent to no, and a value of 100 is equivalent to yes.
  YesNoNumber? damperPedal;

  /// Effects playback of the the common left piano pedal and its MIDI controller equivalent.
  /// The yes value indicates the pedal is depressed; no indicates the pedal is released.
  /// A numeric value from 0 to 100 may also be used for half pedaling.
  /// This value is the percentage that the pedal is depressed.
  /// A value of 0 is equivalent to no, and a value of 100 is equivalent to yes.
  YesNoNumber? softPedal;

  /// Effects playback of the the common center piano pedal and its MIDI controller equivalent.
  /// The yes value indicates the pedal is depressed; no indicates the pedal is released.
  /// A numeric value from 0 to 100 may also be used for half pedaling.
  /// This value is the percentage that the pedal is depressed.
  /// A value of 0 is equivalent to no, and a value of 100 is equivalent to yes.
  YesNoNumber? sostenutoPedal;

  String? id;

  Sound({
    this.swing,
    this.offset,
    this.tempo,
    this.dynamics,
    this.dacapo,
    this.segno,
    this.dalsegno,
    this.coda,
    this.tocoda,
    this.divisions,
    this.forwardRepeat,
    this.fine,
    this.timeOnly,
    this.pizzicato,
    this.pan,
    this.elevation,
    this.damperPedal,
    this.softPedal,
    this.sostenutoPedal,
    this.id,
    required this.soundSequence,
  });

  /// Creates an instance of the [Sound] class from an [XmlElement].
  ///
  /// This method extracts various attributes from the [XmlElement] parameter,
  /// such as 'swing', 'offset', 'coda', 'dacapo', etc., to create a [Sound] object.
  /// For any attribute that is not present in the [XmlElement], the corresponding field
  /// in the [Sound] object will be set to `null` or an empty list (in case of 'soundSequence').
  ///
  /// It currently does not handle certain attributes like 'damperPedal',
  /// 'softPedal', 'sostenutoPedal' as these are set to `null`.
  ///
  /// Example usage:
  /// ```
  /// var xmlElement = XmlDocument.parse("<sound dynamics="98"/>").root;
  /// var sound = Sound.fromXml(xmlElement);
  /// ```
  static Sound fromXml(XmlElement xmlElement) {
    var swingElement = xmlElement.getElement("swing");
    var offsetElement = xmlElement.getElement("offset");

    var dynamics = Decimal.fromXml(xmlElement, 'dynamics', false);
    if (dynamics != null && dynamics < 0) {
      throw MusicXmlFormatException(
        message: "'dynamics' attribute in sound element must be non negaitve",
        xmlElement: xmlElement,
        source: xmlElement.getAttribute("dynamics"),
      );
    }

    var tempo = Decimal.fromXml(xmlElement, 'tempo', false);
    if (tempo != null && tempo < 0) {
      throw MusicXmlFormatException(
        message: "'tempo' attribute in sound element must be non negaitve",
        xmlElement: xmlElement,
        source: xmlElement.getAttribute("tempo"),
      );
    }

    return Sound(
      soundSequence: [],
      swing: swingElement != null ? Swing.fromXml(swingElement) : null,
      offset: offsetElement != null ? Offset.fromXml(offsetElement) : null,
      coda: xmlElement.getAttribute("coda"),
      dacapo: YesNo.fromXml(xmlElement, "dacapo"),
      dalsegno: xmlElement.getAttribute("dalsegno"),
      damperPedal: null,
      divisions: Decimal.fromXml(xmlElement, 'divisions', false),
      dynamics: dynamics,
      elevation: RotationDegrees.fromXml(xmlElement, 'elevation'),
      fine: xmlElement.getAttribute("fine"),
      forwardRepeat: YesNo.fromXml(xmlElement, "forward-repeat"),
      id: xmlElement.getAttribute("id"),
      pan: RotationDegrees.fromXml(xmlElement, 'pan'),
      pizzicato: YesNo.fromXml(xmlElement, "pizzicato"),
      segno: xmlElement.getAttribute("segno"),
      softPedal: null,
      sostenutoPedal: null,
      tempo: tempo,
      timeOnly: TimeOnly.fromXml(xmlElement),
      tocoda: xmlElement.getAttribute("tocoda"),
    );
  }

  @override
  XmlElement toXml() {
    // TODO: implement toXml
    throw UnimplementedError();
  }
}

/// An abstract class representing a yes-no-number type in MusicXML.
///
/// This type can be either a [bool] or a [num].
abstract class YesNoNumber {
  final Object value;

  YesNoNumber(this.value);

  /// Factory constructor to create an instance of YesNoNumber from an XML element.
  /// It checks the text of the XML element and creates a YesNoNumberBool or YesNoNumberNum instance accordingly.
  factory YesNoNumber.fromXml(XmlElement xmlElement) {
    String? elementText = xmlElement.value;

    if (elementText == null || elementText.isEmpty) {
      throw XmlElementContentException(
        message: "message",
        xmlElement: xmlElement,
      ); // TODO
    }

    // Check if the text can be parsed to a number.
    num? numericValue = num.tryParse(elementText);
    if (numericValue != null) {
      return YesNoNumberNum(numericValue);
    }
    // If it's not a number, we assume it's a boolean (yes/no).
    bool? boolValue = YesNo.toBool(elementText);

    if (boolValue == null) {
      throw XmlElementContentException(
        message: "message",
        xmlElement: xmlElement,
      ); // TODO
    }
    return YesNoNumberBool(boolValue);
  }
}

/// A subclass of [YesNoNumber] for holding boolean values.
class YesNoNumberBool extends YesNoNumber {
  YesNoNumberBool(bool value) : super(value);
}

/// A subclass of [YesNoNumber] for holding numeric values.
class YesNoNumberNum extends YesNoNumber {
  YesNoNumberNum(num value) : super(value);
}

class SoundSequence {
  final InstrumentChange? instrumentChange;
  final MidiDevice? midiDevice;
  final MidiInstrument? midiInstrument;
  final Play? play;

  SoundSequence({
    this.instrumentChange,
    this.midiDevice,
    this.midiInstrument,
    this.play,
  });
}
