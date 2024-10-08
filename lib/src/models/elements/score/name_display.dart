import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// The name-display type is used for exact formatting of multi-font text in part and group names to the left of the system.
///
/// The print-object attribute can be used to determine what, if anything, is printed at the start of each system.
///
/// Enclosure for the display-text element is none by default. Language for the display-text element is Italian ("it") by default.
class NameDisplay {
  List<TextElementBase> texts;

  /// The print-object attribute specifies whether
  /// or not to print an object (e.g. a note or a rest).
  ///
  /// It is yes (true) by default.
  bool printObject;

  NameDisplay({
    this.texts = const [],
    this.printObject = true,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'display-text|accidental-text': XmlQuantifier.zeroOrMore,
  };

  factory NameDisplay.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var texts = <TextElementBase>[];

    for (var childElement in xmlElement.childElements) {
      switch (childElement.name.local) {
        case "display-text":
          texts.add(FormattedText.fromXml(childElement));
          break;
        case "accidental-text":
          texts.add(AccidentalText.fromXml(childElement));
          break;
        default:
          // This exception should not be thrown because
          // the validateSequence method should check if the sequence is correct.
          throw XmlElementContentException(
            message:
                "Invalid element found inside 'name-display': ${childElement.name.local}",
            xmlElement: xmlElement,
          );
      }
    }

    return NameDisplay(
      texts: texts,
      printObject:
          YesNo.fromXml(xmlElement, CommonAttributes.printObject) ?? true,
    );
  }
}
