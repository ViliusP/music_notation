// <xs:complexType name="pedal">
// 	<xs:annotation>
// 		<xs:documentation>The pedal type represents piano pedal marks, including damper and sostenuto pedal marks. The line attribute is yes if pedal lines are used. The sign attribute is yes if Ped, Sost, and * signs are used. For compatibility with older versions, the sign attribute is yes by default if the line attribute is no, and is no by default if the line attribute is yes. If the sign attribute is set to yes and the type is start or sostenuto, the abbreviated attribute is yes if the short P and S signs are used, and no if the full Ped and Sost signs are used. It is no by default. Otherwise the abbreviated attribute is ignored. The alignment attributes are ignored if the sign attribute is no.</xs:documentation>
// 	</xs:annotation>
// 	<xs:attribute name="type" type="pedal-type" use="required"/>
// 	<xs:attribute name="number" type="number-level"/>
// 	<xs:attribute name="line" type="yes-no"/>
// 	<xs:attribute name="sign" type="yes-no"/>
// 	<xs:attribute name="abbreviated" type="yes-no"/>
// 	<xs:attributeGroup ref="print-style-align"/>
// 	<xs:attributeGroup ref="optional-unique-id"/>
// </xs:complexType>

import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:xml/xml.dart';

/// The pedal type represents piano pedal marks, including damper and sostenuto pedal marks.
///
/// The line attribute is yes if pedal lines are used. The sign attribute is yes if Ped, Sost, and * signs are used.
///
/// For compatibility with older versions,
/// the sign attribute is yes by default if the line attribute is no,
/// and is no by default if the line attribute is yes.
///
/// If the sign attribute is set to yes and the type is start or sostenuto,
/// the abbreviated attribute is yes if the short P and S signs are used,
/// and no if the full Ped and Sost signs are used. It is no by default.
/// Otherwise the abbreviated attribute is ignored.
/// The alignment attributes are ignored if the sign attribute is no.
class Pedal implements DirectionType {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  PedalType type;

  int? number;

  bool? line;

  bool? sign;

  bool? abbrevated;

  PrintStyleAlign printStyleAlign;

  String? id;

  Pedal({
    required this.type,
    this.number,
    this.line,
    this.sign,
    this.abbrevated,
    required this.printStyleAlign,
    this.id,
  });

  factory Pedal.fromXml(XmlElement xmlElement) {
    return Pedal(
      type: PedalType.fromString("") ?? PedalType.sostenuto,
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
    );
  }
}

/// The pedal-type simple type is used to distinguish types of pedal directions.
///
/// The soft pedal is not included here because there is no special symbol or graphic used for it
/// beyond what can be specified with words and bracket elements.
enum PedalType {
  /// Indicates the start of a damper pedal.
  start,

  /// Indicates a pedal lift without a retake.
  stop,

  /// Indicates the start of a sostenuto pedal.
  sostenuto,

  /// Indicates a pedal lift and retake indicated with an inverted V marking.
  ///
  /// Used when the pedal line attribute is yes.
  change,

  /// Allows more precise formatting across system breaks and for more complex pedaling lines.
  ///
  /// Used when the pedal line attribute is yes.
  tContinue,

  /// The discontinue type indicates the end of a pedal line that does not include the explicit lift represented by the stop type.
  discontinue,

  /// The resume type indicates the start of a pedal line that does not include the downstroke represented by the start type.
  ///
  /// It can be used when a line resumes after being discontinued, or to start a pedal line that is preceded by a text or symbol representation of the pedal.
  resume;

  static PedalType? fromString(String value) {
    return null;
  }
}
