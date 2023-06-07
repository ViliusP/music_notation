// 	<xs:complexType name="tremolo">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:simpleContent>
// 			<xs:extension base="tremolo-marks">
// 				<xs:attribute name="type" type="tremolo-type" default="single"/>
// 				<xs:attributeGroup ref="print-style"/>
// 				<xs:attributeGroup ref="placement"/>
// 				<xs:attributeGroup ref="smufl"/>
// 			</xs:extension>
// 		</xs:simpleContent>
// 	</xs:complexType>

import 'package:music_notation/models/elements/music_data/note/notations/ornaments.dart';

/// The tremolo ornament can be used to indicate single-note, double-note, or unmeasured tremolos.
///
/// Single-note tremolos use the single type, double-note tremolos use the start and stop types,
/// and unmeasured tremolos use the unmeasured type. The default is "single" for compatibility with Version 1.1.
///
/// The text of the element indicates the number of tremolo marks and is an integer from 0 to 8.
/// Note that the number of attached beams is not included in this value, but is represented separately using the beam element.
/// The value should be 0 for unmeasured tremolos.
///
/// When using double-note tremolos, the duration of each note in the tremolo should correspond to half of the notated type value.
///
/// A time-modification element should also be added with an actual-notes value of 2 and a normal-notes value of 1.
///
/// If used within a tuplet, this 2/1 ratio should be multiplied by the existing tuplet ratio.
///
/// The smufl attribute specifies the glyph to use from the SMuFL Tremolos range for an unmeasured tremolo.
/// It is ignored for other tremolo types.
/// The SMuFL buzzRoll glyph is used by default if the attribute is missing.
///
/// Using repeater beams for indicating tremolos is deprecated as of MusicXML 3.0.
class Tremolo extends OtherPlacementText {
  /// The number of tremolo marks is represented by a number from 0 to 8: the same as beam-level with 0 added.
  ///
  /// min 0; max 8;
  int marks;

  @override
  String get name => "tremolo";

  TremoloType value = TremoloType.single;

  Tremolo({
    required this.marks,
    required super.printStyle,
    required super.placement,
    required super.smulf,
    required super.name,
  });
}

/// The tremolo-type is used to distinguish double-note, single-note, and unmeasured tremolos.
enum TremoloType {
  start,
  stop,
  single,
  unmeasured;
}
