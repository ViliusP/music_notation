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
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';

/// Notes are the most common type of MusicXML data.
///
/// The MusicXML format distinguishes between elements used for sound information
/// and elements used for notation information (e.g., tie is used for sound, tied for notation).
/// Thus grace notes do not have a duration element.
/// Cue notes have a duration element, as do forward elements, but no tie elements.
/// Having these two types of information available can make interchange easier,
/// as some programs handle one type of information more readily than the other.
///
/// For more details go to
/// [The \<note\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/note/).
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
  final Empty? chord;

  /// The common note elements between cue/grace notes and regular (full) notes:
  /// [RegularNote] and [Rest] information, but not duration (cue and grace
  /// notes do not have duration encoded). [Unpitched] elements are used for
  /// unpitched percussion, speaking voice, and other musical elements lacking determinate pitch.
  ///
  /// It represents full-note choices of musicXML specification:
  /// ```xml
  /// <xs:choice>
  ///	  <xs:element name="pitch" type="pitch"/>
  ///	  <xs:element name="unpitched" type="unpitched"/>
  ///	  <xs:element name="rest" type="rest"/>
  ///	</xs:choice>
  /// ```
  final NoteForm form;

  /// If multiple score instrument are specified in a score part, there should
  /// be an instrument element for each note in the part. Notes that are shared
  /// between multiple score-instruments can have more than one instrument element.
  final List<String> instrument;

  final EditorialVoice editorialVoice;

  final NoteType? type;

  /// One dot element is used for each dot of prolongation.
  final List<EmptyPlacement> dots;
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

  final List<Beam> beams;
  final List<Notations> notations;
  final List<Lyric> lyrics;
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

  const Note({
    // --- Content ---
    this.chord,
    required this.form,
    this.instrument = const [],
    this.editorialVoice = const EditorialVoice.empty(),
    this.type,
    this.dots = const [],
    this.accidental,
    this.timeModification,
    this.stem,
    this.notehead,
    this.noteheadText,
    this.staff,
    this.beams = const [],
    this.notations = const [],
    this.lyrics = const [],
    this.play,
    this.listen,
    // --- Attributes ---
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

  Note._({
    // --- Content ---
    this.chord,
    required this.form,
    this.instrument = const [],
    this.editorialVoice = const EditorialVoice.empty(),
    this.type,
    this.dots = const [],
    this.accidental,
    this.timeModification,
    this.stem,
    this.notehead,
    this.noteheadText,
    this.staff,
    this.beams = const [],
    this.notations = const [],
    this.lyrics = const [],
    this.play,
    this.listen,
    // --- Attributes ---
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

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'instrument': XmlQuantifier.zeroOrMore,
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
    'voice': XmlQuantifier.optional,
    'type': XmlQuantifier.optional,
    'dot': XmlQuantifier.zeroOrMore,
    'accidental': XmlQuantifier.optional,
    'time-modification': XmlQuantifier.optional,
    'stem': XmlQuantifier.optional,
    'notehead': XmlQuantifier.optional,
    'notehead-text': XmlQuantifier.optional,
    'staff': XmlQuantifier.optional,
    // Specifically (0 to 8 times). In future, this XmlQuantifier could be implemented.
    'beam': XmlQuantifier.zeroOrMore,
    'notations': XmlQuantifier.zeroOrMore,
    'lyric': XmlQuantifier.zeroOrMore,
    'play': XmlQuantifier.optional,
    'listen': XmlQuantifier.optional,
  };

  factory Note.fromXml(XmlElement xmlElement) {
    var specificNoteType = GraceCueNote;
    try {
      validateSequence(
        xmlElement,
        {}
          ..addAll(GraceCueNote._xmlExpectedOrder)
          ..addAll(_xmlExpectedOrder),
      );
      specificNoteType = GraceCueNote;
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }
    try {
      validateSequence(
        xmlElement,
        {}
          ..addAll(GraceTieNote._xmlExpectedOrder)
          ..addAll(_xmlExpectedOrder),
      );
      specificNoteType = GraceTieNote;
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }
    try {
      validateSequence(
        xmlElement,
        {}
          ..addAll(CueNote._xmlExpectedOrder)
          ..addAll(_xmlExpectedOrder),
      );
      specificNoteType = CueNote;
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }
    try {
      validateSequence(
        xmlElement,
        {}
          ..addAll(RegularNote._xmlExpectedOrder)
          ..addAll(_xmlExpectedOrder),
      );
      specificNoteType = RegularNote;
    } on XmlSequenceException catch (_) {
    } catch (e) {
      rethrow;
    }
    // ---- Chord ----
    var chordElement = xmlElement.getElement("chord");
    validateEmptyContent(chordElement);

    // ---- Type ----
    var typeElement = xmlElement.getElement("type");
    var type = typeElement != null ? NoteType.fromXml(typeElement) : null;

    // ---- Accidental ----
    var accidentalElement = xmlElement.getElement("accidental");
    var accidental = accidentalElement != null
        ? Accidental.fromXml(accidentalElement)
        : null;

    // ---- Time-modification ----
    var timeModificationElement = xmlElement.getElement(
      "time-modification",
    );
    var timeModification = timeModificationElement != null
        ? TimeModification.fromXml(timeModificationElement)
        : null;
    // ---- Stem ----
    var maybeStemElement = xmlElement.getElement("stem");
    var stem = maybeStemElement != null ? Stem.fromXml(maybeStemElement) : null;

    // XmlElement? maybeNoteheadElement =
    //     xmlElement.findElements("notehead").firstOrNull;
    // Notehead? notehead;
    // if (maybeNoteheadElement != null) {
    //   notehead = Notehead.fromXml(maybeNoteheadElement);
    // }

    // XmlElement? maybeNoteheadTextElement =
    //     xmlElement.findElements("notehead-text").firstOrNull;

    // NoteheadText? noteheadText;
    // if (maybeNoteheadTextElement != null) {
    //   noteheadText = NoteheadText.fromXml(maybeNoteheadTextElement);
    // }

    /// ---- Staff ----
    var staffElement = xmlElement.getElement("staff");
    validateTextContent(staffElement);
    var staff = int.tryParse(staffElement?.innerText ?? "");
    if (staffElement != null && (staff == null || staff < 1)) {
      throw MusicXmlFormatException(
        message: "'staff' content is not valid positive int",
        xmlElement: xmlElement,
        source: staffElement.innerText,
      );
    }

    // ---- Beams ----
    Iterable<XmlElement> beamElements = xmlElement.findElements("beam");
    List<Beam> beams = beamElements.map((e) => Beam.fromXml(e)).toList();

    // ---- lyrics ----
    var lyricsElements = xmlElement.findElements("lyrics");
    var lyrics = lyricsElements.map((e) => Lyric.fromXml(e)).toList();

    // XmlElement? playElement = xmlElement.findElements("play").firstOrNull;
    // Play? play;
    // if (playElement != null) {
    //   play = Play.fromXml(playElement);
    // }

    // XmlElement? listenElement = xmlElement.findElements("listen").firstOrNull;
    // Listen? listen;
    // if (listenElement != null) {
    //   listen = Listen.fromXml(listenElement);
    // }

    // String? printLagerAttribute = xmlElement.getAttribute("print-leger");

    // bool? printLager = YesNo.toBool(printLagerAttribute ?? "");

    // if (printLagerAttribute != null && printLager == null) {
    //   // TODO
    //   throw XmlElementContentException(
    //     message: "",
    //     xmlElement: xmlElement,
    //   );
    // }

    Note noteBase = Note._(
      // --- Content ---
      form: NoteForm._fromXml(xmlElement),
      chord: chordElement != null ? const Empty() : null,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
      type: type,
      accidental: accidental,
      timeModification: timeModification,
      stem: stem,
      // notehead: notehead,
      // noteheadText: noteheadText,
      staff: staff,
      beams: beams,
      lyrics: lyrics,
      // play: play,
      // listen: listen,
      // --- Attributes ---
      position: Position.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
      printout: Printout.fromXml(xmlElement),
      // printLeger: printLager,
    );

    switch (specificNoteType) {
      case const (GraceTieNote):
        return GraceTieNote._fromNote(
          grace: Grace.fromXml(xmlElement.getElement("grace")!),
          note: noteBase,
          ties: xmlElement
              .findElements("tie")
              .map((e) => Tie.fromXml(e))
              .toList(),
        );
      case const (GraceCueNote):
        return GraceCueNote._fromNote(
          note: noteBase,
          grace: Grace.fromXml(xmlElement.getElement("grace")!),
        );

      case const (CueNote):
        final XmlElement durationElement = xmlElement.getElement("duration")!;
        validateTextContent(durationElement);
        double? duration = double.tryParse(durationElement.innerText);
        if (duration == null || duration <= 0) {
          throw MusicXmlFormatException(
            message: "'duration' content is not validate positive divisions",
            xmlElement: xmlElement,
            source: durationElement.innerText,
          );
        }

        return CueNote._fromNote(
          note: noteBase,
          duration: duration,
        );
      case const (RegularNote):
        final XmlElement durationElement = xmlElement.getElement("duration")!;
        validateTextContent(durationElement);
        double? duration = double.tryParse(durationElement.innerText);
        if (duration == null || duration <= 0) {
          throw MusicXmlFormatException(
            message: "'duration' content is not validate positive divisions",
            xmlElement: xmlElement,
            source: durationElement.innerText,
          );
        }

        return RegularNote._fromNote(
          note: noteBase,
          duration: duration,
          ties: xmlElement
              .findElements("tie")
              .map((e) => Tie.fromXml(e))
              .toList(),
        );
      default:
        throw XmlElementContentException(
          message: "Specific note cannot be parsed from provided xml element",
          xmlElement: xmlElement,
        );
    }
  }

  @override
  XmlElement toXml() {
    final builder = XmlBuilder();
    // Build your xml here, this will include calls to toXml() methods of
    // properties like grace.toXml(), fullNote.toXml(), etc.
    return builder.buildDocument().rootElement;
  }
}

/// Indicates the presence of a grace note.
///
/// In musicXML, content is always empty.
class Grace {
  /// The divisions type is used to express values in terms of the musical
  /// divisions defined by the divisions element.
  double? makeTime;

  /// The value is yes for slashed grace notes and no if no slash is present.
  ///
  /// Defaults to true.
  bool slash;

  /// Indicates the percentage of time to steal from the following note for
  /// the grace note playback, as for appoggiaturas.
  double? stealTimePrevious;

  /// The steal-time-previous attribute indicates the percentage of time to
  /// steal from the previous note for the grace note playback.
  double? stealTimeFollowing;

  Grace({
    this.stealTimePrevious,
    this.stealTimeFollowing,
    this.makeTime,
    this.slash = true,
  });

  factory Grace.fromXml(XmlElement xmlElement) {
    final makeTimeAttribute = xmlElement.getAttribute(
      'make-time',
    );

    double? makeTime = double.tryParse(makeTimeAttribute ?? "");
    if (makeTimeAttribute != null && makeTime == null) {
      throw MusicXmlFormatException(
        message: "'make-time' attribute in 'grace' is not valid division value",
        xmlElement: xmlElement,
        source: makeTimeAttribute,
      );
    }

    return Grace(
      slash: YesNo.fromXml(xmlElement, 'slash') ?? true,
      makeTime: makeTime,
      stealTimePrevious: Percent.fromXml(xmlElement, 'steal-time-previous'),
      stealTimeFollowing: Percent.fromXml(xmlElement, 'steal-time-following'),
    );
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

sealed class NoteForm {
  Step? get step;
  int? get octave;

  factory NoteForm._fromXml(XmlElement xmlElement) {
    XmlElement? pitchElement = xmlElement.getElement("pitch");
    if (pitchElement != null) {
      return Pitch.fromXml(pitchElement);
    }
    XmlElement? unpitchedElement = xmlElement.getElement("unpitched");
    if (unpitchedElement != null) {
      return Unpitched.fromXml(unpitchedElement);
    }
    XmlElement? restElement = xmlElement.getElement("rest");
    if (restElement != null) {
      return Rest.fromXml(restElement);
    }
    throw XmlElementContentException(
      message: "Provided element is not pitch, unpitched or rest",
      xmlElement: xmlElement,
    );
  }
}

/// Represents musical elements that are notated on the staff but lack definite pitch,
/// such as unpitched percussion and speaking voice. If the child elements are
/// not present, the note is placed on the middle line of the staff.
///
/// This is generally used with a one-line staff. Notes in percussion clef
/// should always use an unpitched element rather than a pitch element.
class Unpitched implements NoteForm {
  /// Specifies the line of the staff on which the rest should be displayed,
  /// in terms of musical pitch steps (A, B, C, D, E, F, G).
  /// For instance, a `displayStep` of `Step.B` would mean the rest should be displayed
  /// on the line corresponding to the pitch B in the current clef.
  Step displayStep;

  @override
  Step get step => displayStep;

  /// Specifies the octave of the rest for display purposes. Octaves are
  /// represented by the numbers 0 to 9, where 4 indicates the octave started
  /// by middle C. So, if `displayOctave` is 4, the rest should be displayed
  /// in the same vertical position as a note in the middle C octave
  /// would be in the current clef.
  int displayOctave;

  @override
  int get octave => displayOctave;

  Unpitched({
    required this.displayStep,
    required this.displayOctave,
  });

  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'display-step': XmlQuantifier.required,
      'display-octave': XmlQuantifier.required,
    }: XmlQuantifier.optional,
  };

  // TODO: test and comment
  factory Unpitched.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? stepElement = xmlElement.getElement("display-step");
    validateTextContent(stepElement);
    Step? step = Step.fromString(stepElement?.innerText ?? "");
    if (step == null) {
      throw MusicXmlTypeException(
        message: '${stepElement?.innerText} is not valid step',
        xmlElement: xmlElement,
      );
    }

    XmlElement? octaveElement = xmlElement.getElement("display-octave")!;
    validateTextContent(octaveElement);
    int? octave = int.tryParse(octaveElement.innerText);
    if (octave == null || octave < 0 || octave > 9) {
      throw MusicXmlFormatException(
        message: '${octaveElement.innerText} is not valid octave',
        xmlElement: xmlElement,
        source: octaveElement.innerText,
      );
    }

    return Unpitched(
      displayStep: step,
      displayOctave: octave,
    );
  }
}

/// Notated rests or silences. Rest elements are usually empty, but placement
/// on the staff can be specified using [displayStep] and [displayOctave].
///
/// If the measure attribute is set to yes, this indicates this is a complete measure rest.
///
/// For more details go to
/// [The \<rest\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/rest/).
class Rest implements NoteForm {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Specifies the line of the staff on which the rest should be displayed,
  /// in terms of musical pitch steps (A, B, C, D, E, F, G).
  /// For instance, a `displayStep` of `Step.B` would mean the rest should be displayed
  /// on the line corresponding to the pitch B in the current clef.
  Step? displayStep;

  @override
  Step? get step => displayStep;

  /// Specifies the octave of the rest for display purposes. Octaves are
  /// represented by the numbers 0 to 9, where 4 indicates the octave started
  /// by middle C. So, if `displayOctave` is 4, the rest should be displayed
  /// in the same vertical position as a note in the middle C octave
  /// would be in the current clef.
  int? displayOctave;

  @override
  int? get octave => displayOctave;

  /// If true, indicates this is a complete measure rest
  bool? measure;

  Rest({
    this.displayStep,
    this.displayOctave,
    this.measure,
  });

  /// Defines the expected order of the XML elements
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'display-step': XmlQuantifier.required,
      'display-octave': XmlQuantifier.required,
    }: XmlQuantifier.optional,
  };

  /// Creates an instance of the [Rest] class from an [XmlElement].
  ///
  /// Throws [MusicXmlTypeException] if the provided step is not valid.
  /// Throws [MusicXmlFormatException] if the provided octave is not valid.
  /// Throws [XmlElementContentException] if contents of child elements is not text.
  /// Throws [XmlSequenceException] if contents is in wrong order.
  factory Rest.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? stepElement = xmlElement.getElement("display-step");
    validateTextContent(stepElement);
    Step? step = Step.fromString(stepElement?.innerText ?? "");
    if (step == null && stepElement != null) {
      throw MusicXmlTypeException(
        message: '${stepElement.innerText} is not valid step',
        xmlElement: xmlElement,
      );
    }

    XmlElement? octaveElement = xmlElement.getElement("display-octave");
    validateTextContent(octaveElement);
    int? octave = int.tryParse(octaveElement?.innerText ?? "");
    if (octaveElement != null && (octave == null || octave < 0 || octave > 9)) {
      throw MusicXmlFormatException(
        message: '${octaveElement.innerText} is not valid octave',
        xmlElement: xmlElement,
        source: octaveElement.innerText,
      );
    }

    return Rest(
      displayStep: step,
      displayOctave: octave,
      measure: YesNo.fromXml(xmlElement, "measure"),
    );
  }
}

