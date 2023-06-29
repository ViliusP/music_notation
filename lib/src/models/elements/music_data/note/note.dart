import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/note/accidental.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/listen.dart';
import 'package:music_notation/src/models/elements/music_data/note/lyric.dart';
import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/notehead.dart';
import 'package:music_notation/src/models/elements/music_data/note/play.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/models/elements/music_data/note/time_modification.dart';
import 'package:music_notation/src/models/elements/music_data/printout.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';

/// Notes are the most common type of MusicXML data.
///
/// The MusicXML format distinguishes between elements used for sound information
/// and elements used for notation information (e.g., tie is used for sound, tied for notation).
/// Thus grace notes do not have a duration element.
/// Cue notes have a duration element, as do forward elements, but no tie elements.
/// Having these two types of information available can make interchange easier,
/// as some programs handle one type of information more readily than the other.
class Note implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The chord element indicates that this note is an additional chord tone with the preceding note.
  ///
  /// The duration of a chord note does not move the musical position within a measure.
  /// That is done by the duration of the first preceding note without a chord element.
  /// Thus the duration of a chord note cannot be longer than the preceding note.
  ///
  /// In most cases the duration will be the same as the preceding note.
  /// However it can be shorter in situations such as multiple stops for string instruments.
  Empty? chord;

  PitchUnpitchedRest pitchUnpitchedRest;

  final EditorialVoice editorialVoice;

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
  /// Used by both notes and directions. Staff values are numbers,
  /// with 1 referring to the top-most staff in a part.
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

  /// Indicates whether leger lines are printed. Notes without leger lines
  /// are used to indicate indeterminate high and low notes.
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

  /// Alters the starting time of the note from when it would otherwise occur
  /// based on the flow of durations - information that is specific to a performance.
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

  /// Alters the stopping time of the note from when it would otherwise occur
  /// based on the flow of durations - information that is specific to a performance.
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

  /// Used when just this note is sounded pizzicato, vs. the <pizzicato> element
  /// which changes overall playback between pizzicato and arco.
  final bool? pizzicato;

  /// Specifies an ID that is unique to the entire document.
  final String? id;

  Note({
    // this.grace,
    // this.fullNote,
    // this.cue,
    // this.instruments,
    this.chord,
    required this.pitchUnpitchedRest,
    this.editorialVoice = const EditorialVoice.empty(),
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
    // XmlElement? maybeGraceElement =
    //     xmlElement.findElements("grace").firstOrNull;
    // Grace? grace;

    // if (maybeGraceElement != null) {
    //   grace = Grace.fromXml(xmlElement);
    // }

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
      throw XmlElementContentException(
        message: "Staff value is non valid positiveInteger: $staff",
        xmlElement: xmlElement,
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
      throw XmlElementContentException(
        message: "",
        xmlElement: xmlElement,
      );
    }

    return Note(
      // grace: grace,
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
      pitchUnpitchedRest: Unpitched(),
    );
  }

  @override
  XmlElement toXml() {
    final builder = XmlBuilder();
    // Build your xml here, this will include calls to toXml() methods of properties like grace.toXml(), fullNote.toXml(), etc.
    return builder.buildDocument().rootElement;
  }
}

