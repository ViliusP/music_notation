import 'dart:io';

import 'package:cli/glyph_name.dart';
import 'package:cli/glyph_range.dart';
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

    codes["smufl_glyph"] = env.getTemplate("smufl_glyph.jinja").render(
      {"glyphs": glyphName.values.map((e) => e.toJson())},
    );

    // codes["hello"] = env.getTemplate("hello.jinja").render({
    //   "title": "Jinja and Flask",
    // });

    return codes;
  }
}
