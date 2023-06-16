import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';

/// The image type is used to include graphical images in a score.
class Image implements DirectionType {
  String source;

  String type;

  double height;

  double width;

  Position position;

  HorizontalAlignment horizontalAlignment;

  VerticalImageAlignment verticalAlignment;

  String? id;

  Image({
    required this.source,
    required this.type,
    required this.height,
    required this.width,
    required this.position,
    required this.horizontalAlignment,
    required this.verticalAlignment,
    required this.id,
  });
}

/// The valign-image type is used to indicate vertical alignment for images and graphics,
/// so it does not include a baseline value.
///
/// Defaults are implementation-dependent.

enum VerticalImageAlignment {
  top,
  middle,
  bottom;

  static VerticalImageAlignment fromString(String value) {
    for (var element in VerticalImageAlignment.values) {
      if (element.name.contains(value)) return element;
    }
    // TODO: better exception
    throw "Invalid VerticalAlignment value: $value";
  }
}
