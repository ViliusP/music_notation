import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/time_modification.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The metronome element represents metronome marks and other metric relationships.
///
/// The beat-unit element group and per-minute element specify regular metronome marks.
///
/// The metronome-note and metronome-relation elements allow for the specification of
/// metric modulations and other metric relationships,
/// such as swing tempo marks where two eighths are equated to a quarter note / eighth note triplet.
///
/// Tied notes can be represented in both types of metronome marks by using the beat-unit-tied and metronome-tied elements.
///
/// The print-object attribute is set to no in cases where the metronome element represents
/// a relationship or range that is not displayed in the music notation.
abstract class Metronome {
  PrintStyleAlign printStyleAlign;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  /// Indicates left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  HorizontalAlignment justify;

  /// Indicates whether or not to put the metronome mark in parentheses. It is no if not specified.
  bool parentheses;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Metronome({
    required this.printStyleAlign,
    required this.printObject,
    required this.justify,
    required this.parentheses,
    required this.id,
  });
}

class MetronomeBeatUnit extends Metronome {
  // Assuming BeatUnit, BeatUnitTied, PerMinute are defined somewhere
  BeatUnit beatUnit;

  /// The beat-unit-tied type indicates a beat-unit within a metronome mark that is tied to the preceding beat-unit.
  ///
  /// This allows two or more tied notes to be associated with a per-minute value in a metronome mark,
  /// whereas the metronome-tied element is restricted to metric relationship marks.
  List<BeatUnit> beatUnitTied;
  PerMinute? perMinute;

  // TODO naming
  BeatUnit? beatUnit2;
  List<BeatUnit>? beatUnitTied2;

  MetronomeBeatUnit({
    required this.beatUnit,
    this.beatUnitTied = const [],
    this.perMinute,
    this.beatUnit2,
    this.beatUnitTied2,
    required super.printStyleAlign,
    required super.printObject,
    required super.justify,
    required super.parentheses,
    required super.id,
  });
}

/// The per-minute type can be a number, or a text description including numbers.
///
/// If a font is specified, it overrides the font specified for the overall metronome element.
///
/// This allows separate specification of a music font for the beat-unit and a text font for the numeric value,
/// in cases where a single metronome font is not used.
class PerMinute {
  String value;

  /// Font includes:
  /// - A comma-separated list of font names;
  /// - One of the CSS sizes or a numeric point size.
  /// - Normal or italic style.
  /// - Normal or bold weight.
  Font font;

  PerMinute({
    required this.value,
    required this.font,
  });
}

/// Indicates that metric modulation arrows are displayed on both sides of the metronome mark.
class MetronomeArrows extends Metronome {
  /// If the metronome-arrows element is present,
  ///
  /// it indicates that metric modulation arrows are displayed on both sides of the metronome mark.
  Empty? arrows;
  List<MetronomeNote> note;

  /// The metronome-relation element describes the relationship symbol that goes between the two sets of metronome-note elements.
  ///
  /// The currently allowed value is equals, but this may expand in future versions.
  ///
  /// If the element is empty, the equals value is used.
  String? metronomeRelation;
  List<MetronomeNote>? metronomeRelationNote;

  MetronomeArrows({
    this.arrows,
    required this.note,
    this.metronomeRelation,
    this.metronomeRelationNote,
    required super.printStyleAlign,
    required super.printObject,
    required super.justify,
    required super.parentheses,
    super.id,
  });
}

/// The beat-unit group combines elements used repeatedly in the metronome element to specify a note within a metronome mark.
class BeatUnit {
  /// The beat-unit element indicates the graphical note type to use in a metronome mark.
  NoteTypeValue value;

  NoteTypeValue get beatUnit => value;

  ///  The beat-unit-dot element is used to specify any augmentation dots for a metronome mark note.
  List<Empty> dot = [];

  BeatUnit(
    this.value,
    this.dot,
  );
}

/// The metronome-note type defines the appearance of a note within a metric relationship mark.
class MetronomeNote {
  /// The metronome-type element works like the type element in defining metric relationships.
  NoteTypeValue type;

  /// The metronome-dot element works like the dot element in defining metric relationships.
  List<Empty> dot;

  MetronomeBeam beam;

  /// The metronome-tied indicates the presence of a tie within a metric relationship mark.
  ///
  /// As with the tied element, both the start and stop of the tie should be specified, in this case within separate metronome-note elements.
  StartStop tied;

  MetronomeTuplet tuplet;

  MetronomeNote({
    required this.type,
    required this.dot,
    required this.beam,
    required this.tied,
    required this.tuplet,
  });
}

/// The metronome-beam type works like the beam type in defining metric relationships,
/// but does not include all the attributes available in the beam type.
class MetronomeBeam {
  BeamValue value;
  int number;

  MetronomeBeam({
    required this.value,
    this.number = 1,
  });

  factory MetronomeBeam.factory() {
    return MetronomeBeam(
      value: BeamValue.end,
      number: 2,
    );
  }
}

/// The metronome-tuplet type uses the same element structure as the time-modification element along with some attributes from the tuplet element.
class MetronomeTuplet {
  TimeModification timeModification;

  StartStop type;

  bool bracket;

  ShowTuple showNumber;

  MetronomeTuplet({
    required this.timeModification,
    required this.type,
    required this.bracket,
    required this.showNumber,
  });
}

/// The show-tuplet type indicates whether to show a part of a tuplet relating to the tuplet-actual element,
///
/// both the tuplet-actual and tuplet-normal elements, or neither.
enum ShowTuple {
  actual,
  both,
  none;
}