sealed class GraceNote extends Note {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  Grace grace;

  GraceNote({
    required this.grace,
    required Note note,
  }) : super._(form: note.form);
}

class GraceTieNote extends GraceNote {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  List<Tie> ties;

  // GraceTieNote({
  //   required super.grace,
  //   this.ties = const [],
  //   required super.note,
  // });

  GraceTieNote._fromNote({
    required super.grace,
    this.ties = const [],
    required super.note,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'grace': XmlQuantifier.required,
    'chord': XmlQuantifier.optional,
    'pitch|unpitched|rest': XmlQuantifier.required,
    'tie': XmlQuantifier.zeroToTwo,
  };
}

class GraceCueNote extends GraceNote {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  // GraceCueNote({
  //   required super.grace,
  //   required super.note,
  // });

  GraceCueNote._fromNote({
    required super.grace,
    required super.note,
  });

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'grace': XmlQuantifier.required,
    'cue': XmlQuantifier.required,
    'chord': XmlQuantifier.optional,
    'pitch|unpitched|rest': XmlQuantifier.required,
  };
}

class CueNote extends Note {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  /// Positive number specified in division units. This is the intended duration
  /// vs. notated duration (for instance, differences in dotted notes in Baroque-era music).
  /// Differences in duration specific to an interpretation or performance should
  /// be represented using the note element's attack and release attributes.
  /// The duration element moves the musical position when used in backup elements,
  /// forward elements, and note elements that do not contain a chord child element.
  double duration;

