// 	<xs:complexType name="note">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:choice>
// 				<xs:sequence>
// 					<xs:element name="grace" type="grace"/>
// 					<xs:choice>
// 						<xs:sequence>
// 							<xs:group ref="full-note"/>
// 							<xs:element name="tie" type="tie" minOccurs="0" maxOccurs="2"/>
// 						</xs:sequence>
// 						<xs:sequence>
// 							<xs:element name="cue" type="empty"/>
// 							<xs:group ref="full-note"/>
// 						</xs:sequence>
// 					</xs:choice>
// 				</xs:sequence>
// 				<xs:sequence>
// 					<xs:element name="cue" type="empty">
// 						<xs:annotation>
// 							<xs:documentation>The cue element indicates the presence of a cue note. In MusicXML, a cue note is a silent note with no playback. Normal notes that play can be specified as cue size using the type element. A cue note that is specified as full size using the type element will still remain silent.</xs:documentation>
// 						</xs:annotation>
// 					</xs:element>
// 					<xs:group ref="full-note"/>
// 					<xs:group ref="duration"/>
// 				</xs:sequence>
// 				<xs:sequence>
// 					<xs:group ref="full-note"/>
// 					<xs:group ref="duration"/>
// 					<xs:element name="tie" type="tie" minOccurs="0" maxOccurs="2"/>
// 				</xs:sequence>
// 			</xs:choice>
// 			<xs:element name="instrument" type="instrument" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:group ref="editorial-voice"/>
// 			<xs:element name="type" type="note-type" minOccurs="0"/>
// 			<xs:element name="dot" type="empty-placement" minOccurs="0" maxOccurs="unbounded">
// 				<xs:annotation>
// 					<xs:documentation>One dot element is used for each dot of prolongation. The placement attribute is used to specify whether the dot should appear above or below the staff line. It is ignored for notes that appear on a staff space.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="accidental" type="accidental" minOccurs="0"/>
// 			<xs:element name="time-modification" type="time-modification" minOccurs="0"/>
// 			<xs:element name="stem" type="stem" minOccurs="0"/>
// 			<xs:element name="notehead" type="notehead" minOccurs="0"/>
// 			<xs:element name="notehead-text" type="notehead-text" minOccurs="0"/>
// 			<xs:group ref="staff" minOccurs="0"/>
// 			<xs:element name="beam" type="beam" minOccurs="0" maxOccurs="8"/>
// 			<xs:element name="notations" type="notations" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:element name="lyric" type="lyric" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:element name="play" type="play" minOccurs="0"/>
// 			<xs:element name="listen" type="listen" minOccurs="0"/>
// 		</xs:sequence>
// 		<xs:attributeGroup ref="x-position"/>
// 		<xs:attributeGroup ref="font"/>
// 		<xs:attributeGroup ref="color"/>
// 		<xs:attributeGroup ref="printout"/>
// 		<xs:attribute name="print-leger" type="yes-no"/>
// 		<xs:attribute name="dynamics" type="non-negative-decimal"/>
// 		<xs:attribute name="end-dynamics" type="non-negative-decimal"/>
// 		<xs:attribute name="attack" type="divisions"/>
// 		<xs:attribute name="release" type="divisions"/>
// 		<xs:attribute name="time-only" type="time-only"/>
// 		<xs:attribute name="pizzicato" type="yes-no"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>

import 'package:collection/collection.dart';
import 'package:music_notation/models/elements/notations/notation.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/editioral.dart';
import 'package:music_notation/models/generic.dart';
import 'package:music_notation/models/invalid_xml_element_exception.dart';
import 'package:music_notation/models/music_data.dart';
import 'package:music_notation/models/part_list.dart';
import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/text.dart';
import 'package:music_notation/models/utilities.dart';

/// Notes are the most common type of MusicXML data.
///
/// The MusicXML format distinguishes between elements used for sound information and elements used for notation information (e.g., tie is used for sound, tied for notation).
/// Thus grace notes do not have a duration element.
///
/// Cue notes have a duration element, as do forward elements, but no tie elements.
/// Having these two types of information available can make interchange easier, as some programs handle one type of information more readily than the other.
///
/// The print-leger attribute is used to indicate whether leger lines are printed. Notes without leger lines are used to indicate indeterminate high and low notes.
/// By default, it is set to yes.
/// If print-object is set to no, print-leger is interpreted to also be set to no if not present.
/// This attribute is ignored for rests.
///
/// The dynamics and end-dynamics attributes correspond to MIDI 1.0's Note On and Note Off velocities, respectively.
/// They are expressed in terms of percentages of the default forte value (90 for MIDI 1.0).
///
/// The attack and release attributes are used to alter the starting and stopping time of the note from
/// when it would otherwise occur based on the flow of durations - information that is specific to a performance.
/// They are expressed in terms of divisions, either positive or negative.
/// A note that starts a tie should not have a release attribute,
/// and a note that stops a tie should not have an attack attribute.
/// The attack and release attributes are independent of each other.
/// The attack attribute only changes the starting time of a note,
/// and the release attribute only changes the stopping time of a note.
///
/// If a note is played only particular times through a repeat, the time-only attribute shows which times to play the note.
///
/// The pizzicato attribute is used when just this note is sounded pizzicato, vs. the pizzicato element which changes overall playback between pizzicato and arco.
class Note extends MusicDataElement {
  final Grace? grace;
  final EditorialVoice editorialVoice;