/// Indicates the presence of a grace note.
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
    if (stealTimePrevious != null && !Percent.isValid(stealTimePrevious!)) {
      throw const FormatException();
      // TODO
      // throw MusicXmlFormatException(
      //   message: Percent.generateValidationError(
      //     "steal-time-previous",
      //     stealTimePrevious!,
      //   ),
      //   xmlElement: null,
      // );
    }
    if (stealTimePrevious != null && !Percent.isValid(stealTimeFollowing!)) {
      throw const FormatException();
      // TODO
      // throw MusicXmlFormatException(
      //   message: Percent.generateValidationError(
      //     "steal-time-following",
      //     stealTimeFollowing!,
      //   ),
      //   xmlElement: null,
      // );
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

/// Represents pictograms for pitched percussion instruments.
///
/// The smufl attribute is used to distinguish different SMuFL glyphs
/// for a particular pictogram within the Tuned mallet percussion pictograms range.
class Pitched extends PitchUnpitchedRest {
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

/// Represents pictograms for pitched percussion instruments.
///
/// The chimes and tubular chimes values distinguish the single-line
/// and double-line versions of the pictogram.
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

/// Represents musical elements that are notated on the staff but lack definite pitch,
/// such as unpitched percussion and speaking voice.
///
/// If the child elements are not present, the note is placed on the middle line of the staff.
///
/// This is generally used with a one-line staff.
///
/// Notes in percussion clef should always use an unpitched element rather than a pitch element.
class Unpitched extends PitchUnpitchedRest {
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

/// The rest element indicates notated rests or silences.
/// Rest elements are usually empty, but placement on the staff can be specified using display-step and display-octave elements.
///
/// If the measure attribute is set to yes, this indicates this is a complete measure rest.
class Rest extends PitchUnpitchedRest {
  /// Elements used by both the rest and unpitched elements.
  /// This group is used to place rests and unpitched elements on the staff
  /// without implying that these elements have pitch. Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave
  /// elements are interpreted as if in treble clef, with a G in octave 4 on line 2.
  Step? displayStep;

  /// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave started by middle C.
  ///
  /// Elements used by both the rest and unpitched elements. This group is used
  /// to place rests and unpitched elements on the staff without implying
  /// that these elements have pitch. Positioning follows the current clef.
  /// If percussion clef is used, the display-step and display-octave elements
  /// are interpreted as if in treble clef, with a G in octave 4 on line 2.
  int? displayOctave;

  bool measure;

  Rest({
    this.displayStep,
    this.displayOctave,
    required this.measure,
  });
}

// abstract class NoteType {}

// class Pitch extends NoteType {
//   // Pitch-specific properties and methods here.
// }

abstract class GraceNote extends Note {
  Grace grace;

  GraceNote({
    required this.grace,
    required super.pitchUnpitchedRest,
  });
}

class GraceTieNote extends GraceNote {
  List<Tie> ties;

  GraceTieNote({
    this.ties = const [],
    required super.grace,
    required super.pitchUnpitchedRest,
  });
}

class GraceCueNote extends GraceNote {
  Empty cue;

  GraceCueNote({
    required super.grace,
    required this.cue,
    required super.pitchUnpitchedRest,
  });
}

class CueNote extends Note {
  Empty cue;

  /// Positive number specified in division units. This is the intended duration vs. notated duration (for instance, differences in dotted notes in Baroque-era music). Differences in duration specific to an interpretation or performance should be represented using the note element's attack and release attributes.
  /// The duration element moves the musical position when used in backup elements, forward elements, and note elements that do not contain a chord child element.
  double duration;

  CueNote({
    required this.cue,
    required this.duration,
    required super.pitchUnpitchedRest,
  });
}

class RegularNote extends Note {
  /// Positive number specified in division units. This is the intended duration vs. notated duration (for instance, differences in dotted notes in Baroque-era music). Differences in duration specific to an interpretation or performance should be represented using the note element's attack and release attributes.
  /// The duration element moves the musical position when used in backup elements, forward elements, and note elements that do not contain a chord child element.
  double duration;

  List<Tie> ties;

  RegularNote({
    required this.duration,
    this.ties = const [],
    required super.pitchUnpitchedRest,
  });
}

//  Note {}
abstract class PitchUnpitchedRest {}

/// Indicates that a tie begins or ends with this note.
/// The tie element indicates sound; the tied element indicates notation.
class Tie {
  /// Indicates if this is the start or stop of the tie.
  StartStop type;

  /// Indicates which particular times to apply this through a repeated section.
  String? timeOnly;

  Tie({
    required this.type,
    this.timeOnly,
  });

  factory Tie.fromXml(XmlElement xmlElement) {
    return Tie(
      type: StartStop.fromXml(xmlElement),
      timeOnly: TimeOnly.fromXml(xmlElement),
    );
  }
}
