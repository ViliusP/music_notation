import 'package:music_notation/src/models/data_types/left_right.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/fingering.dart';
import 'package:music_notation/src/models/elements/fret.dart';
import 'package:music_notation/src/models/elements/music_data/direction/image.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';

/// The frame type represents a frame or fretboard diagram used together with a chord symbol.
///
/// The representation is based on the NIFF guitar grid with additional information.
///
/// The frame type's unplayed attribute indicates what to display above a string that has no associated frame-note element.
///
/// Typical values are x and the empty string.
///
/// If the attribute is not present, the display of the unplayed string is application-defined.
class Frame {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The frame-strings element gives the overall size of the frame in vertical lines (strings).
  int frameStrings;

  /// The frame-frets element gives the overall size of the frame in horizontal spaces (frets).
  int frameFrets;

  FirstFret? firstFret;

  List<FrameNote> frameNotes;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  Position position;

  /// Indicates the color of an element.
  Color? color;

  HorizontalAlignment? horizontalAlignment;

  /// Indicates vertical alignment to the top, middle, or bottom of the image.
  ///
  /// The default is implementation-dependent.
  VerticalImageAlignment? verticalAlignment;

  double? height;

  double? width;

  String? unplayed;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Frame({
    required this.frameStrings,
    required this.frameFrets,
    this.firstFret,
    required this.frameNotes,
    required this.position,
    this.color,
    this.horizontalAlignment,
    this.verticalAlignment,
    this.height,
    this.width,
    this.unplayed,
    this.id,
  });
}

/// The first-fret type indicates which fret is shown in the top space of the frame;
/// it is fret 1 if the element is not present.
///
/// The optional text attribute indicates how this is represented in the fret diagram,
/// while the location attribute indicates whether the text appears to the left or right of the frame.
class FirstFret {
  int value;

  String? text;

  LeftRight? location;

  FirstFret({
    required this.value,
    this.text,
    this.location,
  });
}

/// The frame-note type represents each note included in the frame.
///
/// An open string will have a fret value of 0,
/// while a muted string will not be associated with a frame-note element.
class FrameNote {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  FrameString frameString;

  Fret fret;

  Fingering? fingering;

  Barre? barre;

  FrameNote({
    required this.frameString,
    required this.fret,
    this.fingering,
    this.barre,
  });
}

/// The barre element indicates placing a finger over multiple strings on a single fret.
///
///  The type is "start" for the lowest pitched string
/// (e.g., the string with the highest MusicXML number)
/// and is "stop" for the highest pitched string.
///
/// Always empty.
class Barre {
  /// The start value indicates the lowest pitched string
  /// (e.g., the string with the highest MusicXML number).
  /// The stop value indicates the highest pitched string.
  StartStop type;

  /// Indicates the color of an element.
  Color color;

  Barre({
    required this.type,
    required this.color,
  });
}

/// The string type is used with tablature notation,
/// regular notation (where it is often circled), and chord diagrams.
///
/// String numbers start with 1 for the highest pitched full-length string.
class FrameString {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The string-number type indicates a string number.
  ///
  /// Strings are numbered from high to low, with 1 being the highest pitched full-length string.
  int stringNumber;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement placement;

  /// Indicates the color of an element.
  PrintStyle printStyle;

  FrameString({
    required this.stringNumber,
    required this.placement,
    required this.printStyle,
  });
}