  // final FullNote? fullNote;
  // final Cue? cue;
  // final List<Instrument>? instruments;
  final NoteType? type;

  /// One dot element is used for each dot of prolongation.
  ///
  /// The placement attribute is used to specify whether the dot should appear above or below the staff line.
  ///
  /// It is ignored for notes that appear on a staff space.
  final List<EmptyPlacement>? dots;
  final Accidental? accidental;
  final TimeModification? timeModification;
  final Stem? stem;
  final Notehead? notehead;
  final NoteheadText? noteheadText;

  /// Staff assignment is only needed for music notated on multiple staves.
  ///
  /// Used by both notes and directions. Staff values are numbers, with 1 referring to the top-most staff in a part.
  ///
  /// Positive integer
  final int? staff;

  final List<Beam>? beams;
  final List<Notations>? notations;
  // final List<Lyric>? lyrics;
  // final Play? play;
  // final Listen? listen;
  // final XPosition? xPosition;
  // final Font? font;
  // final Color? color;
  // final Printout? printout;
  // final bool? printLeger;
  // final double? dynamics;
  // final double? endDynamics;
  // final Divisions? attack;
  // final Divisions? release;
  // final TimeOnly? timeOnly;
  // final bool? pizzicato;
  // final OptionalUniqueId? uniqueId;

  Note({
    this.grace,
    // this.fullNote,
    // this.cue,
    // this.instruments,
    required this.editorialVoice,
    this.type,
    this.dots,
    this.accidental,
    this.timeModification,
    this.stem,
    this.notehead,
    this.noteheadText,
    this.staff,
    this.beams,
    this.notations,
    // this.lyrics,
    // this.play,
    // this.listen,
    // this.xPosition,
    // this.font,
    // this.color,
    // this.printout,
    // this.printLeger,
    // this.dynamics,
    // this.endDynamics,
    // this.attack,
    // this.release,
    // this.timeOnly,
    // this.pizzicato,
    // this.uniqueId,
  });

  factory Note.fromXml(XmlElement xmlElement) {
    XmlElement? maybeGraceElement =
        xmlElement.findElements("grace").firstOrNull;
    Grace? grace;

    if (maybeGraceElement != null) {
      grace = Grace.fromXml(xmlElement);
    }

    XmlElement? maybeTypeElement = xmlElement.findElements("type").firstOrNull;
    NoteType? type;
    if (maybeTypeElement != null) {
      type = NoteType.fromXml(maybeTypeElement);
    }

    XmlElement? maybeAccidentalElement =
        xmlElement.findElements("accidental").firstOrNull;
    Accidental? accidental;
    if (maybeAccidentalElement != null) {
      accidental = Accidental.fromXml(maybeAccidentalElement);
    }

    XmlElement? maybeTimeModificationElement =
        xmlElement.findElements("time-modification").firstOrNull;
    TimeModification? timeModification;
    if (maybeTimeModificationElement != null) {
      timeModification = TimeModification.fromXml(maybeTimeModificationElement);
    }

    XmlElement? maybeStemElement = xmlElement.findElements("stem").firstOrNull;
    Stem? stem;
    if (maybeStemElement != null) {
      stem = Stem.fromXml(maybeStemElement);
    }

    XmlElement? maybeNoteheadElement =
        xmlElement.findElements("notehead").firstOrNull;
    Notehead? notehead;
    if (maybeNoteheadElement != null) {
      notehead = Notehead.fromXml(maybeNoteheadElement);
    }

    XmlElement? maybeNoteheadTextElement =
        xmlElement.findElements("notehead-text").firstOrNull;

    NoteheadText? noteheadText;
    if (maybeNoteheadTextElement != null) {
      noteheadText = NoteheadText.fromXml(maybeNoteheadTextElement);
    }

    String? rawStaff = xmlElement.findElements("staff").firstOrNull?.innerText;

    int? staff = int.tryParse(rawStaff ?? "");
    if (rawStaff != null && (staff == null || staff < 1)) {
      throw InvalidXmlElementException(
        "Staff value is non valid positiveInteger: $staff",
        xmlElement,
      );
    }

    Iterable<XmlElement> beamElements = xmlElement.findElements("beam");
    List<Beam> beams = beamElements.map((e) => Beam.fromXml(e)).toList();

    return Note(
      grace: grace,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
      type: type,
      accidental: accidental,
      timeModification: timeModification,
      stem: stem,
      notehead: notehead,
      noteheadText: noteheadText,
      staff: staff,
      beams: beams,
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    // Build your xml here, this will include calls to toXml() methods of properties like grace.toXml(), fullNote.toXml(), etc.
    return builder.buildDocument().rootElement;
  }
}

/// The grace type indicates the presence of a grace note.
///
/// The slash attribute for a grace note is yes for slashed grace notes.
/// The steal-time-previous attribute indicates the percentage of time to steal from the previous note for the grace note.
///
/// The steal-time-following attribute indicates the percentage of time to steal from the following note for the grace note, as for appoggiaturas.
/// The make-time attribute indicates to make time, not steal time;
/// the units are in real-time divisions for the grace note.
///
/// Content is always empty.
class Grace {
  /// The divisions type is used to express values in terms of the musical divisions defined by the divisions element.
  ///
  /// type="divisions"
  double? makeTime;

