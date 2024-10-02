// File: lib/src/models/elements/music_data/forward.dart

import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// Represents the `<forward>` element in MusicXML, which is used to advance
/// the current cursor position in musical time without specifying actual notes
/// or rests. This is essential for managing multiple voices or staves within
/// a single measure.
///
/// **Constraints:**
/// - The `duration` must be a positive number.
/// - The `duration` should not cause the cursor to cross measure boundaries
///   or interfere with changes in the divisions value within the measure.
///
/// **Example Usage:**
/// ```xml
/// <forward>
///   <duration>4</duration>
/// </forward>
/// ```
class Forward implements MusicDataElement {
  /// The duration by which to move the cursor forward. This value must be
  /// positive and aligns with the smallest duration unit defined in the
  /// `<divisions>` element of the measure.
  final double duration;

  /// Optional staff assignment, required only for music notated on multiple staves.
  /// Staff values are integers, where 1 refers to the top-most staff in a part.
  final int? staff;

  /// Optional editorial information associated with the `<forward>` element,
  /// such as footnotes, expressions, or other annotations.
  final EditorialVoice editorialVoice;

  /// Constructs a [Forward] instance with the specified [duration], optional [staff],
  /// and optional [editorial].
  ///
  /// - [duration]: The positive duration to move the cursor forward.
  /// - [staff]: Optional staff number.
  /// - [editorial]: Optional editorial annotations.
  const Forward({
    required this.duration,
    this.staff,
    this.editorialVoice = const EditorialVoice.empty(),
  });

  /// Creates a [Forward] instance from an [XmlElement].
  ///
  /// Parses the `<duration>`, `<staff>`, and `<editorial>` elements within the `<forward>` element.
  ///
  /// **Example XML:**
  /// ```xml
  /// <forward>
  ///   <duration>4</duration>
  ///   <staff>1</staff>
  ///   <editorial>
  ///     <footnote>Forwarding duration.</footnote>
  ///   </editorial>
  /// </forward>
  /// ```
  ///
  /// **Throws:**
  /// - [MissingXmlAttribute] if a required attribute is missing.
  /// - [XmlElementContentException] if the element has invalid or unexpected content.
  /// - [MusicXmlFormatException] if the content cannot be parsed into the expected type.
  factory Forward.fromXml(XmlElement xmlElement) {
    // Ensure the element is not empty.
    if (xmlElement.childElements.isEmpty) {
      throw XmlElementContentException(
        message: 'The <forward> element is unexpectedly empty.',
        xmlElement: xmlElement,
      );
    }

    // Parse <duration>
    final durationElement = xmlElement.getElement('duration');
    if (durationElement == null) {
      throw XmlElementContentException(
        message: 'The <forward> element is missing a <duration> child.',
        xmlElement: xmlElement,
      );
    }

    final durationText = durationElement.innerText.trim();
    final durationValue = double.tryParse(durationText);
    if (durationValue == null) {
      throw MusicXmlFormatException(
        message:
            'The <duration> element contains a non-numeric value: "$durationText".',
        xmlElement: durationElement,
      );
    }
    if (durationValue <= 0) {
      throw MusicXmlFormatException(
        message:
            'The <duration> value must be positive. Found: "$durationValue".',
        xmlElement: durationElement,
      );
    }

    // Parse optional <staff>
    int? staffValue;
    final staffElement = xmlElement.getElement('staff');
    if (staffElement != null) {
      final staffText = staffElement.innerText.trim();
      final parsedStaff = int.tryParse(staffText);
      if (parsedStaff == null) {
        throw MusicXmlFormatException(
          message:
              'The <staff> element contains a non-integer value: "$staffText".',
          xmlElement: staffElement,
        );
      }
      if (parsedStaff <= 0) {
        throw MusicXmlFormatException(
          message:
              'The <staff> value must be a positive integer. Found: "$parsedStaff".',
          xmlElement: staffElement,
        );
      }
      staffValue = parsedStaff;
    }

    // Parse optional <editorial>
    EditorialVoice? editorialValue;
    try {
      editorialValue = EditorialVoice.fromXml(xmlElement);
    } on MusicXmlException catch (e) {
      // Rethrow with context
      throw XmlElementContentException(
        message: 'Error parsing <editorial> within <forward>: ${e.message}',
        xmlElement: xmlElement,
      );
    }

    return Forward(
      duration: durationValue,
      staff: staffValue,
      editorialVoice: editorialValue,
    );
  }

  /// Converts the [Forward] instance into an [XmlElement] representing
  /// the `<forward>` element in MusicXML.
  ///
  /// **Generated XML:**
  /// ```xml
  /// <forward>
  ///   <duration>4</duration>
  ///   <staff>1</staff> <!-- Optional -->
  ///   <editorial>
  ///     <!-- Editorial content -->
  ///   </editorial> <!-- Optional -->
  /// </forward>
  /// ```
  @override
  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('forward', nest: () {
      // Add <duration>
      builder.element('duration', nest: duration.toInt());

      // Add <staff> if present
      if (staff != null) {
        builder.element('staff', nest: staff.toString());
      }

      // Add <editorial> if present
      // if (editorial != null) {
      //   builder.element('editorial', nest: editorial!.toXml().children);
      // }
    });

    return builder.buildDocument().rootElement;
  }
}
