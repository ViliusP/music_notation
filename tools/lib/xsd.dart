import 'package:xml/xml.dart';

class SimpleType {
  String? name;
  String? documentation;
  String? restrictionBase;
  List<String>? restrictionValues;

  SimpleType._(
    this.name,
    this.documentation,
    this.restrictionBase,
    this.restrictionValues,
  );

  factory SimpleType.fromElement(XmlElement element) {
    print(element);
    print(element.attributes);
    // String? name = element.attributes
    return SimpleType._(
        "genreElement.getAttribute('id')",
        "genreElement.getAttribute('title')",
        "genreElement.getAttribute('token')", []);
  }
}
