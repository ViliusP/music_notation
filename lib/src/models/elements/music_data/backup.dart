import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// Represents the `<backup>` element in MusicXML, which is used to manage
/// the positioning of multiple voices or staves within a single measure.
///
/// The `<backup>` element moves the current position backward in time by a
/// specified duration, allowing for the introduction of new voices or staves
/// that start earlier within the measure.
///
/// **Constraints:**
/// - The `duration` must be a positive number.
/// - The `duration` should not cause the cursor to cross measure boundaries
///   or interfere with changes in the divisions value within the measure.
///
/// **Example Usage:**
/// ```xml
/// <backup>
///   <duration>4</duration>
/// </backup>
/// ```
class Backup implements MusicDataElement {
  /// The duration by which to move the cursor backward. This value must be
  /// positive and aligns with the smallest duration unit defined in the
  /// `<divisions>` element of the measure.
  final double duration;

  /// Optional editorial information associated with the `<backup>` element,
  /// such as footnotes, expressions, or other annotations.
  final Editorial? editorial;

  /// Constructs a [Backup] instance with the specified [duration] and optional [editorial].
  ///
  /// - [duration]: The positive duration to move the cursor backward.
  /// - [editorial]: Optional editorial annotations.
  Backup({
    required this.duration,
    this.editorial,
  });

  /// Creates a [Backup] instance from an [XmlElement].
  ///
  /// Parses the `<duration>` element and any child `<editorial>` elements
  /// within the `<backup>` element.
  ///
  /// **Example XML:**
  /// ```xml
  /// <backup>
  ///   <duration>4</duration>
  ///   <editorial>
  ///     <!-- Editorial content -->
  ///   </editorial>
  /// </backup>
  /// ```
  ///
  /// **Throws:**
  /// - `FormatException` if the `<duration>` element is missing or not a valid number.
  factory Backup.fromXml(XmlElement xmlElement) {
    // Extract the <duration> element and parse its value.
    final durationElement = xmlElement.getElement('duration');
    if (durationElement == null) {
      throw MusicXmlFormatException(
        message: "'The <backup> element is missing a <duration> child.'",
        xmlElement: xmlElement,
      );
    }

    final durationText = durationElement.innerText;
    final durationValue = double.tryParse(durationText);
    if (durationValue == null || durationValue <= 0) {
      throw MusicXmlTypeException(
        message:
            'Invalid <duration> value in <backup>: "$durationText". It must be a positive number.',
        xmlElement: xmlElement,
      );
    }

    // Extract the <editorial> element if present.
    final editorial = Editorial.fromXml(xmlElement);

    return Backup(
      duration: durationValue,
      editorial: editorial,
    );
  }

  /// Converts the [Backup] instance into an [XmlElement] representing
  /// the `<backup>` element in MusicXML.
  ///
  /// **Generated XML:**
  /// ```xml
  /// <backup>
  ///   <duration>4</duration>
  ///   <editorial>
  ///     <!-- Editorial content -->
  ///   </editorial>
  /// </backup>
  /// ```
  @override
  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('backup', nest: () {
      // Add the <duration> element.
      builder.element('duration', nest: duration.toInt());

      // Add the <editorial> element if it exists.
      if (editorial != null) {
        // TODO: implement editorial.toXml()
        // builder.element('editorial', nest: editorial!.toXml().children);
      }
    });

    return builder.buildDocument().rootElement;
  }
}
