import 'package:music_notation/src/smufl/smufl_glyph.dart';

class GlyphUtilties {
  GlyphUtilties._();

  static SmuflGlyph fromRawName(String value) {
    String name = value;

    if ('0123456789'.contains(value[0])) {
      name = 'g$value';
    }

    return SmuflGlyph.values.byName(name);
  }
}
