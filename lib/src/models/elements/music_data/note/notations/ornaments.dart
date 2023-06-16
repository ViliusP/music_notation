import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/printing.dart';

/// Ornaments can be any of several types, followed optionally by accidentals.
///
/// The accidental-mark element's content is represented the same as an accidental element,
/// but with a different name to reflect the different musical meaning.
class Ornaments {
  String? id;

  final List<Ornament> values;
  final List<AccidentalMark> accidentalMarks;

  Ornaments(this.values, this.accidentalMarks);

  static Ornaments fromXmlElement(XmlElement xmlElement) {
    var ornaments = <Ornament>[];
    for (var child in xmlElement.children) {
      if (child is XmlElement) {
        switch (child.name.local) {
          // case 'trill-mark':
          //   ornaments.add(TrillMark(EmptyTrillSound.fromXmlElement(child)));
          //   break;
          // case 'turn':
          //   ornaments.add(Turn(HorizontalTurn.fromXmlElement(child)));
          //   break;
          // // Repeat for other ornament types...
          // case 'accidental-mark':
          //   ornaments.add(AccidentalMark(AccidentalMark.fromXmlElement(child)));
          //   break;
        }
      }
    }
    return Ornaments(ornaments, []);
  }
}

abstract class Ornament {
  final String name;

  Ornament(this.name);
}

/// The empty-trill-sound type represents an empty element with print-style, placement, and trill-sound attributes.
///
/// ### trill-mark
/// The trill-mark element represents the trill-mark symbol.
///
/// ### vertical-turn
/// The vertical-turn element has the turn symbol shape arranged vertically going from upper left to lower right.
///
/// ### inverted-vertical-turn
/// The inverted-vertical-turn element has the turn symbol shape arranged vertically going from upper right to lower left.
///
/// ### shake
/// The shake element has a similar appearance to an inverted-mordent element.
///
/// ### haydn
/// The haydn element represents the Haydn ornament. This is defined in SMuFL as ornamentHaydn.
class EmptyTrillSound implements Ornament {
  static const availableNames = [
    "trill-mark",
    "vertical-turn",
    "inverted-vertical-turn",
    "shake",
    "haydn"
  ];

  @override
  String name;

  PrintStyle printStyle;

  Placement placement;

  TrillSound trillSound;

  EmptyTrillSound({
    required this.name,
    required this.printStyle,
    required this.placement,
    required this.trillSound,
  });
}

/// The trill-sound attribute group includes attributes used to guide the sound of trills, mordents, turns, shakes, and wavy lines. The default choices are:
/// - start-note = "upper"
/// - trill-step = "whole"
/// - two-note-turn = "none"
/// - accelerate = "no"
/// - beats = "4".
///
/// Second-beat and last-beat are percentages for landing on the indicated beat, with defaults of 25 and 75 respectively.
///
/// For mordent and inverted-mordent elements, the defaults are different:
/// - The default start-note is "main", not "upper".
/// - The default for beats is "3", not "4".
/// - The default for second-beat is "12", not "25".
/// - The default for last-beat is "24", not "75".
class TrillSound {
  StartNote? startNote;
  TrillStep? trillStep;
  TwoNoteTurn? twoNoteTurn;

  bool? accerelate;

  /// The trill-beats type specifies the beats used in a trill-sound or bend-sound attribute group.
  ///
  /// It is a decimal value with a minimum value of 2.
  ///
  /// type of trill beats.
  int? beats;

  /// type of percent.
  double? secondBeat;

  /// type of percent.
  double? lastBeat;
}

/// The start-note type describes the starting note of trills and mordents for playback, relative to the current note.
enum StartNote {
  upper,
  main,
  below;
}

/// The trill-step type describes the alternating note of trills and mordents for playback, relative to the current note.
enum TrillStep {
  whole,
  half,
  unison;
}

/// The two-note-turn type describes the ending notes of trills and mordents for playback, relative to the current note.
enum TwoNoteTurn {
  whole,
  half,
  none;
}

/// The horizontal-turn type represents turn elements that are horizontal rather than vertical.
/// These are empty elements with print-style, placement, trill-sound, and slash attributes.
///
/// If the slash attribute is yes, then a vertical line is used to slash the turn.
/// It is no if not specified.
///
/// ### turn
/// The turn element is the normal turn shape which goes up then down.
///
/// ### delayed-turn
/// The inverted-turn element has the shape which goes down and then up.
///
/// ### delayed-inverted-turn
/// The delayed-inverted-turn element indicates an inverted turn that is delayed until the end of the current note.
class HorizontalTurn extends EmptyTrillSound {
  static const availableNames = [
    "turn",
    "vertical-turn",
    "inverted-vertical-turn",
    "shake",
    "haydn"
  ];

  bool slash = false;

  HorizontalTurn({
    required super.name,
    required super.printStyle,
    required super.placement,
    required super.trillSound,
  });
}

// 	<xs:sequence minOccurs="0" maxOccurs="unbounded">
// 		<xs:choice>

// 			<xs:element name="schleifer" type="empty-placement">
// 				<xs:annotation>
// 					<xs:documentation>The name for this ornament is based on the German, to avoid confusion with the more common slide element defined earlier.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="tremolo" type="tremolo"/>

// 		</xs:choice>
// 		<xs:element name="accidental-mark" type="accidental-mark" minOccurs="0" maxOccurs="unbounded"/>
// 	</xs:sequence>

/// Wavy lines are one way to indicate trills and vibrato.
///
/// When used with a barline element,
/// they should always have type="continue" set.
///
/// The smufl attribute specifies a particular wavy line glyph from the SMuFL Multi-segment lines range.
class WavyLine implements Ornament {
  @override
  String name;

  StartStopContinue type;

  // type="number-level"
  int number;

  // type="smufl-wavy-line-glyph-name"/
  String smufl;

  WavyLine({
    required this.type,
    required this.number,
    required this.smufl,
    required this.name,
  });
}

class EmptyPlacementOrnament extends EmptyPlacement implements Ornament {
  @override
  String name;

  EmptyPlacementOrnament({
    required this.name,
    required super.printStyle,
    required super.placement,
  });
}

/// The empty-placement type represents an empty element with print-style and placement attributes.
class EmptyPlacement {
  PrintStyle printStyle;

  Placement placement;

  EmptyPlacement({
    required this.printStyle,
    required this.placement,
  });
}

/// The mordent type is used for both represents the mordent sign with the vertical line and the inverted-mordent sign without the line.
///
/// The long attribute is "no" by default.
///
/// The approach and departure attributes are used for compound ornaments,
/// indicating how the beginning and ending of the ornament look relative to the main part of the mordent.
///
/// ## inverted-mordent
/// The inverted-mordent element represents the sign without the vertical line.
///
/// The choice of which mordent is inverted differs between MusicXML and SMuFL.
///
/// The long attribute is "no" by default.
class Mordent extends EmptyTrillSound {
  static const availableNames = [
    "mordent",
    "inverted-mordent",
  ];

  bool long = false;

  Placement? approach;

  Placement? deperture;

  Mordent({
    required super.name,
    required super.printStyle,
    required super.placement,
    required super.trillSound,
  });
}

/// The other-placement-text type represents a text element with print-style, placement, and smufl attribute groups.
///
/// This type is used by MusicXML notation extension elements to allow specification of specific SMuFL glyphs without needed to add every glyph as a MusicXML element.
class OtherPlacementText implements Ornament {
  @override
  String name;

  PrintStyle printStyle;

  Placement placement;

  String smulf;

  OtherPlacementText({
    required this.name,
    required this.printStyle,
    required this.placement,
    required this.smulf,
  });
}
