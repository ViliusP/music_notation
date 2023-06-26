import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/music_data/music_data.dart';

class Part {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  final List<Measure> measures;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// In either partwise or timewise format,
  /// the part element has an id attribute that is an IDREF back to a score-part in the part-list.
  final String id;

  Part({
    required this.measures,
    required this.id,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'measure': XmlQuantifier.oneOrMore,
  };

  factory Part.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);
    String? id = xmlElement.getAttribute("id");

    if (id == null) {
      throw MissingXmlAttribute(
        message: "'id' attribute is required for 'part' element",
        xmlElement: xmlElement,
      );
    }

    final Iterable<Measure> measures = xmlElement
        .findElements('measure')
        .map((element) => Measure.fromXml(element));

    return Part(
      id: id,
      measures: measures.toList(),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    // builder.element('part', nest: () {
    //   for (var measure in measures) {
    //     builder.element(measure.toXml());
    //   }
    //   builder.attribute('part-attributes', id);
    // });
    return builder.buildDocument().rootElement;
  }
}

class Measure {
  final MusicData data;
  final MeasureAttributes attributes;

  Measure({
    required this.data,
    required this.attributes,
  });

  factory Measure.fromXml(XmlElement xmlElement) {
    XmlElement? musicDataElement = xmlElement.getElement('music-data');

    return Measure(
      data: musicDataElement == null
          ? MusicData(data: [])
          : MusicData.fromXml(musicDataElement),
      attributes: MeasureAttributes.fromXml(xmlElement),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('measure', nest: data.toXml());
    // builder.attribute('measure-attributes', attributes.toXml());
    return builder.buildDocument().rootElement;
  }
}

/// The measure-attributes group is used by the measure element.
/// Measures have a required number attribute (going from partwise to timewise, measures are grouped via the number).
///
/// The implicit attribute is set to "yes" for measures where the measure number should never appear, such as pickup measures and the last half of mid-measure repeats. The value is "no" if not specified.
///
/// The non-controlling attribute is intended for use in multimetric music like the Don Giovanni minuet. If set to "yes", the left barline in this measure does not coincide with the left barline of measures in other parts. The value is "no" if not specified.
///
/// In partwise files, the number attribute should be the same for
/// measures in different parts that share the same left barline.
/// While the number attribute is often numeric, it does not have to be.
/// Non-numeric values are typically used together with the implicit or non-controlling attributes being set to "yes". For a pickup measure, the number attribute is typically set to "0" and the implicit attribute is typically set to "yes".
///
/// If measure numbers are not unique within a part, this can cause problems
/// for conversions between partwise and timewise formats.
/// The text attribute allows specification of displayed measure numbers
/// that are different than what is used in the number attribute.
/// This attribute is ignored for measures where the implicit attribute is set to "yes".
/// Further details about measure numbering can be specified using the measure-numbering element.
///
/// Measure width is specified in tenths.
/// These are the global tenths specified in the scaling element, not local tenths as modified by the staff-size element.
/// The width covers the entire measure from barline or system start to barline or system end.<
class MeasureAttributes {
  /// The attribute that identifies the measure.
  ///
  /// Going from partwise to timewise, measures are grouped via this attribute.
  /// In partwise files, it should be the same for measures in different parts that share the same left barline.
  ///
  /// While often numeric, it does not have to be.
  /// Non-numeric values are typically used together with the implicit or
  /// non-controlling attributes being set to "yes".
  ///
  /// For a pickup measure, the number attribute is typically set to "0"
  /// and the implicit attribute is typically set to "yes".
  String number;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  /// Set to "yes" for measures where the measure number should never appear,
  /// such as pickup measures and the last half of mid-measure repeats.
  ///
  /// The value is "no" if not specified.
  bool implicit;

  /// Intended for use in multimetric music like the Don Giovanni minuet.
  ///
  /// If set to "yes", the left barline in this measure does not coincide
  /// with the left barline of measures in other parts.
  ///
  /// The value is "no" if not specified.
  bool nonControlling;

  /// Measure width specified in tenths.
  /// These are the global tenths specified in the [Scaling] element,
  /// not local tenths as modified by the <staff-size> element.
  ///
  /// The width covers the entire measure from barline or system start to barline or system end.
  double? width;

  String? text;

  MeasureAttributes({
    required this.number,
    this.id,
    this.implicit = false,
    this.nonControlling = false,
    this.width,
    this.text,
  });

  factory MeasureAttributes.fromXml(XmlElement xmlElement) {
    return MeasureAttributes(
      number: "number",
    );
  }

  /// Checks if the measure text is valid.
  bool _isValidMeasureText(String? measureText, String? implicit) {
    // Check if measureText is not null and has at least one character.
    bool isMeasureTextValid =
        measureText != null && measureText.trim().isNotEmpty;

    // Check if implicit is set to "yes" when measureText is empty.
    bool isImplicitValid = true;
    if (measureText == null || measureText.trim().isEmpty) {
      isImplicitValid = implicit == 'yes';
    }

    return isMeasureTextValid && isImplicitValid;
  }
}

// <xs:element name="part" maxOccurs="unbounded">
// 		<xs:complexType>
// 			<xs:sequence>
// 				<xs:element name="measure" maxOccurs="unbounded">
// 					<xs:complexType>
// 						<xs:group ref="music-data"/>
// 						<xs:attributeGroup ref="measure-attributes"/>
// 					</xs:complexType>
// 				</xs:element>
// 			</xs:sequence>
// 			<xs:attributeGroup ref="part-attributes"/>
// 		</xs:complexType>
// 	</xs:element>
