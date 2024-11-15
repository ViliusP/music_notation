import 'package:flutter/rendering.dart';

extension SizeExtensions on Size {
  Size round() {
    return Size(width.roundToDouble(), height.roundToDouble());
  }
}