  /// The value is yes for slashed grace notes and no if no slash is present.
  ///
  /// Defaults to true.
  ///
  /// type="yes-no"
  bool slash;

  /// Indicates the percentage of time to steal from the following note for the grace note playback, as for appoggiaturas.
  ///
  /// type="percent"
  double? stealTimePrevious;

  /// The steal-time-previous attribute indicates the percentage of time to steal from the previous note for the grace note playback.
  ///
  /// type="percent"
  double? stealTimeFollowing;

  Grace({
    this.stealTimePrevious,
    this.stealTimeFollowing,
    this.makeTime,
    this.slash = true,
  });

  factory Grace.fromXml(XmlElement xmlElement) {
    final slashAttribute = xmlElement.getAttribute('slash');
    final makeTimeAttribute = xmlElement.getAttribute(
      'make-time',
    );
    final stealTimePreviousAttribute = xmlElement.getAttribute(
      'steal-time-previous',
    );
    final stealTimeFollowingAttribute = xmlElement.getAttribute(
      'steal-time-following',
    );

    Grace grace = Grace(
      makeTime: double.tryParse(makeTimeAttribute ?? ""),
      stealTimePrevious: double.tryParse(stealTimePreviousAttribute ?? ""),
      stealTimeFollowing: double.tryParse(stealTimeFollowingAttribute ?? ""),
      slash: YesNo.toBool(slashAttribute ?? "yes") ?? true,
    );

    grace.validate();
    return grace;
  }

  void validate() {
    if (stealTimePrevious != null && !Percent.validate(stealTimePrevious!)) {
      throw InvalidMusicXmlType(Percent.generateValidationError(
        "steal-time-previous",
        stealTimePrevious!,
      ));
    }
    if (stealTimePrevious != null && !Percent.validate(stealTimeFollowing!)) {
      throw InvalidMusicXmlType(Percent.generateValidationError(
        "steal-time-following",
        stealTimeFollowing!,
      ));
    }
  }

  XmlElement toXml() {
    final builder = XmlBuilder();

    builder.element('grace', nest: () {
      builder.attribute('slash', YesNo.toYesNo(slash));

      if (makeTime != null) {
        builder.attribute('make-time', makeTime.toString());
      }

      if (stealTimePrevious != null) {
        builder.attribute('steal-time-previous', stealTimePrevious.toString());
      }

      if (stealTimeFollowing != null) {
        builder.attribute(
          'steal-time-following',
          stealTimeFollowing.toString(),
        );
      }
    });

    return builder.buildDocument().rootElement;
  }
}

/// The full-note group is a sequence of the common note elements between cue/grace notes and regular (full) notes:
/// pitch, chord, and rest information, but not duration (cue and grace notes do not have duration encoded).
///
/// Unpitched elements are used for unpitched percussion, speaking voice, and other musical elements lacking determinate pitch.
class FullNote {
  /// The chord element indicates that this note is an additional chord tone with the preceding note.
  ///
  /// The duration of a chord note does not move the musical position within a measure.
  /// That is done by the duration of the first preceding note without a chord element.
  /// Thus the duration of a chord note cannot be longer than the preceding note.
  ///
  /// In most cases the duration will be the same as the preceding note.
  /// However it can be shorter in situations such as multiple stops for string instruments.
  ///
  /// name="chord" type="empty" minOccurs="0">
  bool chord;

