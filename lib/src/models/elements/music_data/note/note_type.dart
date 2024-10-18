import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Represents a graphic note type as defined in the MusicXML spec,
/// ranging from a 1024th note (shortest) to a maxima (longest).
///
/// An instance of [NoteType] has a required [value] which is the note type,
/// and an optional [size] which provides size information of the note.
///
/// For more details, refer to [The <type> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/type/).
class NoteType {
  /// Graphic note type, from a 1024th (shortest) to maxima (longest).
  final NoteTypeValue value;

  /// Indicates the note's size, which can be full, cue, grace-cue, or large.
  ///
  /// The default size is full for regular notes, grace-cue for notes containing both
  /// grace and cue elements, and cue for notes containing either a cue or a grace
  /// element, but not both.
  final SymbolSize size;

  /// Creates an instance of [NoteType] with given [value] and [size].
  const NoteType({
    required this.value,
    // TODO change default.
    this.size = SymbolSize.full,
  });

  /// Constructs an instance of [NoteType] from the given MusicXML data represented as [XmlElement].
  ///
  /// Throws a [MusicXmlTypeException] when the provided note-type value or size attribute
  /// is not valid according to the MusicXML spec.
  ///
  /// If it has invalid content (other XML element), it throws a [XmlElementContentException].
  factory NoteType.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    String rawNoteTypeValue = xmlElement.innerText;
    NoteTypeValue? noteTypeValue = NoteTypeValue.fromString(rawNoteTypeValue);

    if (noteTypeValue == null) {
      throw MusicXmlTypeException(
        message: "'note-type' element has invalid note-type-value",
        xmlElement: xmlElement,
      );
    }
    return NoteType(
      value: noteTypeValue,
      size: SymbolSize.fromXml(xmlElement) ?? SymbolSize.full,
    );
  }
}

/// Values of graphic note types as defined in MusicXML,
/// ranging from 1024th (shortest) to maxima (longest).
///
/// For more details, please refer to:
/// [note-type-value data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/note-type-value/).
enum NoteTypeValue implements Comparable<NoteTypeValue> {
  n1024th,
  n512th,
  n256th,
  n128th,
  n64th,
  n32nd,
  n16th,
  eighth,
  quarter,
  half,
  whole,
  breve,
  long,
  maxima;

  static const _map = {
    NoteTypeValue.n1024th: "1024th",
    NoteTypeValue.n512th: "512th",
    NoteTypeValue.n256th: "256th",
    NoteTypeValue.n128th: "128th",
    NoteTypeValue.n64th: "64th",
    NoteTypeValue.n32nd: "32nd",
    NoteTypeValue.n16th: "16th",
    NoteTypeValue.eighth: "eighth",
    NoteTypeValue.quarter: "quarter",
    NoteTypeValue.half: "half",
    NoteTypeValue.whole: "whole",
    NoteTypeValue.breve: "breve",
    NoteTypeValue.long: "long",
    NoteTypeValue.maxima: "maxima",
  };

  /// Constructs a [NoteTypeValue] from the given string [value].
  ///
  /// Returns `null` when the string does not match any defined note-type values.
  static NoteTypeValue? fromString(String value) {
    return _map.entries.firstWhereOrNull((e) => e.value == value)?.key;
  }

  @override
  String toString() => _map[this]!;

  @override
  int compareTo(NoteTypeValue other) {
    return index.compareTo(other.index);
  }
}
