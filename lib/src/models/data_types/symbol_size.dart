import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:xml/xml.dart';

/// Indicates full, cue, grace-cue, or large size.
///
/// If not specified, the value is full for regular notes, grace-cue for notes
/// that contain both <grace> and <cue> elements, and cue
/// for notes that contain either a <cue> or a <grace> element, but not both.
///
/// For more details go to
/// [symbol-size data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/symbol-size/).
enum SymbolSize {
  /// Generally smaller than a full-sized symbol.
  cue,

  /// Full-sized symbol
  full,

  /// Generally smaller than a cue-sized symbol.
  graceCue,

  /// Oversized symbol.
  large;

  static SymbolSize? fromString(String value) {
    return values.firstWhereOrNull((v) => v.name == hyphenToCamelCase(value));
  }

  static SymbolSize? fromXml(XmlElement xmlElement) {
    String? rawSymbolSize = xmlElement.getAttribute("size");
    if (rawSymbolSize == null) {
      return null;
    }

    SymbolSize? symbolSize = SymbolSize.fromString(rawSymbolSize);
    if (symbolSize == null) {
      throw MusicXmlTypeException(
        message: "'size' attribute is not type of symbol-size",
        xmlElement: xmlElement,
      );
    }
    return symbolSize;
  }
}
