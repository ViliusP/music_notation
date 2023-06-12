// <xs:complexType name="octave-shift">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:attribute name="type" type="up-down-stop-continue" use="required"/>
// 	<xs:attribute name="number" type="number-level"/>
// 	<xs:attribute name="size" type="xs:positiveInteger" default="8"/>
// 	<xs:attributeGroup ref="dashed-formatting"/>
// 	<xs:attributeGroup ref="print-style"/>
// 	<xs:attributeGroup ref="optional-unique-id"/>
// </xs:complexType>

import 'package:music_notation/models/data_types/start_stop.dart';
import 'package:music_notation/models/elements/music_data/direction/direction_type.dart';
import 'package:music_notation/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/models/printing.dart';

/// The octave shift type indicates where notes are shifted up or down from
///
/// their true pitched values because of printing difficulty.
///
/// Thus a treble clef line noted with 8va will be indicated with an octave-shift
/// down from the pitch data indicated in the notes.
///
/// A size of 8 indicates one octave; a size of 15 indicates two octaves.
class OctaveShift implements DirectionType {
  /// Indicates if this is the start, stop, or continuation of the octave shift.
  ///
  /// The start is specified as a shift up or down from their performed values
  UpDownStopContinue type;

  /// Distinguishes multiple octave shifts when they overlap in MusicXML document order.
  int number;

  /// 8 indicates one octave; 15 indicates two octaves; 22 indicates 3 octaves. The default value is 8.
  int size;

  DashedFormatting dashedFormatting;

  PrintStyle printStyle;

  /// Specifies an ID that is unique to the entire document.
  String id;

  OctaveShift({
    required this.type,
    required this.number,
    required this.size,
    required this.dashedFormatting,
    required this.printStyle,
    required this.id,
  });
}
