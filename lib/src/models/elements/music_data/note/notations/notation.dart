import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:xml/xml.dart';

abstract class Notation {}

/// Notations refer to musical notations, not XML notations.
///
/// Multiple notations are allowed in order to represent multiple editorial levels.
///
/// The print-object attribute, added in Version 3.0, allows notations to represent details of performance technique, such as fingerings, without having them appear in the score.
class Notations {
  String? id;

  List<Notation> notations;

  Editorial editorial;

  bool printObject;

  Notations({
    this.id,
    required this.notations,
    required this.editorial,
    this.printObject = true,
  });

  factory Notations.fromXml(XmlElement xmlElement) {
    return Notations(
      id: "",
      notations: [],
      editorial: Editorial.fromXml(xmlElement),
      printObject: true,
    );
  }
}

/// The bezier attribute group is used to indicate the curvature of slurs and ties,
/// representing the control points for a cubic bezier curve.
/// For ties, the bezier attribute group is used with the tied element.
///
/// Normal slurs, S-shaped slurs, and ties need only two bezier points:
/// one associated with the start of the slur or tie, the other with the stop.
/// Complex slurs and slurs divided over system breaks can specify additional bezier data at slur elements with a continue type.
///
/// The bezier-x, bezier-y, and bezier-offset attributes describe the outgoing bezier point for slurs and ties with a start type,
/// and the incoming bezier point for slurs and ties with types of stop or continue.
/// The bezier-x2, bezier-y2, and bezier-offset2 attributes are only valid with slurs of type continue, and describe the outgoing bezier point.
///
/// The bezier-x, bezier-y, bezier-x2, and bezier-y2 attributes are specified in tenths,
/// relative to any position settings associated with the slur or tied element.
/// The bezier-offset and bezier-offset2 attributes are measured in terms of musical divisions, like the offset element.
///
/// The bezier-offset and bezier-offset2 attributes are deprecated as of MusicXML 3.1.
/// If both the bezier-x and bezier-offset attributes are present,
/// the bezier-x attribute takes priority.
///
/// Similarly, the bezier-x2 attribute takes priority over the bezier-offset2 attribute.
/// The two types of bezier attributes are not additive.
// TODO update comments.
class Bezier {
  /// The horizontal position of an outgoing bezier point for slurs and ties with a start type,
  /// or of an incoming bezier point for slurs and ties with types of stop or continue.
  ///
  /// Type="tenths".
  double? x;

  /// The vertical position of an outgoing bezier point for slurs and ties with a start type,
  /// or of an incoming bezier point for slurs and ties with types of stop or continue.
  ///
  /// Type="tenths".
  double? y;

  /// The horizontal position of an outgoing bezier point for slurs with a continue type.
  /// Not valid for other types.
  ///
  /// Type="tenths".
  double? x2;

  /// The vertical position of an outgoing bezier point for slurs with a continue type.
  /// Not valid for other types.
  ///
  /// Type="tenths".
  double? y2;

  /// The horizontal position of an outgoing bezier point for slurs and ties with a start type,
  /// or of an incoming bezier point for slurs and ties with types of stop or continue.
  ///
  /// If both the [x] and [offset] attributes are present, the [x] attribute takes priority.
  ///
  /// This attribute is deprecated as of MusicXML 3.1.
  ///
  /// Type="divisions".
  double? offset;

  /// The horizontal position of an outgoing bezier point for slurs with a continue type.
  /// Not valid for other types.
  ///
  /// If both the [x2] and [offset2] attributes are present, the [x2] attribute takes priority.
  ///
  /// This attribute is deprecated as of MusicXML 3.1.
  ///
  /// Type="divisions".
  double? offset2;

  Bezier({
    required this.x,
    required this.y,
    required this.x2,
    required this.y2,
    required this.offset,
    required this.offset2,
  });
}

