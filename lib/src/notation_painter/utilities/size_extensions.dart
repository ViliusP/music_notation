import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

extension SizeExtensions on Size {
  Size round({bool ignoreWidth = false, bool ignoreHeight = false}) {
    return Size(
      ignoreWidth ? width : width.roundToDouble(),
      ignoreHeight ? height : height.roundToDouble(),
    );
  }

  Size ceil({bool ignoreWidth = false, bool ignoreHeight = false}) {
    return Size(
      ignoreWidth ? width : width.ceilToDouble(),
      ignoreHeight ? height : height.ceilToDouble(),
    );
  }

  Size scale(double scale) {
    return Size(width * scale, height * scale);
  }

  Size scaledByContext(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return scale(layoutProperties.staveSpace);
  }
}
