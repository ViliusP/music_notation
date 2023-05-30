import 'package:cli/utils.dart';
import 'package:collection/collection.dart';
import 'package:jinja/jinja.dart';
import 'package:xml/xml.dart';

class SimpleType {
  final String? name;
  final String? documentation;
  final String? restrictionBase;
  final List<Pair<String, dynamic>> restrictionValues;
  final List<String>? unionMemberTypes;
  final SimpleType? unionContent;

  SimpleType._(
    this.name,
    this.documentation,
    this.restrictionBase,
    this.restrictionValues,
    this.unionMemberTypes,
    this.unionContent,
  );

  factory SimpleType.fromElement(XmlElement element) {
    String? name = element.getAttribute("name");

    print(element
        .findElements('xs:annotation')
        .firstOrNull
        ?.findElements('xs:documentation')
        .firstOrNull);

    String? documentation = element
        .findElements('xs:annotation')
        .firstOrNull
        ?.findElements('xs:documentation')
        .firstOrNull
        ?.innerText;

    String? restrictionBase = element
        .findElements('xs:restriction')
        .firstOrNull
        ?.getAttribute("base");

    final restriction = element.findAllElements('xs:restriction').firstOrNull;

    final List<Pair<String, dynamic>> restrictionValues = [];

    for (var element
        in restriction?.children.whereType<XmlElement>() ?? Iterable.empty()) {
      restrictionValues.add(
        Pair(element.name.local, element.getAttribute('value')),
      );
    }

    List<String>? unionMemberTypes = element
        .findElements('xs:union')
        .firstOrNull
        ?.getAttribute("memberTypes")
        ?.split(" ")
        .toList();

    XmlElement? unionElement = element.findElements('xs:union').firstOrNull;

    SimpleType? unionContent;

    if (unionElement != null) {
      unionContent = SimpleType.fromElement(unionElement);
    }

    return SimpleType._(
      name,
      documentation,
      restrictionBase,
      restrictionValues,
      unionMemberTypes,
      unionContent,
    );
  }

  String toCode(Environment env) {
    Map<String, Object?> data = {
      "name": kebabToCamel(name ?? ""),
      "comment": _breakSentence(documentation ?? "", 80, '\n/// '),
      "restriction_base": _baseMap[restrictionBase],
      "restriction_values": restrictionValues.map((e) => {e.a: e.b}),
    };

    return env.getTemplate('simple_type_value.template').render(data);
  }

  static const _baseMap = {
    "xs:token": "String",
    "xs:positiveInteger": "int",
    "xs:decimal": "double",
    "xs:string": "String",
    "comma-separated-text": "String",
    "null": "dynamic",
    "xs:nonNegativeInteger": "int",
    "divisions": "double",
    "xs:NMTOKEN": "String",
    "smufl-glyph-name": "",
    "xs:date": "DateTime",
    "xs:integer": "int",
    "system-relation-number": "",
    "note-type-value": ""
  };

  /// Breaks a long sentence into multiple lines after every n characters without splitting words.
  ///
  /// Parameters:
  ///   - [sentence]: The input sentence to break.
  ///   - [n]: The maximum number of characters per line.
  ///   - [lineBreak]: The line break character(s) to insert after every n characters. Default is '\n'.
  ///
  /// Returns the sentence with line breaks inserted after every n characters.
  String _breakSentence(String sentence, int n, [String lineBreak = '\n']) {
    final words = sentence.split(' ');
    final lines = <String>[];

    String currentLine = '';
    for (final word in words) {
      if (currentLine.isNotEmpty &&
          (currentLine.length + word.length + 1) > n) {
        lines.add(currentLine);
        currentLine = '';
      }
      if (currentLine.isNotEmpty) {
        currentLine += ' ';
      }
      currentLine += word;
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join(lineBreak);
  }

  // String restrictionBaseToType(String? restrictionBase) {}
}