  Pitched pitch;
  Unpitched unpitched;
  Rest rest;

  FullNote({
    required this.chord,
    required this.pitch,
    required this.unpitched,
    required this.rest,
  });
}

// 	<xs:group name="full-note">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:element name="chord" type="empty" minOccurs="0">
// 				<xs:annotation>
// 					<xs:documentation></xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:choice>
// 				<xs:element name="pitch" type="pitch"/>
// 				<xs:element name="unpitched" type="unpitched"/>
// 				<xs:element name="rest" type="rest"/>
// 			</xs:choice>
// 		</xs:sequence>
// 	</xs:group>

/// The pitched-value type represents pictograms for pitched percussion instruments.
///
/// The smufl attribute is used to distinguish different SMuFL glyphs for a particular pictogram within the Tuned mallet percussion pictograms range.
class Pitched {
  /// type="smufl-pictogram-glyph-name"
  ///
  /// See more at [SmuflPictogramGlyphName].
  String smufl;

  PitchedValue value;

  Pitched({
    required this.smufl,
    required this.value,
  });
}

/// The pitched-value type represents pictograms for pitched percussion instruments.
///
/// The chimes and tubular chimes values distinguish the single-line and double-line versions of the pictogram.
enum PitchedValue {
  celesta,
  chimes,
  glockenspiel,
  lithophone,
  mallet,
  marimba,
  steelDrums,
  tubaphone,
  tubularChimes,
  vibraphone,
  xylophone;
}

/// The unpitched type represents musical elements that are notated on the staff but lack definite pitch,
/// such as unpitched percussion and speaking voice.
///
/// If the child elements are not present, the note is placed on the middle line of the staff.
///
/// This is generally used with a one-line staff.
///
/// Notes in percussion clef should always use an unpitched element rather than a pitch element.
class Unpitched {
  /// The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements.
  /// This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch.
  /// Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2.
  Step? displayStep;

  /// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave started by middle C.
  ///
  /// The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements.
  /// This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch.
  /// Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2.
  ///
  /// 	<xs:restriction base="xs:integer">
  /// 		<xs:minInclusive value="0"/>
  /// 		<xs:maxInclusive value="9"/>
  /// 	</xs:restriction>
  int? displayOctave;
}

/// The step type represents a step of the diatonic scale, represented using the English letters A through G.
enum Step {
  A,
  B,
  C,
  D,
  E,
  F,
  G;
}

/// The rest element indicates notated rests or silences.
/// Rest elements are usually empty, but placement on the staff can be specified using display-step and display-octave elements.
///
/// If the measure attribute is set to yes, this indicates this is a complete measure rest.
class Rest {
  /// The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements.
  /// This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch.
  /// Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2.
  Step? displayStep;

  /// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave started by middle C.
  ///
  /// The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements.
  /// This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch.
  /// Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2.
  ///
  /// 	<xs:restriction base="xs:integer">
  /// 		<xs:minInclusive value="0"/>
  /// 		<xs:maxInclusive value="9"/>
  /// 	</xs:restriction>
  int? displayOctave;

  // TODO probably need other class for this:
  // <xs:group name="display-step-octave">
  // 	<xs:annotation>
  // 		<xs:documentation>The display-step-octave group contains the sequence of elements used by both the rest and unpitched elements. This group is used to place rests and unpitched elements on the staff without implying that these elements have pitch. Positioning follows the current clef. If percussion clef is used, the display-step and display-octave elements are interpreted as if in treble clef, with a G in octave 4 on line 2.</xs:documentation>
  // 	</xs:annotation>
  // 	<xs:sequence>
  // 		<xs:element name="display-step" type="step"/>
  // 		<xs:element name="display-octave" type="octave"/>
  // 	</xs:sequence>
  // </xs:group>

  /// type="yes-no"
  bool measure;

  Rest({
    this.displayStep,
    this.displayOctave,
    required this.measure,
  });
}

// The editorial-voice group supports the common combination of editorial and voice information for a musical element.
class EditorialVoice {
  Footnote? footnote;
  Level? level;

  /// A voice is a sequence of musical events (e.g. notes, chords, rests) that proceeds linearly in time.
  ///
  /// The voice element is used to distinguish between multiple voices in individual parts.
  ///
  /// It is defined within a group due to its multiple uses within the MusicXML schema.
  String? voice;

