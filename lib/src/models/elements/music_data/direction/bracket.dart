// <xs:complexType name="bracket">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:attribute name="type" type="start-stop-continue" use="required"/>
// 	<xs:attribute name="number" type="number-level"/>
// 	<xs:attribute name="line-end" type="line-end" use="required"/>
// 	<xs:attribute name="end-length" type="tenths"/>
// 	<xs:attributeGroup ref="line-type"/>
// 	<xs:attributeGroup ref="dashed-formatting"/>
// 	<xs:attributeGroup ref="position"/>
// 	<xs:attributeGroup ref="color"/>
// 	<xs:attributeGroup ref="optional-unique-id"/>
// </xs:complexType>

import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';
import 'package:xml/xml.dart';

/// Brackets are combined with words in a variety of modern directions.
///
/// The line-end attribute specifies if there is a jog up or down (or both),
/// an arrow, or nothing at the start or end of the bracket.
///
/// If the line-end is up or down, the length of the jog can be specified using the end-length attribute.
///
/// The line-type is solid if not specified.
class Bracket {
  StartStopContinue type;

  int? number;

  LineEnd lineEnd;

  double? endLength;

  LineType? lineType;

  DashedFormatting dashedFormatting;

  Position position;

  Color color;

  String? id;

  Bracket({
    required this.type,
    this.number,
    required this.lineEnd,
    this.lineType,
    required this.dashedFormatting,
    required this.position,
    required this.color,
    this.id,
  });

  factory Bracket.fromXml(XmlElement xmlElement) {
    return Bracket(
      type: StartStopContinue.start,
      number: 0,
      lineEnd: LineEnd.arrow,
      lineType: LineType.dashed,
      dashedFormatting: DashedFormatting.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }
}

/// The line-end type specifies if there is a jog up or down (or both), an arrow,
/// or nothing at the start or end of a bracket.
enum LineEnd {
  up,
  down,
  both,
  arrow,
  none;
}
