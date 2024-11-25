import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';

extension SizeExtensions on Size {
  Size round() {
    return Size(width.roundToDouble(), height.roundToDouble());
  }

  Size ceil() {
    return Size(width.ceilToDouble(), height.ceilToDouble());
  }

  Size scale(double scale) {
    return Size(width * scale, height * scale);
  }

  Size byContext(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return scale(layoutProperties.staveSpace);
  }
}
