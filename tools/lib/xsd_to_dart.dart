import 'dart:io';

import 'package:cli/xsd.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';
import 'package:xml/xml.dart';

class XsdToDart {
  XmlDocument document;

  XsdToDart({
    required this.document,
  });

  Future<String> generateCode() async {
    var templatesUri = Platform.script.resolve('templates');

    var env = Environment(
      autoReload: true,
      loader: FileSystemLoader(paths: <String>[templatesUri.path]),
      leftStripBlocks: true,
      trimBlocks: true,
    );

    _generateSimpleTypes(env);

    return "";
  }

  Future<String> _generateSimpleTypes(Environment env) async {
    final simpleTypes = document.findAllElements('xs:simpleType');
    for (var element in simpleTypes.take(3)) {
      SimpleType type = SimpleType.fromElement(element);
      // print('Element name: ${element.getAttribute('name')}');
      // print(env.getTemplate('simple_type_value.template').render({
      //   'users': [
      //     {'fullname': 'John Doe', 'email': 'johndoe@dev.py'},
      //     {'fullname': 'Jane Doe', 'email': 'janedoe@dev.py'},
      //   ]
      // }));
    }
    return Future.value("");
  }
}
