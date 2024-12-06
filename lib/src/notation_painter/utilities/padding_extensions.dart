import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

extension NotationPaddingExtension on EdgeInsets {
  EdgeInsets scaledByContext(BuildContext context) {
    return EdgeInsets.only(
      top: top.scaledByContext(context),
      bottom: bottom.scaledByContext(context),
      left: left.scaledByContext(context),
      right: right.scaledByContext(context),
    );
  }
}
