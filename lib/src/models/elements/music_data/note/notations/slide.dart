import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';

/// Glissando and slide types both indicate rapidly moving from one pitch to the other so that individual notes are not discerned.
///
/// A slide is continuous between the two pitches and defaults to a solid line.
///
/// The optional text for a is printed alongside the line.
class Slide {
  /// Text that is printed alongside the line.
  String? text;

  StartStop type;

  ///	Distinguishes multiple glissandos when they overlap in MusicXML document order.
  /// The default value is 1.
  int number = 1;

  /// Indicates the color of an element.
  Color color;

  /// Specifies if the line is solid, dashed, dotted, or wavy.
  LineType? lineType;

  DashedFormatting dashedFormatting;

  PrintStyle printStyle;

  BendSound bendSound;

  String? id;

  Slide({
    this.text,
    required this.type,
    required this.number,
    required this.color,
    this.lineType,
    required this.dashedFormatting,
    required this.printStyle,
    required this.bendSound,
    required this.id,
  });
}

/// The bend-sound type is used for bend and slide elements, and is similar to the trill-sound attribute group.
///
/// Here the beats element refers to the number of discrete elements (like MIDI pitch bends) used to represent a continuous bend or slide.
///
/// The first-beat indicates the percentage of the duration for starting a bend; the last-beat the percentage for ending it.
///
/// The default choices are:
/// - accelerate = "no"
/// - beats = "4"
/// - first-beat = "25"
/// - last-beat = "75"
class BendSound {
  /// Does the bend accelerate during playback?
  ///
  /// Default is "no".
  bool accelerate;

  /// The trill-beats type specifies the beats used in a trill-sound or bend-sound attribute group.
  ///
  /// It is a decimal value with a minimum value of 2.
  ///
  /// Default is 4.
  double beats;

  /// The percentage of the duration for starting a bend.
  ///
  /// Default is 25.
  double firstBeat;

  /// The percentage of the duration for ending a bend.
  ///
  /// Default is 75.
  double lastBeat;

  BendSound({
    required this.accelerate,
    required this.beats,
    required this.firstBeat,
    required this.lastBeat,
  });

  BendSound.defaultChoices()
      : accelerate = false,
        beats = 4,
        firstBeat = 25,
        lastBeat = 25;
}