  EditorialVoice({
    this.footnote,
    this.level,
    this.voice,
  });

  factory EditorialVoice.fromXml(XmlElement xmlElement) {
    return EditorialVoice();
  }
}

/// The note-type type indicates the graphic note type. Values range from 1024th to maxima. The size attribute indicates full, cue, grace-cue, or large size.
///
/// The default is full for regular notes, grace-cue for notes that contain both grace and cue elements, and cue for notes that contain either a cue or a grace element, but not both.
class NoteType {
  final NoteTypeValue value;
  final SymbolSize size;

  NoteType({
    required this.value,
    this.size = SymbolSize.full,
  });

  factory NoteType.fromXml(XmlElement xmlElement) {
    return NoteType(
      value: NoteTypeValue.maxima,
    );
  }
}

/// The note-type-value type is used for the MusicXML type element and represents the graphic note type,
/// from 1024th (shortest) to maxima (longest).
enum NoteTypeValue {
  n1024th,
  n512th,
  n256th,
  n128th,
  n64th,
  n32nd,
  n16th,
  eighth,
  quarter,
  half,
  whole,
  breve,
  long,
  maxima;

  static const _map = {
    NoteTypeValue.n1024th: "1024th",
    NoteTypeValue.n512th: "512th",
    NoteTypeValue.n256th: "256th",
    NoteTypeValue.n128th: "128th",
    NoteTypeValue.n64th: "64th",
    NoteTypeValue.n32nd: "32nd",
    NoteTypeValue.n16th: "16th",
    NoteTypeValue.eighth: "eighth",
    NoteTypeValue.quarter: "quarter",
    NoteTypeValue.half: "half",
    NoteTypeValue.whole: "whole",
    NoteTypeValue.breve: "breve",
    NoteTypeValue.long: "long",
    NoteTypeValue.maxima: "maxima",
  };

  static NoteTypeValue? fromString(String str) {
    return _map.entries.firstWhereOrNull((e) => e.value == str)?.key;
  }

  @override
  String toString() => _map[this]!;
}

/// Indicates full, cue, grace-cue, or large size.
///
/// If not specified, the value is full for regular notes, grace-cue for notes that contain both <grace> and <cue> elements, and cue for notes that contain either a <cue> or a <grace> element, but not both.
enum SymbolSize {
  full,
  cue,
  graceCue,
  large;

  static const _map = {
    full: 'full',
    cue: 'cue',
    graceCue: 'grace-cue',
    large: 'large',
  };

  static SymbolSize? fromString(String str) {
    return _map.entries.firstWhereOrNull((e) => e.value == str)?.key;
  }

  @override
  String toString() => _map[this]!;
}

/// The empty-placement type represents an empty element with print-style and placement attributes.
class EmptyPlacement {
  PrintStyle? printStyle;

  /// The placement attribute indicates whether something is above or below another element, such as a note or a notation.
  Placement? placement;
}

/// The above-below type is used to indicate whether one element appears above or below another element.
enum Placement {
  /// This element appears above the reference element.
  above,

  /// This element appears below the reference element.
  below;

  static Placement? fromString(String value) {
    return Placement.values.firstWhereOrNull((v) => v.name == value);
  }

  @override
  String toString() => name;
}

/// The orientation attribute indicates whether slurs and ties are overhand (tips down) or underhand (tips up). This is distinct from the placement attribute used by any notation type.
enum Orientation {
  /// Tips of curved lines are overhand (tips down).
  over,

  /// Tips of curved lines are underhand (tips up).
  under;

  static Orientation? fromString(String value) {
    return Orientation.values.firstWhereOrNull((v) => v.name == value);
  }

  @override
  String toString() => name;
}

/// The accidental type represents actual notated accidentals.
///
/// Editorial and cautionary indications are indicated by attributes.
///
/// Values for these attributes are "no" if not present.
///
/// Specific graphic display such as parentheses, brackets, and size are controlled by the level-display attribute group.
class Accidental {
  AccidentalValue value;

  /// If yes, indicates that this is a cautionary accidental.
  /// The value is no if not present.
  ///
  /// type="yes-no".
  bool cautionary;

  /// If yes, indicates that this is an editorial accidental.
  /// The value is no if not present.
  ///
  /// type="yes-no".
  bool editorial;

  LevelDisplay levelDisplay;

  PrintStyle printStyle;

  /// References a specific Standard Music Font Layout (SMuFL) accidental glyph.
  ///
  /// This is used both with the other accidental value and for disambiguating cases where a single MusicXML accidental value could be represented by multiple SMuFL glyphs.
  ///
  /// type="smufl-accidental-glyph-name"
  String? smufl;

