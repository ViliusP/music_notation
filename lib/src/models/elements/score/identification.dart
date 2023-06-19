import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';

/// Identification contains basic metadata about the score.
///
/// It includes information that may apply at a score-wide, movement-wide, or part-wide level.
///
/// The creator, rights, source, and relation elements are based on Dublin Core.
///
/// For more details go to [a](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/identification/)
class Identification {
  /// The creator element is borrowed from Dublin Core.
  /// It is used for the creators of the score.
  /// The type attribute is used to distinguish different creative contributions.
  /// Thus, there can be multiple creators within an identification.
  /// Standard type values are composer, lyricist, and arranger.
  /// Other type values may be used for different types of creative roles.
  /// The type attribute should usually be used even if there is just a single creator element.
  /// The MusicXML format does not use the creator / contributor distinction from Dublin Core.
  List<TypedText>? creators;

  /// The rights element is borrowed from Dublin Core.
  /// It contains copyright and other intellectual property notices.
  /// Words, music, and derivatives can have different types,
  /// so multiple rights elements with different type attributes are supported.
  ///
  /// Standard type values are music, words, and arrangement, but other types may be used.
  /// The type attribute is only needed when there are multiple rights elements.
  List<TypedText>? rights;

  List<Encoding>? encoding;

  /// The source for the music that is encoded. This is similar to the Dublin Core source element.
  String? source;

  /// A related resource for the music that is encoded. This is similar to the Dublin Core relation element.
  /// Standard type values are music, words, and arrangement, but other types may be used.
  List<TypedText>? relations;

  /// If a program has other metadata not yet supported in the MusicXML format,
  /// it can go in the miscellaneous element.
  ///
  /// The miscellaneous type puts each separate part of metadata into its own miscellaneous-field type.
  List<MiscellaneousField>? miscellaneous;

  Identification({
    this.creators,
    this.rights,
    this.encoding,
    this.source,
    this.relations,
    this.miscellaneous,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'creator': XmlQuantifier.zeroOrMore,
    'rights': XmlQuantifier.zeroOrMore,
    'encoding': XmlQuantifier.optional,
    'source': XmlQuantifier.optional,
    'relation': XmlQuantifier.zeroOrMore,
    'miscellaneous': XmlQuantifier.optional,
  };

  factory Identification.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var creators = xmlElement
        .findElements('creator')
        .map((element) => TypedText.fromXml(element))
        .toList();

    var rights = xmlElement
        .findElements('rights')
        .map((element) => TypedText.fromXml(element))
        .toList();

    var encodingElement = xmlElement.findElements('encoding').firstOrNull;
    List<Encoding>? encoding;
    if (encodingElement != null) {
      encoding = encodingElement.childElements
          .map((element) => Encoding.fromXml(encodingElement))
          .toList();
    }

    var sourceElement = xmlElement.findElements('encoding').firstOrNull;

    if (sourceElement != null && sourceElement.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message: "'source' in 'identification' must to be text",
        xmlElement: xmlElement,
      );
    }

    var relations = xmlElement
        .findElements('relation')
        .map((element) => TypedText.fromXml(element))
        .toList();

    var miscellaneous = xmlElement
        .findElements('miscellaneous-field')
        .map((element) => MiscellaneousField.fromXml(element))
        .toList();

    return Identification(
      creators: creators,
      rights: rights,
      encoding: encoding,
      source: sourceElement?.value,
      relations: relations,
      miscellaneous: miscellaneous,
    );
  }
}

/// The [Encoding] element contains information about who did the digital encoding,
/// when, with what software, and in what aspects.
///
/// Standard type values for the encoder element are music, words, and arrangement, but other types may be used.
/// The type attribute is only needed when there are multiple encoder elements.
abstract class Encoding {
  factory Encoding.fromXml(XmlElement xmlElement) {
    switch (xmlElement.name.local) {
      case EncodingDate.xmlElementName:
        return EncodingDate.fromXml(xmlElement);
      case Encoder.xmlElementName:
        return Encoder.fromXml(xmlElement);
      case Software.xmlElementName:
        return Software.fromXml(xmlElement);
      case EncodingDescription.xmlElementName:
        return EncodingDescription.fromXml(xmlElement);
      case Supports.xmlElementName:
        return Supports.fromXml(xmlElement);
      default:
        throw InvalidXmlElementException(
          message: "'${xmlElement.name}' cannot be Encoding",
          xmlElement: xmlElement,
        );
    }
  }
}

class EncodingDate implements Encoding {
  final DateTime value;

  /// Format for parsing [value] from musicXML.
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static const String xmlElementName = "encoding-date";

  EncodingDate({
    required this.value,
  });

  factory EncodingDate.fromXml(XmlElement xmlElement) {
    return EncodingDate(value: DateTime.now());
  }
}

class Software implements Encoding {
  final String value;

  static const String xmlElementName = "software";

  Software({
    required this.value,
  });

  factory Software.fromXml(XmlElement xmlElement) {
    return Software(value: "");
  }
}

class Encoder extends TypedText implements Encoding {
  static const String xmlElementName = "encoder";

