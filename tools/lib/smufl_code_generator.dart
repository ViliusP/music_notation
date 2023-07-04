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
    env.filters['capitalizeFirst'] = _capitalizeFirstFilter;
    env.filters['underscoreToCamel'] = _underscoreToCamelFilter;
    env.filters['toUnderscoreCase'] = toUnderscoreCase;

    Map<String, String> codes = {};

    codes["smufl_glyph"] = env.getTemplate("smufl_glyph.jinja").render(
      {"glyphs": glyphName.values.map((e) => e.toJson())},
    );

    codes["ranges"] = env.getTemplate("smufl_ranges.jinja").render(
      {"ranges": glyphRange.values.map((e) => e.toJson())},
    );

    codes["glyph_class"] = env.getTemplate("smufl_class.jinja").render(
      {"classes": classes.keys},
    );

    for (var entry in classes.entries) {
      String filename = toUnderscoreCase(entry.key);

      codes["classes/$filename"] =
          env.getTemplate("concrete_smufl_class.jinja").render(
        {
          "name": entry.key,
          "glyphs": entry.value,
        },
      );
    }

    return codes;
  }

  String _capitalizeFirstFilter(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  String _underscoreToCamelFilter(String value) {
    if (value.isEmpty) {
      return value;
    }

    var parts = value.split('_');
    var camelCase = parts[0].toLowerCase();

    for (var i = 1; i < parts.length; i++) {
      camelCase += parts[i].substring(0, 1).toUpperCase() +
          parts[i].substring(1).toLowerCase();
    }

    return camelCase;
  }

  static String toUnderscoreCase(String value) {
    if (value.isEmpty) {
      return value;
    }

    var result = StringBuffer();
    bool? isPreviousLowercase;
    bool? isPreviousDigit = false;

    for (int i = 0; i < value.length; i++) {
      bool? isNextLowercase;
      if (i + 1 < value.length) {
        final nextChar = value[i + 1];

        isNextLowercase = nextChar.toUpperCase() != nextChar &&
            nextChar.toLowerCase() == nextChar;
      }
      final char = value[i];
      final isUppercase =
          char.toUpperCase() == char && char.toLowerCase() != char;
      final isDigit = char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;

      if (isNextLowercase == true &&
          isUppercase &&
          isPreviousLowercase == false) {
        result.write('_');
      }

      if (isPreviousLowercase == true && (isUppercase || isDigit)) {
        result.write('_');
      }

      if (isPreviousDigit == true && !isUppercase && !isDigit) {
        result.write('_');
      }

      if (!isDigit && !isUppercase) {
        isPreviousLowercase = true;
      } else {
        isPreviousLowercase = false;
      }

      isPreviousDigit = isDigit;

      result.write(char);
    }

    return result.toString().toLowerCase();
  }
}