  Accidental({
    required this.value,
    this.cautionary = false,
    required this.editorial,
    required this.levelDisplay,
    required this.printStyle,
    required this.smufl,
  });

  factory Accidental.fromXml(XmlElement xmlElement) {
    AccidentalValue? value = AccidentalValue.fromString(
      xmlElement.innerText,
    );

    if (value == null) {
      throw InvalidXmlElementException("Bad Accidental value", xmlElement);
    }

    String? editorialAttribute = xmlElement.getAttribute("editorial");
    bool editorial = false;

    if (editorialAttribute != null) {
      editorial = YesNo.toBool(editorialAttribute) ?? false;
    }

    String? cautionaryAttribute = xmlElement.getAttribute("cautionary");
    bool cautionary = false;

    if (cautionaryAttribute != null) {
      cautionary = YesNo.toBool(cautionaryAttribute) ?? false;
    }

    String? smufl = xmlElement.getAttribute("smufl");

    return Accidental(
      value: value,
      cautionary: cautionary,
      editorial: editorial,
      levelDisplay: LevelDisplay.fromXml(xmlElement),
      printStyle: PrintStyle.fromXml(xmlElement),
      smufl: smufl,
    );
  }
}

/// The accidental-value type represents notated accidentals supported by MusicXML.
///
/// In the MusicXML 2.0 DTD this was a string with values that could be included.
///
/// The XSD strengthens the data typing to an enumerated list.
///
/// The quarter- and three-quarters- accidentals are Tartini-style quarter-tone accidentals.
///
/// The -down and -up accidentals are quarter-tone accidentals that include arrows pointing down or up.
///
/// The slash- accidentals are used in Turkish classical music.
///
/// The numbered sharp and flat accidentals are superscripted versions of the accidental signs, used in Turkish folk music.
///
/// The sori and koron accidentals are microtonal sharp and flat accidentals used in Iranian and Persian music.
///
/// The other accidental covers accidentals other than those listed here. It is usually used in combination with the smufl attribute to specify a particular SMuFL accidental.
///
/// The smufl attribute may be used with any accidental value to help specify the appearance of symbols that share the same MusicXML semantics.
enum AccidentalValue {
  sharp,
  natural,
  flat,
  doubleSharp,
  sharpSharp,
  flatFlat,
  naturalSharp,
  naturalFlat,
  quarterFlat,
  quarterFharp,
  threeQuartersFlat,
  threeQuartersSharp,
  sharpDown,
  sharpUp,
  naturalDown,
  naturalUp,
  flatDown,
  flatUp,
  doubleSharpDown,
  doubleSharpUp,
  flatFlatDown,
  flatFlatUp,
  arrowDown,
  arrowUp,
  tripleSharp,
  tripleFlat,
  slashQuarterSharp,
  slashSharp,
  slashFlat,
  doubleSlashFlat,
  sharp1,
  sharp2,
  sharp3,
  sharp5,
  flat1,
  flat2,
  flat3,
  flat4,
  sori,
  koron,
  other;

  /// Converts hyphen-separated string value to [AccidentalValue].
  ///
  /// Returns null if that name does not exists.
  static AccidentalValue? fromString(String value) {
    return AccidentalValue.values.firstWhereOrNull(
      (e) => e.name == hyphenToCamelCase(value),
    );
  }

  @override
  String toString() => camelCaseToHyphen(name);
}

/// Time modification indicates tuplets, double-note tremolos, and other durational changes.
///
/// A <time-modification> element shows how the cumulative, sounding effect of tuplets and
/// double-note tremolos compare to the written note type represented by the <type> and <dot> elements.
///
/// Nested tuplets and other notations that use more detailed information need both the <time-modification> and <tuplet> elements to be represented accurately.
class TimeModification {
  /// The actual-notes element describes how many notes are played in the time usually occupied by the number in the normal-notes element.
  ///
  /// nonNegativeInteger data type.
  ///
  /// Required.
  int actualNotes;

  /// The normal-notes element describes how many notes are usually played in the time occupied by the number in the actual-notes element.
  ///
  /// nonNegativeInteger data type.
  ///
  /// Required.
  int normalNotes;

  /// If the type associated with the number in the normal-notes element is different than the current note type (e.g., a quarter note within an eighth note triplet),
  /// then the normal-notes type (e.g. eighth) is specified in the normal-type and normal-dot elements.
  NoteTypeValue? normalType;

  /// The normal-dot element is used to specify dotted normal tuplet types.
  ///
  /// This property cannot exists without [normalType].
  int? normalDots;

