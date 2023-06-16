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
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/accidental.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/listen.dart';
import 'package:music_notation/src/models/elements/music_data/note/lyric.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/notehead.dart';
import 'package:music_notation/src/models/elements/music_data/note/play.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/models/elements/music_data/note/time_modification.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/invalid_xml_element_exception.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';

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
class Note implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final Grace? grace;
  final EditorialVoice editorialVoice;

  // TODO:
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
  /// Positive integer.
  final int? staff;

  final List<Beam>? beams;
  final List<Notations>? notations;
  final List<Lyric>? lyrics;
  final Play? play;
  final Listen? listen;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  final Position? position;
  final Font? font;
  final Color? color;
  final Printout? printout;

  /// Indicates whether leger lines are printed. Notes without leger lines are used to indicate indeterminate high and low notes.
  ///
  /// It is yes if not present unless print-object is set to no.
  ///
  /// This attribute is ignored for rests.
  final bool? printLeger;

  /// Corresponds to MIDI 1.0's Note On velocity,
  /// expressed in terms of percentage of the default forte value (90 for MIDI 1.0).
  ///
  /// type of non-negative-decimal;
  final double? dynamics;

  /// Corresponds to MIDI 1.0's Note Off velocity,
  /// expressed in terms of percentage of the default forte value (90 for MIDI 1.0).
  ///
  /// type of non-negative-decimal;
  final double? endDynamics;

  /// Alters the starting time of the note from when it would otherwise occur based on the flow of durations - information that is specific to a performance.
  ///
  /// It is expressed in terms of divisions, either positive or negative.
  /// A <note> that stops a tie should not have an attack attribute.
  ///
  /// The attack and release attributes are independent of each other.
  ///
  /// The attack attribute only changes the starting time of a note.
  ///
  /// Type of "divisions".
  final double? attack;

  /// Alters the stopping time of the note from when it would otherwise occur based on the flow of durations - information that is specific to a performance.
  ///
  /// It is expressed in terms of divisions, either positive or negative.
  ///
  /// A <note> that starts a tie should not have a release attribute.
  ///
  /// The attack and release attributes are independent of each other.
  ///
  /// The release attribute only changes the stopping time of a note.
  final double? release;

  /// Shows which times to play the note during a repeated section.
  final double? timeOnly;

  /// Used when just this note is sounded pizzicato, vs. the <pizzicato> element which changes overall playback between pizzicato and arco.
  final bool? pizzicato;

  /// Specifies an ID that is unique to the entire document.
  final String? id;

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
    this.lyrics,
    this.play,
    this.listen,
    this.position,
    this.font,
    this.color,
    this.printout,
    this.printLeger,
    this.dynamics,
    this.endDynamics,
    this.attack,
    this.release,
    this.timeOnly,
    this.pizzicato,
    this.id,
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

    Iterable<XmlElement> lyricsElements = xmlElement.findElements("lyrics");
    List<Lyric> lyrics = lyricsElements.map((e) => Lyric.fromXml(e)).toList();

    XmlElement? playElement = xmlElement.findElements("play").firstOrNull;
    Play? play;
    if (playElement != null) {
      play = Play.fromXml(playElement);
    }

    XmlElement? listenElement = xmlElement.findElements("listen").firstOrNull;
    Listen? listen;
    if (listenElement != null) {
      listen = Listen.fromXml(listenElement);
    }

    String? printLagerAttribute = xmlElement.getAttribute("print-leger");

    bool? printLager = YesNo.toBool(printLagerAttribute ?? "");

    if (printLagerAttribute != null && printLager == null) {
      // TODO
      throw InvalidXmlElementException("", xmlElement);
    }

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
      lyrics: lyrics,
      play: play,
      listen: listen,
      position: Position.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
      printout: Printout.fromXml(xmlElement),
      printLeger: printLager,
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

/// The printout attribute group collects the different controls over printing an object (e.g. a note or rest) and its parts,
/// including augmentation dots and lyrics.
///
/// This is especially useful for notes that overlap in different voices,
/// or for chord sheets that contain lyrics and chords but no melody.
///
/// By default, all these attributes are set to yes.
/// If print-object is set to no,
/// the print-dot and print-lyric attributes are interpreted to also be set to no if they are not present.
class Printout {
  /// The print-object attribute specifies whether or not to print an object (e.g. a note or a rest).
  ///
  /// It is yes by default.
  bool? printObject;

  bool? printDot;

  /// The print-spacing attribute controls whether or not spacing is left for an invisible note or object.
  ///
  /// It is used only if no note, dot, or lyric is being printed.
  ///
  /// The value is yes (leave spacing) by default.
  bool? printSpacing;

  bool? printLyric;

  Printout();

  factory Printout.fromXml(XmlElement xmlElement) {
    return Printout();
  }
}
