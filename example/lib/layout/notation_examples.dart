import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

enum NotationExample {
  helloWorld(
    displayName: "Tutorial: Hello World",
    path: "assets/scores/hello_world.xml",
    description: "",
  ),
  scale(
    displayName: "Scale",
    path: "assets/scores/scale.xml",
  ),
  apresUnReve(
    displayName: "Tutorial: Après un rêve",
    path: "assets/scores/après_un_rêve.xml",
  ),
  chopinPrelude(
    displayName: "Tutorial: Chopin Prelude",
    path: "assets/scores/chopin_prelude.xml",
  ),
  dots(
    displayName: "Dot(s) rendering",
    path: "assets/scores/dot(s)_examples.musicxml",
  );

  const NotationExample({
    required this.displayName,
    required this.path,
    this.description = "",
  });

  final String displayName;
  final String path;
  final String description;

  Future<XmlDocument?> read() async {
    try {
      String xmlString = await rootBundle.loadString(path);
      return XmlDocument.parse(xmlString);
    } catch (e) {
      // ignore: avoid_print
      print("$name Error: $e");
      return null;
    }
  }

  List<String> toTerms() {
    List<String> splittedDisplayName = displayName.toLowerCase().split(' ');
    return splittedDisplayName;
  }
}
