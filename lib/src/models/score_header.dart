import 'package:music_notation/src/models/credit.dart';
import 'package:music_notation/src/models/defaults.dart';
import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/identification.dart';
import 'package:music_notation/src/models/part_list.dart';
import 'package:music_notation/src/models/score_part.dart';
import 'package:xml/xml.dart';

// <xs:group name="score-header">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>

// 		<xs:element name="credit" type="credit" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="part-list" type="part-list"/>
// 	</xs:sequence>
// </xs:group>

/// The score-header group contains basic score metadata about the work and movement,
/// score-wide defaults for layout and fonts,
/// credits that appear on the first or following pages, and the part list.
class ScoreHeader {
  final Work? work;

  /// The movement-number element specifies the number of a movement.
  final String? movementNumber;

  /// The movement-title element specifies the title of a movement, not including its number.
  final String? movementTitle;
  final Identification? identification;
  final Defaults? defaults;
  final List<Credit>? credits;
  final PartList partList;

  ScoreHeader({
    this.work,
    this.movementNumber,
    this.movementTitle,
    this.identification,
    this.defaults,
    this.credits,
    required this.partList,
  });

  factory ScoreHeader.fromXml(XmlElement xmlElement) {
    return ScoreHeader(
      work: Work.fromXml(xmlElement.findElements('work').first),
      movementNumber: xmlElement.getElement('movement-number')?.text,
      movementTitle: xmlElement.getElement('movement-title')?.text,
      identification: Identification.fromXml(
          xmlElement.findElements('identification').first),
      defaults: Defaults.fromXml(xmlElement.findElements('defaults').first),
      credits: xmlElement
          .findElements('credit')
          .map((e) => Credit.fromXml(e))
          .toList(),
      partList: PartList.fromXml(xmlElement.findElements('part-list').first),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('score-header', nest: () {
      if (work != null) builder.element('work', nest: work!.toXml());
      if (movementNumber != null) {
        builder.element('movement-number',
            nest: movementNumber); // TODO: check nest.
      }
      if (movementTitle != null) {
        builder.element('movement-title',
            nest: movementTitle); // TODO: check nest
      }
      if (identification != null) {
        // builder.element('identification', nest: identification!.toXml());
        // TODO make toXml
      }
      if (defaults != null) {
        builder.element('defaults', nest: defaults!.toXml());
      }
      credits?.forEach(
          (credit) => builder.element('credit', nest: credit.toXml()));
      builder.element('part-list', nest: partList.toXml());
    });
    return builder.buildDocument().rootElement;
  }
}

/// Works are optionally identified by number and title.
///
/// The work type also may indicate a link to the opus document that composes multiple scores into a collection.
class Work {
  /// The work-number element specifies the number of a work, such as its opus number.
  final String? workNumber;

  /// The work-title element specifies the title of a work, not including its opus or other work number.
  final String? workTitle;
  final LinkAttributes? opus;

  Work({
    this.workNumber,
    this.workTitle,
    this.opus,
  });

  factory Work.fromXml(XmlElement xmlElement) {
    return Work(
      workNumber: xmlElement.getElement('work-number')?.text,
      workTitle: xmlElement.getElement('work-title')?.text,
      opus: LinkAttributes.fromXml(xmlElement.findElements('opus').first),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('work', nest: () {
      if (workNumber != null) {
        builder.element(
          'work-number',
          nest: workNumber,
        ); // TODO: check nest
      }
      if (workTitle != null) {
        builder.element(
          'work-title',
          nest: workTitle,
        ); // TODO: check nest
      }
      if (opus != null) {
        builder.element(
          'opus',
          nest: opus!.toXml(),
        );
      }
    });
    return builder.buildDocument().rootElement;
  }
}
