import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Clefs are represented by a combination of sign, line, and clef octave change.
///
/// Sometimes clefs are added to the staff in non-standard line positions,
/// either to indicate cue passages, or when there are multiple clefs present
/// simultaneously on one staff. In this situation, the additional attribute
/// is set to true(yes) and the line value is ignored.
class Clef {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The sign element represents the clef symbol.
  ClefSign sign;

  /// Line numbers are counted from the bottom of the staff.
  ///
  /// They are only needed with the G, F, and C signs in order to position a pitch correctly on the staff.
  ///
  /// Standard values are 2 for the [ClefSign.G] (treble clef),
  /// 4 for the [ClefSign.F] (bass clef), and 3 for the [ClefSign.C] (alto clef).
  ///
  /// Line values can be used to specify positions outside the staff,
  /// such as a [ClefSign.C] positioned in the middle of a grand staff.
  int? _line;
  int? get line => _line ?? sign.defaultLineNumber;
  set line(int? value) {
    _line = value;
  }

  /// This is used for transposing clefs. A [ClefSign.G] for tenors would have a value of -1.
  int? octaveChange;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the staff number from top to bottom within the part.
  ///
  /// The value is 1 if not present.
  int number;

  /// The size attribute is used for clefs where the additional attribute is "yes".
  ///
  /// It is typically used to indicate cue clefs.
  SymbolSize? size;

  /// Sometimes clefs are added to the staff in non-standard line positions,
  /// either to indicate cue passages, or when there are multiple clefs present
  /// simultaneously on one staff.
  ///
  /// In this situation, the additional attribute is set to "yes" and the line value is ignored.
  ///
  /// The attribute is ignored for mid-measure clefs.
  bool? afterBarline;

  /// Sometimes clefs are added to the staff in non-standard line positions,
  /// either to indicate cue passages, or when there are multiple clefs present
  /// simultaneously on one staff.
  ///
  /// In this situation, the additional attribute is set to "yes" and the line value is ignored.
  bool? additional;

  PrintStyle printStyle;

  /// Clefs appear at the start of each system unless this property has been set
  /// to false ("no") or the additional attribute has been set to true("yes").
  bool printObject;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Clef({
    required this.sign,
    int? line,
    this.octaveChange,
    this.number = 1,
    this.size,
    this.afterBarline,
    this.additional,
    this.printStyle = const PrintStyle.empty(),
    this.printObject = true,
    this.id,
  }) : _line = line;

  Clef.G() : this(sign: ClefSign.G);
  Clef.F() : this(sign: ClefSign.F);

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'sign': XmlQuantifier.required,
    'line': XmlQuantifier.optional,
    'clef-octave-change': XmlQuantifier.optional,
  };

  factory Clef.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    // --- sign ---
    XmlElement signElement = xmlElement.getElement('sign')!;
    validateTextContent(signElement);
    ClefSign? clefSign = ClefSign.fromString(signElement.innerText);
    if (clefSign == null) {
      throw MusicXmlTypeException(
        message: "${signElement.innerText} is not clef sign",
        xmlElement: xmlElement,
      );
    }

    // --- line ---
    XmlElement? lineElement = xmlElement.getElement('line');
    validateTextContent(lineElement);
    int? line = int.tryParse(lineElement?.innerText ?? "");
    if (lineElement != null && line == null) {
      throw MusicXmlFormatException(
        message: "${lineElement.innerText} is not integer",
        xmlElement: xmlElement,
        source: lineElement.innerText,
      );
    }

    // --- clef-octave-change ---
    XmlElement? octaveChangeElement = xmlElement.getElement(
      'clef-octave-change',
    );
    validateTextContent(octaveChangeElement);
    int? octaveChange = int.tryParse(octaveChangeElement?.innerText ?? "");
    if (octaveChangeElement != null && octaveChange == null) {
      throw MusicXmlFormatException(
        message: "${octaveChangeElement.innerText} is not integer",
        xmlElement: xmlElement,
        source: octaveChangeElement.innerText,
      );
    }

    // --- number ---
    String? numberAttribute = xmlElement.getAttribute('number');
    int? number = int.tryParse(numberAttribute ?? "");
    if (numberAttribute != null && (number == null || number < 1)) {
      throw MusicXmlFormatException(
        message: "$numberAttribute is not positive integer",
        xmlElement: xmlElement,
        source: numberAttribute,
      );
    }

    // --- size ---
    String? sizeAttribute = xmlElement.getAttribute('size');
    SymbolSize? size = SymbolSize.fromString(sizeAttribute ?? "");
    if (sizeAttribute != null && size == null) {
      throw MusicXmlTypeException(
        message: "$sizeAttribute is not symbol size",
        xmlElement: xmlElement,
      );
    }

    bool? printObject = YesNo.fromXml(xmlElement, CommonAttributes.printObject);

    return Clef(
      sign: clefSign,
      line: line,
      octaveChange: octaveChange,
      number: number ?? 1,
      size: size,
      afterBarline: YesNo.fromXml(xmlElement, "after-barline"),
      additional: YesNo.fromXml(xmlElement, "additional"),
      printStyle: PrintStyle.fromXml(xmlElement),
      printObject: printObject ?? true,
      id: xmlElement.getAttribute('id'),
    );
  }
}

/// Represents the different clef symbols.
///
/// When the [none] sign is used, notes should be displayed as if in treble [G] - clef.
enum ClefSign {
  /// Treble.
  G(2),

  /// Bass.
  F(4),

  /// Alto and Tenor.
  C(3), // Tenor clef has different symbol '\uE058',

  /// Percussion, Unpitched.
  percussion(null),

  /// Indicates that the music that follows should be in tablature notation.
  tab(null),

  /// Indicates that the music that follows should be in jianpu numbered notation.
  /// A [jianpu] sign does not correspond to a visual clef notation
  jianpu(null),

  @Deprecated(
    "The none sign is deprecated as of MusicXML 4.0. Use the clef element's print-object attribute instead.",
  )
  none(null);

  const ClefSign(this.defaultLineNumber);

  final int? defaultLineNumber;

  static ClefSign? fromString(String value) {
    return values.firstWhereOrNull(
      (v) => v.name.toLowerCase() == value.toLowerCase(),
    );
  }
}
