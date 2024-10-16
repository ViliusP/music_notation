import 'package:music_notation/src/models/elements/score/credit.dart';
import 'package:music_notation/src/models/elements/score/defaults.dart';
import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/score/identification.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// The root element for a partwise MusicXML score.
/// It includes a [scoreHeader] group followed by a series of parts with measures inside.
class ScorePartwise {
  final ScoreHeader scoreHeader;
  final List<Part> parts;

  final String version;

  ScorePartwise({
    required this.scoreHeader,
    required this.parts,
    this.version = "1.0",
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'part': XmlQuantifier.oneOrMore,
  };

  /// Factory method to create a ScorePartwise instance from an XML document.
  ///
  /// The XML document should adhere to the MusicXML format for ScorePartwise.
  /// This method performs the parsing and validation of the XML structure to ensure it conforms to the expected sequence.
  /// If the XML structure is invalid, an exception will be thrown.
  ///
  /// Returns a ScorePartwise instance representing the parsed data from the XML document.
  factory ScorePartwise.fromXml(XmlDocument xmlDocument) {
    XmlElement root = xmlDocument.rootElement;

    // Validate the sequence of XML elements in the root element against the expected order.
    // This ensures that the XML structure conforms to the expected sequence.
    validateSequence(
      root,
      {}
        ..addAll(ScoreHeader._xmlExpectedOrder)
        ..addAll(_xmlExpectedOrder),
    );

    final Iterable<Part> parts = root.childElements
        .where((e) => e.name.local == "part")
        .map((e) => Part.fromXml(e));

    return ScorePartwise(
      scoreHeader: ScoreHeader.fromXml(root),
      parts: parts.toList(),
      version: root.getAttribute("version") ?? "1.0",
    );
  }
}

/// The root element for a timewise MusicXML score.
/// It includes a [scoreHeader] group followed by a series of measures with parts inside.
class ScoreTimewise {
  final ScoreHeader scoreHeader;
  // final List<Part> parts; TODO

  final String version;

  ScoreTimewise({
    required this.scoreHeader,
    // required this.parts,
    this.version = "1.0",
  });
}

/// Group that contains basic score metadata about the work and movement,
/// score-wide defaults for layout and fonts,
/// credits that appear on the first or following pages, and the part list.
class ScoreHeader {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final Work? work;

  /// Specifies the number of a movement.
  final String? movementNumber;

  /// Specifies the title of a movement, not including its number.
  final String? movementTitle;
  final Identification? identification;
  final Defaults? defaults;
  final List<Credit> credits;
  final PartList partList;

  ScoreHeader({
    this.work,
    this.movementNumber,
    this.movementTitle,
    this.identification,
    this.defaults,
    this.credits = const [],
    required this.partList,
  });

  /// not used directly
  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'work': XmlQuantifier.optional,
    'movement-number': XmlQuantifier.optional,
    'movement-title': XmlQuantifier.optional,
    'identification': XmlQuantifier.optional,
    'defaults': XmlQuantifier.optional,
    'credit': XmlQuantifier.zeroOrMore,
    'part-list': XmlQuantifier.required,
  };

  // Should be validated in parent class.
  factory ScoreHeader.fromXml(XmlElement xmlElement) {
    final workElement = xmlElement.getElement('work');
    final identificationElement = xmlElement.getElement('identification');
    final defaultsElement = xmlElement.getElement('defaults');

    return ScoreHeader(
      work: workElement != null ? Work.fromXml(workElement) : null,
      movementNumber: xmlElement.getElement('movement-number')?.innerText,
      movementTitle: xmlElement.getElement('movement-title')?.innerText,
      identification: identificationElement != null
          ? Identification.fromXml(identificationElement)
          : null,
      defaults: defaultsElement != null
          ? Defaults.fromXml(
              defaultsElement,
            )
          : null,
      credits: xmlElement
          .findElements('credit')
          .map((e) => Credit.fromXml(e))
          .toList(),
      partList: PartList.fromXml(xmlElement.getElement('part-list')!),
    );
  }

  // TODO: finish and test
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
      for (var credit in credits) {
        builder.element('credit', nest: credit.toXml());
      }
      builder.element('part-list', nest: partList.toXml());
    });
    return builder.buildDocument().rootElement;
  }
}

/// Works are optionally identified by number and title.
///
/// The work type also may indicate a link to the opus document that composes multiple scores into a collection.
class Work {
  /// Specifies the number of a work, such as its opus number.
  final String? number;

  /// Specifies the title of a work, not including its opus or other work number.
  final String? title;
  final LinkAttributes? opus;

  Work({
    this.number,
    this.title,
    this.opus,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'work-number': XmlQuantifier.optional,
    'work-title': XmlQuantifier.optional,
    'opus': XmlQuantifier.optional,
  };

  factory Work.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlNode? workNumberNode = xmlElement.getElement('work-number')?.firstChild;
    if (workNumberNode != null && workNumberNode.nodeType != XmlNodeType.TEXT) {
      throw XmlElementContentException(
        message: "'work-number' content must be string",
        xmlElement: xmlElement,
      );
    }

    XmlNode? workTitleNode = xmlElement.getElement('work-title')?.firstChild;
    if (workTitleNode != null && workTitleNode.nodeType != XmlNodeType.TEXT) {
      throw XmlElementContentException(
        message: "'work-number' content must be string",
        xmlElement: xmlElement,
      );
    }

    XmlElement? opusElement = xmlElement.getElement('opus');

    return Work(
      number: workNumberNode?.value,
      title: workTitleNode?.value,
      opus: opusElement != null ? LinkAttributes.fromXml(opusElement) : null,
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('work', nest: () {
      if (number != null) {
        builder.element(
          'work-number',
          nest: number,
        ); // TODO: check nest
      }
      if (title != null) {
        builder.element(
          'work-title',
          nest: title,
        ); // TODO: check nest
      }
      if (opus != null) {
        builder.element(
          'opus',
          attributes: opus!.toXml(),
        );
      }
    });
    return builder.buildDocument().rootElement;
  }
}
