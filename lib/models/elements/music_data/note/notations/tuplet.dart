import 'package:music_notation/models/data_types/line_shape.dart';
import 'package:music_notation/models/data_types/start_stop.dart';
import 'package:music_notation/models/elements/music_data/note/note.dart';
import 'package:music_notation/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/text.dart';

/// A tuplet element is present when a tuplet is to be displayed graphically, in addition to the sound data provided by the time-modification elements.
/// The number attribute is used to distinguish nested tuplets.
/// The bracket attribute is used to indicate the presence of a bracket.
/// If unspecified, the results are implementation-dependent.
/// The line-shape attribute is used to specify whether the bracket is straight or in the older curved or slurred style.
/// It is straight by default.
///
/// Whereas a time-modification element shows how the cumulative,
/// sounding effect of tuplets and double-note tremolos compare to the written note type,
/// the tuplet element describes how this is displayed.
/// The tuplet element also provides more detailed representation information than the time-modification element,
/// and is needed to represent nested tuplets and other complex tuplets accurately.
///
/// The show-number attribute is used to display either the number of actual notes,
/// the number of both actual and normal notes, or neither.
/// It is actual by default.
/// The show-type attribute is used to display either the actual type, both the actual and normal types, or neither.
///
/// It is none by default.
class Tuplet {
  /// The tuplet-actual element provide optional full control over how the actual part of the tuplet is displayed,
  /// including number and note type (with dots).
  ///
  /// If any of these elements are absent, their values are based on the time-modification element.
  TupletPortion? tupletActual;

  /// The tuplet-normal element provide optional full control over how the normal part of the tuplet is displayed,
  /// including number and note type (with dots).
  ///
  /// If any of these elements are absent, their values are based on the time-modification element.
  TupletPortion? tupletNormal;

  StartStop type;

  /// Distinguishes nested tuplets.
  ///
  /// Type of 'number-level'.
  int number;

  /// Indicates the presence of a bracket. If unspecified, the result is implementation-dependent.
  bool? bracket;

  /// Used to display either the actual type, both the actual and normal types, or neither.
  ///
  /// It is none if not specified.
  ShowTuplet showType = ShowTuplet.none;

  /// Used to display either the number of actual notes, the number of both actual and normal notes, or neither.
  ///
  /// It is actual if not specified.
  ShowTuplet showNumber = ShowTuplet.none;

  /// Used to specify whether the bracket is straight or in the older curved or slurred style.
  ///
  /// It is straight if not specified.
  LineShape lineShape = LineShape.straight;

  /// Attribute group.
  Position position;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement placement;

  String? id;

  Tuplet({
    this.tupletActual,
    this.tupletNormal,
    required this.type,
    required this.number,
    this.bracket,
    this.showType = ShowTuplet.none,
    this.showNumber = ShowTuplet.none,
    this.lineShape = LineShape.straight,
    required this.position,
    required this.placement,
    this.id,
  });
}

/// The tuplet-portion type provides optional full control over tuplet specifications.
///
/// It allows the number and note type (including dots) to be set for the actual and normal portions of a single tuplet.
///
/// If any of these elements are absent, their values are based on the time-modification element.
class TupletPortion {
  TupletNumber? tupletNumber;

  TupletType? tupletType;

  List<TupletDot> tupletDots = [];
}

/// The tuplet-number type indicates the number of notes for this portion of the tuplet.
class TupletNumber {
  /// xs:nonNegativeInteger.
  ///
  /// nonNegativeInteger is derived from integer by setting the value of minInclusive to be 0.
  ///
  /// This results in the standard mathematical concept of the non-negative integers.
  ///
  /// The value space of nonNegativeInteger is the infinite set {0,1,2,...}. The base type of nonNegativeInteger is integer.
  int value;

  Font font;

  Color color;

  TupletNumber({
    required this.value,
    required this.font,
    required this.color,
  });
}

/// The tuplet-type type indicates the graphical note type of the notes for this portion of the tuplet.
class TupletType {
  NoteTypeValue value;

  Font font;

  /// Indicates the color of an element.
  Color color;

  TupletType({
    required this.value,
    required this.font,
    required this.color,
  });
}

/// The tuplet-dot type is used to specify dotted tuplet types.
class TupletDot {
  Font font;

  Color color;

  TupletDot({
    required this.font,
    required this.color,
  });
}

/// The show-tuplet type indicates whether to show a part of a tuplet relating to the tuplet-actual element, both the tuplet-actual and tuplet-normal elements, or neither.
enum ShowTuplet {
  actual,
  both,
  none;
}

// <xs:simpleType name="show-tuplet">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:restriction base="xs:token">
// 		<xs:enumeration value="actual"/>
// 		<xs:enumeration value="both"/>
// 		<xs:enumeration value="none"/>
// 	</xs:restriction>
// </xs:simpleType>