/// Technical indications give performance information for individual instruments.
class Technical {
  // 	<xs:complexType name="technical">
  // 	<xs:choice minOccurs="0" maxOccurs="unbounded">
  // 		<xs:element name="up-bow" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The up-bow element represents the symbol that is used both for up-bowing on bowed instruments, and up-stroke on plucked instruments.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="down-bow" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The down-bow element represents the symbol that is used both for down-bowing on bowed instruments, and down-stroke on plucked instruments.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="harmonic" type="harmonic"/>
  // 		<xs:element name="open-string" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The open-string element represents the zero-shaped open string symbol.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="thumb-position" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The thumb-position element represents the thumb position symbol. This is a circle with a line, where the line does not come within the circle. It is distinct from the snap pizzicato symbol, where the line comes inside the circle.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="fingering" type="fingering"/>
  // 		<xs:element name="pluck" type="placement-text">
  // 			<xs:annotation>
  // 				<xs:documentation>The pluck element is used to specify the plucking fingering on a fretted instrument, where the fingering element refers to the fretting fingering. Typical values are p, i, m, a for pulgar/thumb, indicio/index, medio/middle, and anular/ring fingers.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="double-tongue" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The double-tongue element represents the double tongue symbol (two dots arranged horizontally).</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="triple-tongue" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The triple-tongue element represents the triple tongue symbol (three dots arranged horizontally).</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="stopped" type="empty-placement-smufl">
  // 			<xs:annotation>
  // 				<xs:documentation>The stopped element represents the stopped symbol, which looks like a plus sign. The smufl attribute distinguishes different SMuFL glyphs that have a similar appearance such as handbellsMalletBellSuspended and guitarClosePedal. If not present, the default glyph is brassMuteClosed.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="snap-pizzicato" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The snap-pizzicato element represents the snap pizzicato symbol. This is a circle with a line, where the line comes inside the circle. It is distinct from the thumb-position symbol, where the line does not come inside the circle.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="fret" type="fret"/>
  // 		<xs:element name="string" type="string"/>
  // 		<xs:element name="hammer-on" type="hammer-on-pull-off"/>
  // 		<xs:element name="pull-off" type="hammer-on-pull-off"/>
  // 		<xs:element name="bend" type="bend"/>
  // 		<xs:element name="tap" type="tap"/>
  // 		<xs:element name="heel" type="heel-toe"/>
  // 		<xs:element name="toe" type="heel-toe"/>
  // 		<xs:element name="fingernails" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The fingernails element is used in notation for harp and other plucked string instruments.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="hole" type="hole"/>
  // 		<xs:element name="arrow" type="arrow"/>
  // 		<xs:element name="handbell" type="handbell"/>
  // 		<xs:element name="brass-bend" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The brass-bend element represents the u-shaped bend symbol used in brass notation, distinct from the bend element used in guitar music.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="flip" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The flip element represents the flip symbol used in brass notation.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="smear" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The smear element represents the tilde-shaped smear symbol used in brass notation.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="open" type="empty-placement-smufl">
  // 			<xs:annotation>
  // 				<xs:documentation>The open element represents the open symbol, which looks like a circle. The smufl attribute can be used to distinguish different SMuFL glyphs that have a similar appearance such as brassMuteOpen and guitarOpenPedal. If not present, the default glyph is brassMuteOpen.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="half-muted" type="empty-placement-smufl">
  // 			<xs:annotation>
  // 				<xs:documentation>The half-muted element represents the half-muted symbol, which looks like a circle with a plus sign inside. The smufl attribute can be used to distinguish different SMuFL glyphs that have a similar appearance such as brassMuteHalfClosed and guitarHalfOpenPedal. If not present, the default glyph is brassMuteHalfClosed.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="harmon-mute" type="harmon-mute"/>
  // 		<xs:element name="golpe" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The golpe element represents the golpe symbol that is used for tapping the pick guard in guitar music.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="other-technical" type="other-placement-text">
  // 			<xs:annotation>
  // 				<xs:documentation>The other-technical element is used to define any technical indications not yet in the MusicXML format. The smufl attribute can be used to specify a particular glyph, allowing application interoperability without requiring every SMuFL technical indication to have a MusicXML element equivalent. Using the other-technical element without the smufl attribute allows for extended representation, though without application interoperability.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 	</xs:choice>
  // 	<xs:attributeGroup ref="optional-unique-id"/>
  // </xs:complexType>
}