  // CueNote({
  //   required this.duration,
  //   required super.form,
  // }) : super._();

  CueNote._fromNote({
    required this.duration,
    required Note note,
  }) : super._(
          // --- Content ---
          chord: note.chord,
          form: note.form,
          instrument: note.instrument,
          editorialVoice: note.editorialVoice,
          type: note.type,
          dots: note.dots,
          accidental: note.accidental,
          timeModification: note.timeModification,
          stem: note.stem,
          notehead: note.notehead,
          noteheadText: note.noteheadText,
          staff: note.staff,
          beams: note.beams,
          notations: note.notations,
          lyrics: note.lyrics,
          play: note.play,
          listen: note.listen,
          // --- Attributes ---
          position: note.position,
          font: note.font,
          color: note.color,
          printout: note.printout,
          printLeger: note.printLeger,
          dynamics: note.dynamics,
          endDynamics: note.endDynamics,
          attack: note.attack,
          release: note.release,
          timeOnly: note.timeOnly,
          pizzicato: note.pizzicato,
          id: note.id,
        );

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'cue': XmlQuantifier.required,
    'chord': XmlQuantifier.optional,
    'pitch|unpitched|rest': XmlQuantifier.required,
    'duration': XmlQuantifier.required,
  };
}

class RegularNote extends Note {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Positive number specified in division units. This is the intended duration
  /// vs. notated duration (for instance, differences in dotted notes in Baroque-era music).
  /// Differences in duration specific to an interpretation or performance should
  /// be represented using the note element's attack and release attributes.
  /// The duration element moves the musical position when used in backup elements,
  /// forward elements, and note elements that do not contain a chord child element.
  final double duration;

