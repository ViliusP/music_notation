import 'package:music_notation/models/generic.dart';
import 'package:music_notation/models/invalid_xml_element_exception.dart';
import 'package:music_notation/models/text.dart';
import 'package:music_notation/models/utilities.dart';
import 'package:xml/xml.dart';

/// The notehead type indicates shapes other than the open and closed ovals associated with note durations.

/// The smufl attribute can be used to specify a particular notehead, allowing application interoperability without requiring every SMuFL glyph to have a MusicXML element equivalent.
/// This attribute can be used either with the "other" value, or to refine a specific notehead value such as "cluster".
/// Noteheads in the SMuFL Note name noteheads and Note name noteheads supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the smufl attribute or the "other" value,
/// but instead use the notehead-text element.
///
/// For the enclosed shapes, the default is to be hollow for half notes and longer, and filled otherwise.
/// The filled attribute can be set to change this if needed.
///
/// If the parentheses attribute is set to yes, the notehead is parenthesized.
///
/// It is no by default.
class Notehead {
  NoteheadValue value;

  /// Changes the appearance of enclosed shapes from the default of hollow for half notes and longer, and filled otherwise.
  ///
  /// Attribute of type "yes-no". Optional.
  bool filled;

  /// If yes, the notehead is parenthesized. It is no if not specified.
  bool parentheses;

  /// Indicates a particular Standard Music Font Layout (SMuFL) character using its canonical glyph name.
  ///
  /// Sometimes this is a formatting choice, and sometimes this is a refinement of the semantic meaning of an element.
  String? smufl;

  Color color;

  Font font;

  Notehead({
    required this.value,
    required this.filled,
    this.parentheses = false,
    this.smufl,
    required this.color,
    required this.font,
  });

  factory Notehead.fromXml(XmlElement xmlElement) {
    NoteheadValue? value = NoteheadValue.fromString(xmlElement.innerText);

    if (value == null) {
      throw XmlElementRequired("Notehead value is missing");
    }

    String? parenthesesAttribute = xmlElement.getAttribute("parentheses");

    bool? parentheses = YesNo.toBool(parenthesesAttribute ?? "");

    if (parenthesesAttribute != null && parentheses == null) {
      final String message = YesNo.generateValidationError(
        "parentheses",
        parenthesesAttribute,
      );

      throw InvalidXmlElementException(message, xmlElement);
    }

    String? smuflAttribute = xmlElement.getAttribute("smufl");

    if (smuflAttribute != null && !Nmtoken.validate(smuflAttribute)) {
      final String message = Nmtoken.generateValidationError(
        "parentheses",
        smuflAttribute,
      );

      throw InvalidXmlElementException(message, xmlElement);
    }

    return Notehead(
      value: value,
      filled: _determineDefaultFilled(xmlElement),
      parentheses: false,
      smufl: smuflAttribute,
      color: Color.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
    );
  }

  static bool _determineDefaultFilled(XmlElement xmlElement) {
    // TODO
    return false;
  }
}

/// The notehead-value type indicates shapes other than the open and closed ovals associated with note durations.
///
/// The values do, re, mi, fa, fa up, so, la, and ti correspond to Aikin's 7-shape system.
///
/// The fa up shape is typically used with upstems; the fa shape is typically used with downstems or no stems.
///
/// The arrow shapes differ from triangle and inverted triangle by being centered on the stem.
///
/// Slashed and back slashed notes include both the normal notehead and a slash. The triangle shape has the tip of the triangle pointing up;
/// the inverted triangle shape has the tip of the triangle pointing down. The left triangle shape is a right triangle with the hypotenuse facing up and to the left.
///
/// The other notehead covers noteheads other than those listed here.
///
/// It is usually used in combination with the smufl attribute to specify a particular SMuFL notehead.
///
/// The smufl attribute may be used with any notehead value to help specify the appearance of symbols that share the same MusicXML semantics.
///
/// Noteheads in the SMuFL Note name noteheads and Note name noteheads supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the smufl attribute or the "other" value,
/// but instead use the notehead-text element.
enum NoteheadValue {
  slash,
  triangle,
  diamond,
  square,
  cross,
  x,
  circleX,
  invertedTriangle,
  arrowDown,
  arrowUp,
  circled,
  slashed,
  backSlashed,
  normal,
  cluster,
  circleDot,
  leftTriangle,
  rectangle,
  none,
  aikinDo,
  aikinRe,
  aikinMi,
  aikinFa,
  aikinFaUp,
  aikinSo,
  aikinLa,
  aikinTi,
  other;

  static const _map = {
    'slash': slash,
    'triangle': triangle,
    'diamond': diamond,
    'square': square,
    'cross': cross,
    'x': x,
    'circle-x': circleX,
    'inverted triangle': invertedTriangle,
    'arrow down': arrowDown,
    'arrow up': arrowUp,
    'circled': circled,
    'slashed': slashed,
    'back slashed': backSlashed,
    'normal': normal,
    'cluster': cluster,
    'circle dot': circleDot,
    'left triangle': leftTriangle,
    'rectangle': rectangle,
    'none': none,
    'do': aikinDo,
    're': aikinRe,
    'mi': aikinMi,
    'fa': aikinFa,
    'fa up': aikinFaUp,
    'so': aikinSo,
    'la': aikinLa,
    'ti': aikinTi,
    'other': other,
  };

  /// Converts provided string value to [StemValue].
  ///
  /// Returns null if that name does not exists.
  static NoteheadValue? fromString(String value) {
    return _map[value];
  }

  @override
  String toString() => inverseMap(_map)[this];
}

abstract class NoteheadTextContent {}

class NoteheadText {
  final List<NoteheadTextContent> contents;

  NoteheadText(this.contents);

  factory NoteheadText.fromXml(XmlElement element) {
    var contents = <NoteheadTextContent>[];
    for (var child in element.children) {
      if (child is XmlElement) {
        if (child.name.local == 'display-text') {
          contents.add(FormattedText.fromXml(child));
        } else if (child.name.local == 'accidental-text') {
          contents.add(AccidentalText.fromXml(child));
        }
      }
    }
    return NoteheadText(contents);
  }
}
