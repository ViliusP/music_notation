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

    String? documentation = element
        .findElements('xs:annotation')
        .firstOrNull
        ?.findElements('xs:documentation')
        .first
        .value;

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
    return env.getTemplate('simple_type_value.template').render({
      "name": kebabToCamel(name ?? ""),
      "comment": documentation,
      "restriction_base": _baseMap[restrictionBase],
      "restriction_values": restrictionValues.map((e) => {e.a: e.b}),
    });
  }

  static const _baseMap = {
    "xs:token": "",
    "xs:positiveInteger": "int",
    "xs:decimal": "double",
    "xs:string": "String",
    "comma-separated-text": "String",
    "null": "dynamic",
    "xs:nonNegativeInteger": "int",
    "divisions": "",
    "xs:NMTOKEN": "",
    "smufl-glyph-name": "",
    "xs:date": "Datetime",
    "xs:integer": "int",
    "system-relation-number": "",
    "note-type-value": ""
  };

  // String restrictionBaseToType(String? restrictionBase) {}
}
