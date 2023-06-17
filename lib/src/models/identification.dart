import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

/// Identification contains basic metadata about the score.
///
/// It includes information that may apply at a score-wide, movement-wide, or part-wide level.
///
/// The creator, rights, source, and relation elements are based on Dublin Core.
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

  Encoding? encoding;

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

  factory Identification.fromXml(XmlElement xmlElement) {
    var creators = xmlElement
        .findElements('creator')
        .map((element) => TypedText.fromXml(element))
        .toList();

    var rights = xmlElement
        .findElements('rights')
        .map((element) => TypedText.fromXml(element))
        .toList();

    var encodingElement = xmlElement.findElements('encoding').firstOrNull;

    Encoding? encoding;

    if (encodingElement != null) {
      encoding = Encoding.fromXml(encodingElement);
    }

    var miscellaneous = xmlElement
        .findElements('miscellaneous-field')
        .map((element) => MiscellaneousField.fromXml(element))
        .toList();

    return Identification(
      creators: creators,
      rights: rights,
      miscellaneous: miscellaneous,
      encoding: encoding,
    );
  }
}

/// The encoding element contains information about who did the digital encoding,
/// when, with what software, and in what aspects.
///
/// Standard type values for the encoder element are music, words, and arrangement, but other types may be used.
/// The type attribute is only needed when there are multiple encoder elements
class Encoding {
  String? software;

  /// Date format: yyyy-mm-dd
  DateTime? encodingDate;
  static final DateFormat _encodingDateFormat = DateFormat('yyyy-MM-dd');

  List<Support> supports;

  Encoding(
    this.software,
    this.encodingDate,
    this.supports,
  );

  factory Encoding.fromXml(XmlElement xmlElement) {
    String? software;
    DateTime? encodingDate;
    List<Support> supports = [];

    for (var element in xmlElement.children.whereType<XmlElement>()) {
      switch (element.name.local) {
        case 'software':
          software = element.text;
          break;
        case 'encoding-date':
          String encodingDateText = element.text;
          try {
            encodingDate = _encodingDateFormat.parseStrict(encodingDateText);
          } catch (e) {
            throw InvalidXmlElementException(
              message:
                  "Attribute 'encoding-date' is not a valid DateTime: $encodingDateText",
              xmlElement: xmlElement,
            );
          }
          break;
        case 'supports':
          supports.add(Support.fromXml(element));
          break;
      }
    }

    return Encoding(
      software,
      encodingDate,
      supports,
    );
  }
}

/// The supports type indicates if a MusicXML encoding supports a particular MusicXML element.
/// This is recommended for elements like beam, stem, and accidental,
/// where the absence of an element is ambiguous if you do not know if the encoding supports that element.
///
/// For Version 2.0, the supports element is expanded to allow programs to indicate support for particular attributes or particular values.
/// This lets applications communicate, for example, that all system and/or page breaks are contained in the MusicXML file.
class Support {
  /// Required
  bool type;

  /// Required, type - NMTOKEN.
  String element;

  /// type - NMTOKEN.
  String? attribute;

  String? value;

  Support({
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

  factory Support.fromXml(XmlElement xmlElement) {
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

    return Support(
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
/// The required name attribute indicates the type of metadata the element content represents.
class MiscellaneousField {
  final String value;
  final String name;

  MiscellaneousField({required this.value, required this.name});

  factory MiscellaneousField.fromXml(XmlElement xmlElement) {
    var name = xmlElement.getAttribute('name');

    if (name != null) {
      throw InvalidXmlElementException(
        message: "Invalid or missing 'name' attribute",
        xmlElement: xmlElement,
      );
    }

    return MiscellaneousField(
      value: xmlElement.text,
      name: name!,
    );
  }
}