/// Articulations and accents are grouped together here.
class Articulations {
  // 	<xs:complexType name="articulations">
  // 	<xs:annotation>
  // 		<xs:documentation>Articulations and accents are grouped together here.</xs:documentation>
  // 	</xs:annotation>
  // 	<xs:choice minOccurs="0" maxOccurs="unbounded">
  // 		<xs:element name="accent" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The accent element indicates a regular horizontal accent mark.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="strong-accent" type="strong-accent">
  // 			<xs:annotation>
  // 				<xs:documentation>The strong-accent element indicates a vertical accent mark.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="staccato" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The staccato element is used for a dot articulation, as opposed to a stroke or a wedge.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="tenuto" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The tenuto element indicates a tenuto line symbol.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="detached-legato" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The detached-legato element indicates the combination of a tenuto line and staccato dot symbol.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="staccatissimo" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The staccatissimo element is used for a wedge articulation, as opposed to a dot or a stroke.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="spiccato" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The spiccato element is used for a stroke articulation, as opposed to a dot or a wedge.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="scoop" type="empty-line">
  // 			<xs:annotation>
  // 				<xs:documentation>The scoop element is an indeterminate slide attached to a single note. The scoop appears before the main note and comes from below the main pitch.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="plop" type="empty-line">
  // 			<xs:annotation>
  // 				<xs:documentation>The plop element is an indeterminate slide attached to a single note. The plop appears before the main note and comes from above the main pitch.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="doit" type="empty-line">
  // 			<xs:annotation>
  // 				<xs:documentation>The doit element is an indeterminate slide attached to a single note. The doit appears after the main note and goes above the main pitch.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="falloff" type="empty-line">
  // 			<xs:annotation>
  // 				<xs:documentation>The falloff element is an indeterminate slide attached to a single note. The falloff appears after the main note and goes below the main pitch.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="breath-mark" type="breath-mark"/>
  // 		<xs:element name="caesura" type="caesura"/>
  // 		<xs:element name="stress" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The stress element indicates a stressed note.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="unstress" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The unstress element indicates an unstressed note. It is often notated using a u-shaped symbol.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="soft-accent" type="empty-placement">
  // 			<xs:annotation>
  // 				<xs:documentation>The soft-accent element indicates a soft accent that is not as heavy as a normal accent. It is often notated as &lt;&gt;. It can be combined with other articulations to implement the first eight symbols in the SMuFL Articulation supplement range.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 		<xs:element name="other-articulation" type="other-placement-text">
  // 			<xs:annotation>
  // 				<xs:documentation>The other-articulation element is used to define any articulations not yet in the MusicXML format. The smufl attribute can be used to specify a particular articulation, allowing application interoperability without requiring every SMuFL articulation to have a MusicXML element equivalent. Using the other-articulation element without the smufl attribute allows for extended representation, though without application interoperability.</xs:documentation>
  // 			</xs:annotation>
  // 		</xs:element>
  // 	</xs:choice>
  // 	<xs:attributeGroup ref="optional-unique-id"/>
  // </xs:complexType>
}

/// Dynamics can be associated either with a note or a general musical direction.
/// To avoid inconsistencies between and amongst the letter abbreviations for dynamics (what is sf vs. sfz, standing alone or with a trailing dynamic that is not always piano),
/// we use the actual letters as the names of these dynamic elements.
/// The other-dynamics element allows other dynamic marks that are not covered here.
/// Dynamics elements may also be combined to create marks not covered by a single element, such as sfmp.
///
/// These letter dynamic symbols are separated from crescendo, decrescendo, and wedge indications. Dynamic representation is inconsistent in scores.
/// Many things are assumed by the composer and left out, such as returns to original dynamics.
/// The MusicXML format captures what is in the score, but does not try to be optimal for analysis or synthesis of dynamics.
///
/// The placement attribute is used when the dynamics are associated with a note.
/// It is ignored when the dynamics are associated with a direction.
/// In that case the direction element's placement attribute is used instead.
class Dynamics {
//  <xs:complexType name="dynamics">
// 		<xs:choice minOccurs="0" maxOccurs="unbounded">
// 			<xs:element name="p" type="empty"/>
// 			<xs:element name="pp" type="empty"/>
// 			<xs:element name="ppp" type="empty"/>
// 			<xs:element name="pppp" type="empty"/>
// 			<xs:element name="ppppp" type="empty"/>
// 			<xs:element name="pppppp" type="empty"/>
// 			<xs:element name="f" type="empty"/>
// 			<xs:element name="ff" type="empty"/>
// 			<xs:element name="fff" type="empty"/>
// 			<xs:element name="ffff" type="empty"/>
// 			<xs:element name="fffff" type="empty"/>
// 			<xs:element name="ffffff" type="empty"/>
// 			<xs:element name="mp" type="empty"/>
// 			<xs:element name="mf" type="empty"/>
// 			<xs:element name="sf" type="empty"/>
// 			<xs:element name="sfp" type="empty"/>
// 			<xs:element name="sfpp" type="empty"/>
// 			<xs:element name="fp" type="empty"/>
// 			<xs:element name="rf" type="empty"/>
// 			<xs:element name="rfz" type="empty"/>
// 			<xs:element name="sfz" type="empty"/>
// 			<xs:element name="sffz" type="empty"/>
// 			<xs:element name="fz" type="empty"/>
// 			<xs:element name="n" type="empty"/>
// 			<xs:element name="pf" type="empty"/>
// 			<xs:element name="sfzp" type="empty"/>
// 			<xs:element name="other-dynamics" type="other-text"/>
// 		</xs:choice>
// 		<xs:attributeGroup ref="print-style-align"/>
// 		<xs:attributeGroup ref="placement"/>
// 		<xs:attributeGroup ref="text-decoration"/>
// 		<xs:attributeGroup ref="enclosure"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>
}