  final List<Tie> ties;

  const RegularNote({
    required this.duration,
    this.ties = const [],
    super.chord,
    required super.form,
    super.instrument,
    super.editorialVoice,
    super.type,
    super.dots,
    super.accidental,
    super.timeModification,
    super.stem,
    super.notehead,
    super.noteheadText,
    super.staff,
    super.beams,
    super.notations,
    super.lyrics,
    super.play,
    super.listen,
    super.position,
    super.font,
    super.color,
    super.printout,
    super.printLeger,
    super.dynamics,
    super.endDynamics,
    super.attack,
    super.release,
    super.timeOnly,
    super.pizzicato,
    super.id,
  });

  RegularNote._fromNote({
    required this.duration,
    this.ties = const [],
    required Note note,
  }) : super._(
          // --- Content ---
          chord: note.chord,
          form: note.form,
          instrument: note.instrument,
          editorialVoice: note.editorialVoice,
          type: note.type,
          dots: note.dots,
          accidental: note.accidental,
          timeModification: note.timeModification,
          stem: note.stem,
          notehead: note.notehead,
          noteheadText: note.noteheadText,
          staff: note.staff,
          beams: note.beams,
          notations: note.notations,
          lyrics: note.lyrics,
          play: note.play,
          listen: note.listen,
          // --- Attributes ---
          position: note.position,
          font: note.font,
          color: note.color,
          printout: note.printout,
          printLeger: note.printLeger,
          dynamics: note.dynamics,
          endDynamics: note.endDynamics,
          attack: note.attack,
          release: note.release,
          timeOnly: note.timeOnly,
          pizzicato: note.pizzicato,
          id: note.id,
        );

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'chord': XmlQuantifier.optional,
    'pitch|unpitched|rest': XmlQuantifier.required,
    'duration': XmlQuantifier.required,
    'tie': XmlQuantifier.zeroToTwo,
  };
}