  Encoder({
    required super.value,
    required super.type,
  });

  factory Encoder.fromXml(XmlElement xmlElement) {
    TypedText typedText = TypedText.fromXml(xmlElement);

    return Encoder(
      value: typedText.value,
      type: typedText.type,
    );
  }
}

class EncodingDescription implements Encoding {
  String value;

  static const String xmlElementName = "encoding-description";

  EncodingDescription({
    required this.value,
  });

  factory EncodingDescription.fromXml(XmlElement xmlElement) {
    return EncodingDescription(value: "");
  }
}

// /// Contains information about who did the digital encoding.
// TypedText? encoder;

// /// Specifies what software created the digital encoding.
// String? software;

// /// Descriptive information about the digital encoding that is not provided
// /// in the other properties.
// String encodingDescription;

// /// Indicates if a MusicXML encoding supports a particular MusicXML elements.
// List<Support> supports;

// Encoding(
//   this.encodingDate,
//   this.encoder,
//   this.software,
//   this.encodingDescription,
//   this.supports,
// );

// factory Encoding.fromXml(XmlElement xmlElement) {
//   List<dynamic> encoding = [];

//   String? software;
//   DateTime? encodingDate;
//   List<Support> supports = [];

//   for (var element in xmlElement.children.whereType<XmlElement>()) {
//     switch (element.name.local) {
//       case 'software':
//         software = element.text;
//         break;
//       case 'encoding-date':
//         String encodingDateText = element.text;
//         try {
//           encodingDate = _encodingDateFormat.parseStrict(encodingDateText);
//         } catch (e) {
//           throw InvalidXmlElementException(
//             message:
//                 "Attribute 'encoding-date' is not a valid DateTime: $encodingDateText",
//             xmlElement: xmlElement,
//           );
//         }
//         break;
//       case 'supports':
//         supports.add(Support.fromXml(element));
//         break;
//     }
//   }
//   return Encoding();
//   // return Encoding(
//   //   software,
//   //   encodingDate,
//   //   supports,
//   // );
// }

/// The supports type indicates if a MusicXML encoding supports a particular MusicXML element.
/// This is recommended for elements like beam, stem, and accidental,
/// where the absence of an element is ambiguous if you do not know if the encoding supports that element.
///
/// For Version 2.0, the supports element is expanded to allow programs
/// to indicate support for particular attributes or particular values.
/// This lets applications communicate, for example,
/// that all system and/or page breaks are contained in the MusicXML file.
class Supports implements Encoding {
  static const String xmlElementName = "supports";

  /// Required
  bool type;

  /// Required, type - NMTOKEN.
  String element;

  /// type - NMTOKEN.
  String? attribute;

  String? value;

  Supports({
    required this.type,
    required this.element,
    this.attribute,
    this.value,
  });

  static const _typeMap = {
    "yes": true,
    "no": false,
  };

  // static const _reverseTypeMap = {
  //   true: "yes",
  //   false: "no",
  // };

  factory Supports.fromXml(XmlElement xmlElement) {
    var type = xmlElement.getAttribute('type');
    var mappedType = _typeMap[type];

    if (mappedType == null) {
      throw InvalidXmlElementException(
        message: "Invalid or missing 'type' attribute",
        xmlElement: xmlElement,
      );
    }

    var element = xmlElement.getAttribute('element');

    if (element == null) {
      throw InvalidXmlElementException(
        message: "Invalid or missing 'element' attribute",
        xmlElement: xmlElement,
      );
    }

    if (!Nmtoken.validate(element)) {
      throw InvalidXmlElementException(
        message: "Attribute 'element' is not a valid NMTOKEN: $element",
        xmlElement: xmlElement,
      );
    }

    var attribute = xmlElement.getAttribute('attribute');

    if (attribute != null && !Nmtoken.validate(attribute)) {
      throw InvalidXmlElementException(
        message: "Attribute 'attribute' is not a valid NMTOKEN: $attribute",
        xmlElement: xmlElement,
      );
    }

    return Supports(
      type: mappedType,
      element: element,
      attribute: attribute,
      value: xmlElement.getAttribute('value'),
    );
  }
}

/// If a program has other metadata not yet supported in the MusicXML format,
/// each type of metadata can go in a miscellaneous-field element.
///
/// The required [name] attribute indicates the type of metadata the element content represents.
class MiscellaneousField {
  final String value;
  final String name;

  MiscellaneousField({
    required this.value,
    required this.name,
  });

  factory MiscellaneousField.fromXml(XmlElement xmlElement) {
    // Content parsing:
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message: "'miscellaneous-field' element should contain only text",
        xmlElement: xmlElement,
      );
    }
    String content = xmlElement.children.first.value!;

    String? name = xmlElement.getAttribute("name");

    if (name == null) {
      throw XmlAttributeRequired(
        message:
            "'name' attribute is required in 'miscellaneous-field' element",
        xmlElement: xmlElement,
      );
    }

    return MiscellaneousField(
      value: content,
      name: name,
    );
  }
}
