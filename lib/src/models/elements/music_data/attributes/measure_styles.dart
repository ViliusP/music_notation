import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:xml/xml.dart';

/// A measure-style indicates a special way to print partial to multiple measures within a part.
///
/// This includes multiple rests over several measures,
/// repeats of beats, single, or multiple measures, and use of slash notation.
///
/// The multiple-rest and measure-repeat elements indicate the number of measures
/// covered in the element content. The beat-repeat and slash elements can cover partial measures.
///
/// All but the multiple-rest element use a type attribute to indicate starting
/// and stopping the use of the style.
///
/// The optional number attribute specifies the staff number from top to bottom on the system, as with clef.
abstract class MeasureStyle {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a measure style to apply to only the specified staff in the part.
  /// If absent, the measure style applies to all staves in the part.
  int? number;

  /// Font includes:
  /// - A comma-separated list of font names;
  /// - One of the CSS sizes or a numeric point size.
  /// - Normal or italic style.
  /// - Normal or bold weight.
  Font font;

  /// Indicates the color of an element.
  Color color;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  MeasureStyle({
    this.number,
    this.font = const Font.empty(),
    this.color = const Color.empty(),
    this.id,
  });

  factory MeasureStyle.fromXml(XmlElement xmlElement) {
    return MultipleRest(value: 1);
  }
}

/// The text of the multiple-rest type indicates the number of measures in the multiple rest.
class MultipleRest extends MeasureStyle {
  int value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies whether the multiple rests uses
  /// the 1-bar / 2-bar / 4-bar rest symbols, or a single shape.
  ///
  /// It is no if not specified.
  bool useSymbols;

  MultipleRest({
    required this.value,
    this.useSymbols = false,
    super.font,
    super.color,
  });
}

/// The measure-repeat type is used for both single and multiple measure repeats.
/// The text of the element indicates the number of measures to be repeated in a single pattern.
/// The slashes attribute specifies the number of slashes to use in the repeat sign.
/// It is 1 if not specified. The text of the element is ignored when the type is stop.
///
/// The stop type indicates the first measure where the repeats are no longer displayed.
/// Both the start and the stop of the measure-repeat should be specified
/// unless the repeats are displayed through the end of the part.
///
/// The measure-repeat element specifies a notation style for repetitions.
/// The actual music being repeated needs to be repeated within each measure of the MusicXML file.
/// This element specifies the notation that indicates the repeat.
class MeasureRepeat extends MeasureStyle {
  int value;

  /// Indicates the starting or stopping point of the section displaying the measure repeat symbols.
  StartStop type;

  /// Specifies the number of slashes to use in the symbol. The value is 1 if not specified.
  int slashes;

  MeasureRepeat({
    required this.value,
    required this.type,
    this.slashes = 1,
    required super.font,
    required super.color,
  });
}

/// The beat-repeat type is used to indicate that a single beat (but possibly many notes) is repeated.
///
/// The slashes attribute specifies the number of slashes to use in the symbol.
///
/// The use-dots attribute indicates whether or not to use dots as well
/// (for instance, with mixed rhythm patterns).
///
/// The value for slashes is 1 and the value for use-dots is no if not specified.
///
/// The stop type indicates the first beat where the repeats are no longer displayed.
/// Both the start and stop of the beat being repeated should be specified
/// unless the repeats are displayed through the end of the part.
///
/// The beat-repeat element specifies a notation style for repetitions.
/// The actual music being repeated needs to be repeated within the MusicXML file.
///
/// This element specifies the notation that indicates the repeat.
class BeatRepeat extends MeasureStyle {
  /// The slash-type element indicates the graphical note type to use for the display of repetition marks.
  NoteTypeValue? slashType;

  /// The slash-dot element is used to specify any augmentation dots in the note type used to display repetition marks.
  List<Empty> slashDots;

  /// The except-voice element is used to specify a combination of slash notation and regular notation.
  ///
  /// Any note elements that are in voices specified by the except-voice elements are displayed in normal notation,
  /// in addition to the slash notation that is always displayed.
  List<String> exceptVoices;

  /// Indicates the starting or stopping point of the section displaying the beat repeat symbols.
  StartStop type;

  /// Specifies the number of slashes to use in the symbol. The value is 1 if not specified.
  int slashes;

  /// Indicates whether or not to use dots as well (for instance, with mixed rhythm patterns).
  ///
  /// The value is no if not specified.
  bool useDots;

  BeatRepeat({
    this.slashType,
    required this.slashDots,
    required this.exceptVoices,
    required this.type,
    this.slashes = 4,
    this.useDots = false,
    required super.font,
    required super.color,
  });
}

/// The slash type is used to indicate that slash notation is to be used.
///
/// If the slash is on every beat, use-stems is no (the default).
///
/// To indicate rhythms but not pitches, use-stems is set to yes.
///
/// The type attribute indicates whether this is the start or stop of a slash notation style.
///
/// The use-dots attribute works as for the beat-repeat element, and only has effect if use-stems is no.
class Slash extends MeasureStyle {
  /// The slash-type element indicates the graphical note type to use for the display of repetition marks.
  NoteTypeValue? slashType;

  /// The slash-dot element is used to specify any augmentation dots in the note type used to display repetition marks.
  List<Empty> slashDots;

  /// The except-voice element is used to specify a combination of slash notation and regular notation.
  ///
  /// Any note elements that are in voices specified by the except-voice elements are displayed in normal notation,
  /// in addition to the slash notation that is always displayed.
  List<String> exceptVoices;

  /// Indicates the starting or stopping point of the section displaying the beat repeat symbols.
  StartStop type;

  /// Indicates whether or not to use dots as well (for instance, with mixed rhythm patterns).
  ///
  /// The value is no if not specified. This attribute only has effect if use-stems is no.
  bool useDots;

  /// If the slash is on every beat, use-stems is no (the default).
  ///
  /// To indicate rhythms but not pitches, use-stems is set to yes.
  bool useStems;

  Slash({
    this.slashType,
    required this.slashDots,
    required this.exceptVoices,
    required this.type,
    this.useDots = false,
    required this.useStems,
    required super.font,
    required super.color,
  });
}
