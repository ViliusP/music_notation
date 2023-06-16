import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:xml/xml.dart';

/// The note-type type indicates the graphic note type. Values range from 1024th to maxima. The size attribute indicates full, cue, grace-cue, or large size.
///
/// The default is full for regular notes, grace-cue for notes that contain both grace and cue elements, and cue for notes that contain either a cue or a grace element, but not both.
class NoteType {
  final NoteTypeValue value;
  final SymbolSize size;

  NoteType({
    required this.value,
    this.size = SymbolSize.full,
  });

  factory NoteType.fromXml(XmlElement xmlElement) {
    return NoteType(
      value: NoteTypeValue.maxima,
    );
  }
}

/// The note-type-value type is used for the MusicXML type element and represents the graphic note type,
/// from 1024th (shortest) to maxima (longest).
enum NoteTypeValue {
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

  static NoteTypeValue? fromString(String str) {
    return _map.entries.firstWhereOrNull((e) => e.value == str)?.key;
  }

  @override
  String toString() => _map[this]!;
}