  TimeModification({
    required this.actualNotes,
    required this.normalNotes,
    this.normalType,
    this.normalDots,
  });

  factory TimeModification.fromXml(XmlElement xmlElement) {
    int? actualNotes = int.tryParse(
      xmlElement.getElement("actual-notes")?.innerText ?? "",
    );

    if (actualNotes == null) {
      throw XmlElementRequired("actual-notes value is missing");
    }

    int? normalNotes = int.tryParse(
      xmlElement.getElement("normal-notes")?.innerText ?? "",
    );

    if (normalNotes == null) {
      throw XmlElementRequired("normal-notes value is missing");
    }

    NoteTypeValue? maybeNormalType = NoteTypeValue.fromString(
      xmlElement.getElement("normal-type")?.innerText ?? "",
    );

    int? normalDots;

    if (maybeNormalType != null) {
      normalDots = _calculateDots(xmlElement);
    }

    return TimeModification(
      actualNotes: actualNotes,
      normalNotes: normalNotes,
      normalType: maybeNormalType,
      normalDots: normalDots,
    );
  }

  static int _calculateDots(XmlElement xmlElement) {
    final normalType = xmlElement.getElement("normal-type");
    var sibling = normalType?.nextElementSibling;
    var count = 0;
    while (sibling != null && sibling.name.local == 'normal-dot') {
      count++;
      sibling = sibling.nextElementSibling;
    }
    return count;
  }
}

/// Stems can be down, up, none, or double.
///
/// For down and up stems, the position attributes can be used to specify stem length.
///
/// The relative values specify the end of the stem relative to the program default.
///
/// Default values specify an absolute end stem position.
///
/// Negative values of relative-y that would flip a stem instead of shortening it are ignored.
///
/// A stem element associated with a rest refers to a stemlet.
class Stem {
  StemValue value;
  Color color;
  Position position;

  Stem({
    required this.value,
    required this.color,
    required this.position,
  });

  factory Stem.fromXml(XmlElement xmlElement) {
    StemValue? value = StemValue.fromString(xmlElement.innerText ?? "");

    if (value == null) {
      throw XmlElementRequired("Steam value is missing");
    }

    return Stem(
      value: value,
      color: Color.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
    );
  }
/*  */
}

/// The stem-value type represents the notated stem direction.
enum StemValue {
  down,
  up,
  double,
  none;

  /// Converts provided string value to [StemValue].
  ///
  /// Returns null if that name does not exists.
  static StemValue? fromString(String value) {
    return StemValue.values.firstWhereOrNull(
      (e) => e.name == value,
    );
  }

  @override
  String toString() => name;
}

/// The notehead type indicates shapes other than the open and closed ovals associated with note durations.

/// The smufl attribute can be used to specify a particular notehead, allowing application interoperability without requiring every SMuFL glyph to have a MusicXML element equivalent.
/// This attribute can be used either with the "other" value, or to refine a specific notehead value such as "cluster".
/// Noteheads in the SMuFL Note name noteheads and Note name noteheads supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the smufl attribute or the "other" value,
/// but instead use the notehead-text element.
///
/// For the enclosed shapes, the default is to be hollow for half notes and longer, and filled otherwise.
/// The filled attribute can be set to change this if needed.
///
/// If the parentheses attribute is set to yes, the notehead is parenthesized.
///
/// It is no by default.
class Notehead {
  NoteheadValue value;

  /// Changes the appearance of enclosed shapes from the default of hollow for half notes and longer, and filled otherwise.
  ///
  /// Attribute of type "yes-no". Optional.
  bool filled;

  /// If yes, the notehead is parenthesized. It is no if not specified.
  bool parentheses;

  /// Indicates a particular Standard Music Font Layout (SMuFL) character using its canonical glyph name.
  ///
  /// Sometimes this is a formatting choice, and sometimes this is a refinement of the semantic meaning of an element.
  String? smufl;

  Color color;

  Font font;

  Notehead({
    required this.value,
    required this.filled,
    this.parentheses = false,
    this.smufl,
    required this.color,
    required this.font,
  });

