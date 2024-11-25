import 'package:flutter/rendering.dart';

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
}