/// The fermata text content represents the shape of the fermata sign.
///
/// An empty fermata element represents a normal fermata.
///
/// The fermata type is upright if not specified.
class Fermata {
/*   	<xs:complexType name="fermata">
		<xs:annotation>
			<xs:documentation></xs:documentation>
		</xs:annotation>
		<xs:simpleContent>
			<xs:extension base="fermata-shape">
				<xs:attribute name="type" type="upright-inverted"/>
				<xs:attributeGroup ref="print-style"/>
				<xs:attributeGroup ref="optional-unique-id"/>
			</xs:extension>
		</xs:simpleContent>
	</xs:complexType> */
}

/// The arpeggiate type indicates that this note is part of an arpeggiated chord.
///
/// The number attribute can be used to distinguish between two simultaneous chords arpeggiated separately (different numbers) or together (same number).
/// The direction attribute is used if there is an arrow on the arpeggio sign. By default, arpeggios go from the lowest to highest note.
/// The length of the sign can be determined from the position attributes for the arpeggiate elements used with the top and bottom notes of the arpeggiated chord.
///
/// If the unbroken attribute is set to yes, it indicates that the arpeggio continues onto another staff within the part.
///
/// This serves as a hint to applications and is not required for cross-staff arpeggios.
class Arpeggiate {
  // 	<xs:complexType name="arpeggiate">

  // 	<xs:attribute name="number" type="number-level"/>
  // 	<xs:attribute name="direction" type="up-down"/>
  // 	<xs:attribute name="unbroken" type="yes-no"/>
  // 	<xs:attributeGroup ref="position"/>
  // 	<xs:attributeGroup ref="placement"/>
  // 	<xs:attributeGroup ref="color"/>
  // 	<xs:attributeGroup ref="optional-unique-id"/>
  // </xs:complexType>
}

/// The non-arpeggiate type indicates that this note is at the top or bottom of a bracket indicating to not arpeggiate these notes.
///
/// Since this does not involve playback, it is only used on the top or bottom notes, not on each note as for the arpeggiate type.
class NonArpeggiate {
  // <xs:complexType name="non-arpeggiate">
  // 	<xs:attribute name="type" type="top-bottom" use="required"/>
  // 	<xs:attribute name="number" type="number-level"/>
  // 	<xs:attributeGroup ref="position"/>
  // 	<xs:attributeGroup ref="placement"/>
  // 	<xs:attributeGroup ref="color"/>
  // 	<xs:attributeGroup ref="optional-unique-id"/>
  // </xs:complexType>
}

/// An accidental-mark can be used as a separate notation or as part of an ornament.
///
/// When used in an ornament, position and placement are relative to the ornament, not relative to the note.
class AccidentalMark {
  // <xs:complexType name="accidental-mark">
  // 	<xs:simpleContent>
  // 		<xs:extension base="accidental-value">
  // 			<xs:attributeGroup ref="level-display"/>
  // 			<xs:attributeGroup ref="print-style"/>
  // 			<xs:attributeGroup ref="placement"/>
  // 			<xs:attribute name="smufl" type="smufl-accidental-glyph-name"/>
  // 			<xs:attributeGroup ref="optional-unique-id"/>
  // 		</xs:extension>
  // 	</xs:simpleContent>
  // </xs:complexType>
}

/// The other-notation type is used to define any notations not yet in the MusicXML format.
///
/// It handles notations where more specific extension elements such as other-dynamics and other-technical are not appropriate.
///
/// The smufl attribute can be used to specify a particular notation,
/// allowing application interoperability without requiring every SMuFL glyph to have a MusicXML element equivalent.
///
/// Using the other-notation type without the smufl attribute allows for extended representation, though without application interoperability.
class OtherNotation {
  // 	<xs:complexType name="other-notation">
  // 	<xs:annotation>
  // 		<xs:documentation></xs:documentation>
  // 	</xs:annotation>
  // 	<xs:simpleContent>
  // 		<xs:extension base="xs:string">
  // 			<xs:attribute name="type" type="start-stop-single" use="required"/>
  // 			<xs:attribute name="number" type="number-level" default="1"/>
  // 			<xs:attributeGroup ref="print-object"/>
  // 			<xs:attributeGroup ref="print-style"/>
  // 			<xs:attributeGroup ref="placement"/>
  // 			<xs:attributeGroup ref="smufl"/>
  // 			<xs:attributeGroup ref="optional-unique-id"/>
  // 		</xs:extension>
  // 	</xs:simpleContent>
  // </xs:complexType>
}
