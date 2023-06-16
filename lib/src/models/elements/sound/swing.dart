// 	<xs:complexType name="swing">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:choice>
// 				<xs:element name="straight" type="empty"/>
// 				<xs:sequence>
// 					<xs:element name="first" type="xs:positiveInteger"/>
// 					<xs:element name="second" type="xs:positiveInteger"/>
// 					<xs:element name="swing-type" type="swing-type-value" minOccurs="0"/>
// 				</xs:sequence>
// 			</xs:choice>
// 			<xs:element name="swing-style" type="xs:string" minOccurs="0"/>
// 		</xs:sequence>
// 	</xs:complexType>

/// The swing element specifies whether or not to use swing playback,
/// where consecutive on-beat / off-beat eighth or 16th notes are played with unequal nominal durations.
///
/// The straight element specifies that no swing is present,
/// so consecutive notes have equal durations.
///
/// The first and second elements are positive integers that specify the ratio
/// between durations of consecutive notes. For example,
/// a first element with a value of 2 and a second element with a value of 1
/// applied to eighth notes specifies a quarter note / eighth note tuplet playback,
/// where the first note is twice as long as the second note.
///
/// Ratios should be specified with the smallest integers possible.
/// For example, a ratio of 6 to 4 should be specified as 3 to 2 instead.
///
/// The optional swing-type element specifies the note type,
/// either eighth or 16th, to which the ratio is applied.
/// The value is eighth if this element is not present.
///
/// The optional swing-style element is a string describing the style of swing used.
///
/// The swing element has no effect for playback of grace notes,
/// notes where a type element is not present,
/// and notes where the specified duration is different than the nominal value associated with the specified type.
/// If a swung note has attack and release attributes, those values modify the swung playback.
abstract class Swing {
  String? style;

  Swing({
    required this.style,
  });
}

class StraightSwing extends Swing {
  StraightSwing({
    required super.style,
  });
}

class TypedSwing extends Swing {
  int first;

  int second;

  SwingTypeValue? type;

  TypedSwing({
    required this.first,
    required this.second,
    required this.type,
    super.style,
  });
}

/// The swing-type-value type specifies the note type, either eighth or 16th,
/// to which the ratio defined in the swing element is applied.
enum SwingTypeValue {
  n16th,
  eighth,
}