class Pitch implements NoteForm {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The step (pitch class) of this non-traditional key content.
  ///
  /// The step is represented by an instance of the [Step] enum,
  /// which includes values from A to G.
  @override
  final Step step;

  /// The microtonal alteration of the step for this non-traditional key content.
  ///
  /// This is represented as a double, where 1.0 represents a one semitone sharp,
  /// -1.0 represents a one semitone flat, 0.5 represents a quarter tone sharp, etc.
  final double? alter;

  /// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave started by middle C.
  @override
  final int octave;

  const Pitch({
    required this.step,
    this.alter,
    required this.octave,
  });

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'step': XmlQuantifier.required,
    'alter': XmlQuantifier.optional,
    'octave': XmlQuantifier.required,
  };

  factory Pitch.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? stepElement = xmlElement.getElement("step")!;
    validateTextContent(stepElement);
    Step? step = Step.fromString(stepElement.innerText);
    if (step == null) {
      throw MusicXmlTypeException(
        message: '${stepElement.innerText} is not valid step',
        xmlElement: xmlElement,
      );
    }

    XmlElement? alterElement = xmlElement.getElement("alter");
    validateTextContent(alterElement);
    double? alter = double.tryParse(alterElement?.innerText ?? "");
    if (alterElement != null && alter == null) {
      throw MusicXmlFormatException(
        message: '${alterElement.innerText} is not semitones',
        xmlElement: xmlElement,
        source: alterElement.innerText,
      );
    }

    XmlElement? octaveElement = xmlElement.getElement("octave")!;
    validateTextContent(octaveElement);
    int? octave = int.tryParse(octaveElement.innerText);
    if (octave == null || octave < 0 || octave > 9) {
      throw MusicXmlFormatException(
        message: '${octaveElement.innerText} is not valid octave',
        xmlElement: xmlElement,
        source: octaveElement.innerText,
      );
    }

    return Pitch(
      step: step,
      alter: alter,
      octave: octave,
    );
  }
}

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
