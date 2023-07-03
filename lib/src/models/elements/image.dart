import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:xml/xml.dart';

/// The image type is used to include graphical images in a score.
class Image implements DirectionType {
  /// The URL for the image file
  String source;

  /// the MIME type for the image file format.
  ///
  /// Typical choices include application/postscript, image/gif, image/jpeg, image/png, and image/tiff.
  String type;

  /// Attribute for size and scale an image
  ///
  /// The image should be scaled independently in X and Y if both height and width are specified.
  ///
  /// If only one attribute([height] or [width]) is specified,
  /// the image should be scaled proportionally to fit in the specified dimension.

  double? height;

  /// Attribute for size and scale an image
  ///
  /// The image should be scaled independently in X and Y if both height and width are specified.
  /// If only one attribute([height] or [width]) is specified,
  /// the image should be scaled proportionally to fit in the specified dimension.
  double? width;

  /// For definition, look at [Position].
  Position position;

  /// Indicates horizontal alignment to the left, center, or right of the image.
  ///
  /// Default is implementation-dependent.
  HorizontalAlignment? horizontalAlignment;

  /// Indicates vertical alignment to the top, middle, or bottom of the image.
  ///
  /// The default is implementation-dependent.
  VerticalImageAlignment? verticalAlignment;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Image({
    required this.source,
    required this.type,
    this.height,
    this.width,
    this.position = const Position.empty(),
    this.horizontalAlignment,
    this.verticalAlignment,
    this.id,
  });

  factory Image.fromXml(XmlElement xmlElement) {
    return Image(
      source: xmlElement.getAttribute('source')!,
      type: xmlElement.getAttribute('type')!,
      height: double.tryParse(xmlElement.getAttribute('height') ?? '') ?? 0,
      width: double.tryParse(xmlElement.getAttribute('width') ?? '') ?? 0,
      position: Position.fromXml(xmlElement),
      horizontalAlignment: HorizontalAlignment.fromString(
            xmlElement.getAttribute('halign') ?? "",
          ) ??
          HorizontalAlignment.right,
      verticalAlignment: VerticalImageAlignment.fromString(
        xmlElement.getAttribute('valign-image') ?? "",
      ),
      id: 'asdasdas',
    );
  }

  XmlElement toXml() {
    var element = XmlElement(XmlName('image-attributes'));

    element.attributes.add(XmlAttribute(XmlName('source'), source));
    element.attributes.add(XmlAttribute(XmlName('type'), type));

    if (height != null) {
      element.attributes.add(
        XmlAttribute(XmlName('height'), height.toString()),
      );
    }
    if (width != null) {
      element.attributes.add(
        XmlAttribute(XmlName('width'), width.toString()),
      );
    }
    // TODO position.toXml()
    if (horizontalAlignment != null) {
      element.attributes.add(
        XmlAttribute(XmlName('halign'), horizontalAlignment.toString()),
      ); // TODO check toString
    }
    if (verticalAlignment != null) {
      element.attributes.add(
        XmlAttribute(XmlName('valign-image'), verticalAlignment.toString()),
      ); // TODO check toString
    }

    return element;
  }
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