  factory Notehead.fromXml(XmlElement xmlElement) {
    NoteheadValue? value = NoteheadValue.fromString(xmlElement.innerText);

    if (value == null) {
      throw XmlElementRequired("Notehead value is missing");
    }

    String? parenthesesAttribute = xmlElement.getAttribute("parentheses");

    bool? parentheses = YesNo.toBool(parenthesesAttribute ?? "");

    if (parenthesesAttribute != null && parentheses == null) {
      final String message = YesNo.generateValidationError(
        "parentheses",
        parenthesesAttribute,
      );

      throw InvalidXmlElementException(message, xmlElement);
    }

    String? smuflAttribute = xmlElement.getAttribute("smufl");

    if (smuflAttribute != null && !Nmtoken.validate(smuflAttribute)) {
      final String message = Nmtoken.generateValidationError(
        "parentheses",
        smuflAttribute,
      );

      throw InvalidXmlElementException(message, xmlElement);
    }

    return Notehead(
      value: value,
      filled: _determineDefaultFilled(xmlElement),
      parentheses: false,
      smufl: smuflAttribute,
      color: Color.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
    );
  }

  static bool _determineDefaultFilled(XmlElement xmlElement) {
    // TODO
    return false;
  }
}

/// The notehead-value type indicates shapes other than the open and closed ovals associated with note durations.
///
/// The values do, re, mi, fa, fa up, so, la, and ti correspond to Aikin's 7-shape system.
///
/// The fa up shape is typically used with upstems; the fa shape is typically used with downstems or no stems.
///
/// The arrow shapes differ from triangle and inverted triangle by being centered on the stem.
///
/// Slashed and back slashed notes include both the normal notehead and a slash. The triangle shape has the tip of the triangle pointing up;
/// the inverted triangle shape has the tip of the triangle pointing down. The left triangle shape is a right triangle with the hypotenuse facing up and to the left.
///
/// The other notehead covers noteheads other than those listed here.
///
/// It is usually used in combination with the smufl attribute to specify a particular SMuFL notehead.
///
/// The smufl attribute may be used with any notehead value to help specify the appearance of symbols that share the same MusicXML semantics.
///
/// Noteheads in the SMuFL Note name noteheads and Note name noteheads supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the smufl attribute or the "other" value,
/// but instead use the notehead-text element.
enum NoteheadValue {
  slash,
  triangle,
  diamond,
  square,
  cross,
  x,
  circleX,
  invertedTriangle,
  arrowDown,
  arrowUp,
  circled,
  slashed,
  backSlashed,
  normal,
  cluster,
  circleDot,
  leftTriangle,
  rectangle,
  none,
  aikinDo,
  aikinRe,
  aikinMi,
  aikinFa,
  aikinFaUp,
  aikinSo,
  aikinLa,
  aikinTi,
  other;

  static const _map = {
    'slash': slash,
    'triangle': triangle,
    'diamond': diamond,
    'square': square,
    'cross': cross,
    'x': x,
    'circle-x': circleX,
    'inverted triangle': invertedTriangle,
    'arrow down': arrowDown,
    'arrow up': arrowUp,
    'circled': circled,
    'slashed': slashed,
    'back slashed': backSlashed,
    'normal': normal,
    'cluster': cluster,
    'circle dot': circleDot,
    'left triangle': leftTriangle,
    'rectangle': rectangle,
    'none': none,
    'do': aikinDo,
    're': aikinRe,
    'mi': aikinMi,
    'fa': aikinFa,
    'fa up': aikinFaUp,
    'so': aikinSo,
    'la': aikinLa,
    'ti': aikinTi,
    'other': other,
  };

  /// Converts provided string value to [StemValue].
  ///
  /// Returns null if that name does not exists.
  static NoteheadValue? fromString(String value) {
    return _map[value];
  }

  @override
  String toString() => inverseMap(_map)[this];
}

abstract class NoteheadTextContent {}

class NoteheadText {
  final List<NoteheadTextContent> contents;

  NoteheadText(this.contents);

  factory NoteheadText.fromXml(XmlElement element) {
    var contents = <NoteheadTextContent>[];
    for (var child in element.children) {
      if (child is XmlElement) {
        if (child.name.local == 'display-text') {
          contents.add(FormattedText.fromXml(child));
        } else if (child.name.local == 'accidental-text') {
          contents.add(AccidentalText.fromXml(child));
        }
      }
    }
    return NoteheadText(contents);
  }
}

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
        message,
        xmlElement,
      );
    }

    String? fanAttribute = xmlElement.getAttribute("fan");
    Fan? fan = Fan.fromString(fanAttribute ?? "");
    if (fanAttribute != null && fan == null) {
      final String message =
          "Bad fan attribute value was provided: $fanAttribute";
      throw InvalidXmlElementException(
        message,
        xmlElement,
      );
    }

    String? numberAttribute = xmlElement.getAttribute("number");
    int? number = BeamLevel.tryParse(numberAttribute ?? "");
    if (numberAttribute != null && number == null) {
      final String message =
          "Bad number attribute value was provided: $fanAttribute";
      throw InvalidXmlElementException(
        message,
        xmlElement,
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
