import 'dart:io';

import 'package:cli/glyph_name.dart';
import 'package:cli/glyph_range.dart';
import 'package:cli/simple_type.dart';
import 'package:cli/utils.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';

class SmuflCodeGenerator {
  final Map<String, GlyphName> glyphName;
  final Map<String, List<String>> classes;
  final Map<String, GlyphRange> glyphRange;

  SmuflCodeGenerator({
    required this.glyphName,
    required this.classes,
    required this.glyphRange,
  });

  Future<Map<String, String>> generateCode() async {
    var templatesUri = Platform.script.resolve('../templates');

    var env = Environment(
      autoReload: true,
      loader: FileSystemLoader(paths: <String>[templatesUri.path]),
      leftStripBlocks: true,
      trimBlocks: true,
    );

    Map<String, String> codes = {};

    codes.addAll(_generateSimpleTypes(env));

    return codes;
  }

  Map<String, String> _generateSimpleTypes(Environment env) {
    // final simpleTypesElements =
    //     document.rootElement.findElements('xs:simpleType');

    // List<SimpleType> simpleTypes =
    //     simpleTypesElements.map((e) => SimpleType.fromElement(e)).toList();

    Map<String, String> codes = {};

    // String folder = "simple_types";

    // for (var simpleType in simpleTypes) {
    //   if (simpleType.name == null) {
    //     continue;
    //   }

    //   final String filename = kebabToSnake(simpleType.name!);

    //   codes["$folder/$filename"] = simpleType.toCode(env);
    // }

    // print(simpleTypes.map((e) => e.restrictionBase).toSet());

    return codes;
  }
}
