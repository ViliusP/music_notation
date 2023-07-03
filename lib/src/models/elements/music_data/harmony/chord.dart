import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/harmony/harmony.dart';
import 'package:music_notation/src/models/elements/style_text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:xml/xml.dart';

/// A harmony element can contain many stacked chords (e.g. V of II).
///
/// A sequence of harmony-chord groups is used for this type of secondary function,
/// where V of II would be represented by a harmony-chord with a 5 numeral followed
/// by a harmony-chord with a 2 numeral.
///
/// A root is a pitch name like C, D, E,
/// while a numeral is a scale degree like 1, 2, 3.
/// The root element is generally used with pop chord symbols,
/// while the numeral element is generally
/// used with classical functional harmony and Nashville numbers.
/// It is an either/or choice to avoid data inconsistency.
/// The function element, which represents Roman numerals with roman numeral text,
/// has been deprecated as of MusicXML 4.0.
abstract class HarmonyChord {
  Kind kind;

  Inversion? inversion;

  Bass? bass;

  List<Degree> degree;

  HarmonyChord({
    required this.kind,
    this.inversion,
    this.bass,
    this.degree = const [],
  });

  static HarmonyChord fromXml(XmlElement xmlElement) {
    switch (xmlElement.name.local) {
      case "root":
        return HarmonyRootChord.fromXml(xmlElement);
      case "numeral":
        return HarmonyNumeralChord.fromXml(xmlElement);
      case "function":
        return HarmonyFunctionChord.fromXml(xmlElement);

      default:
        throw ("Hello world"); // TODO
    }
  }
}

/// The root type indicates a pitch like C, D, E vs. a scale degree like 1, 2, 3.
///
/// It is used with chord symbols in popular music.
///
/// The root element has a root-step and
/// optional root-alter element similar to the step and alter elements,
/// but renamed to distinguish the different musical meanings.
class HarmonyRootChord extends HarmonyChord {
  StyledStep rootStep;

  /// The root-alter element represents the chromatic alteration of the root of
  /// the current chord within the harmony element.
  ///
  /// In some chord styles, the text for the root-step element may include root-alter information.
  ///
  /// In that case, the print-object attribute of the root-alter element can be set to no.
  ///
  /// The location attribute indicates whether the alteration should appear to the left or the right of the root-step;
  ///
  /// it is right by default.
  HarmonyAlter? rootAlter;

  HarmonyRootChord({
    required this.rootStep,
    this.rootAlter,
    required super.kind,
    super.degree,
  });

  static HarmonyRootChord fromXml(XmlElement xmlElement) {
    return HarmonyRootChord(
      kind: Kind.fromXml(xmlElement),
      rootStep: StyledStep.fromXml(xmlElement),
    );
  }
}

/// The numeral type represents the Roman numeral or Nashville number part of a harmony.
///
/// It requires that the key be specified in the encoding, either with a key or numeral-key element.
class HarmonyNumeralChord extends HarmonyChord {
  /// The numeral-value type represents a Roman numeral or
  /// Nashville number value as a positive integer from 1 to 7.
  NumeralRoot value;

  /// The numeral-alter element represents an alteration to the numeral-root,
  /// similar to the alter element for a pitch.
  ///
  /// The print-object attribute can be used to hide an alteration in cases
  /// such as when the MusicXML encoding of a 6 or 7 numeral-root in a minor key
  /// requires an alteration that is not displayed.
  ///
  /// The location attribute indicates whether
  /// the alteration should appear to the left or the right of the numeral-root.
  /// It is left by default.
  HarmonyAlter? harmonyAlter;

  NumeralKey? key;

  HarmonyNumeralChord({
    required this.value,
    this.harmonyAlter,
    this.key,
    required super.kind,
    super.degree,
  });

  static HarmonyNumeralChord fromXml(XmlElement xmlElement) {
    return HarmonyNumeralChord(
      value: NumeralRoot.fromXml(xmlElement),
      kind: Kind.fromXml(xmlElement),
    );
  }
}

/// The numeral-root type represents the Roman numeral or
/// Nashville number as a positive integer from 1 to 7.
///
/// The text attribute indicates how the numeral should appear in the score.
///
/// A numeral-root value of 5 with a kind of major would have a text attribute of "V"
/// if displayed as a Roman numeral, and "5" if displayed as a Nashville number.
/// If the text attribute is not specified, the display is application-dependent.
class NumeralRoot {
  int value;

  String? text;

  PrintStyle printStyle;

  NumeralRoot({
    required this.value,
    this.text,
    required this.printStyle,
  });

  factory NumeralRoot.fromXml(XmlElement xmlElement) {
    return NumeralRoot(
      value: 1,
      printStyle: PrintStyle.fromXml(xmlElement),
    );
  }
}

/// The numeral-key type is used when the key for the numeral is different
/// than the key specified by the key signature.
///
/// The numeral-fifths element specifies the key in the same way as the fifths element.
///
/// The numeral-mode element specifies the mode similar to the mode element,
/// but with a restricted set of values
class NumeralKey {
  /// The fifths type represents the number of flats or sharps in a traditional key signature.
  ///
  /// Negative numbers are used for flats and positive numbers for sharps,
  /// reflecting the key's placement within the circle of fifths (hence the type name).
  int fifths;

  NumeralMode numeralMode;

  bool printObject;

  NumeralKey({
    required this.fifths,
    required this.numeralMode,
    required this.printObject,
  });
}

/// The numeral-mode type specifies the mode similar to the mode type,
/// but with a restricted set of values.
///
/// The different minor values are used to interpret numeral-root values of 6 and 7 when present in a minor key.
///
/// The harmonic minor value sharpens the 7 and the melodic minor value sharpens both 6 and 7.
///
/// If a minor mode is used without qualification,
/// either in the mode or numeral-mode elements, natural minor is used.
enum NumeralMode {
  /// Numerals are interpreted relative to a major scale.
  major,

  /// Numerals are interpreted relative to a natural minor scale.
  minor,

  /// Numerals are interpreted relative to a natural minor scale.
  naturalMinor,

  /// Numerals are interpreted relative to an ascending melodic minor scale with raised 6th and 7th degrees.
  melodicMinor,

  /// Numerals are interpreted relative to a harmonic minor scale with a raised 7th degree.
  harmonicMinor;
}

/// The function element represents classical functional harmony with an indication
/// like I, II, III rather than C, D, E.
///
/// It represents the Roman numeral part of a functional harmony
/// rather than the complete function itself.
@Deprecated(
  "It has been deprecated as of MusicXML 4.0 in favor of the numeral element",
)
class HarmonyFunctionChord extends HarmonyChord {
  String value;

  PrintStyle printStyle;

  HarmonyFunctionChord({
    required this.value,
    required this.printStyle,
    required super.kind,
  });

  static HarmonyFunctionChord fromXml(XmlElement xmlElement) {
    return HarmonyFunctionChord(
      value: xmlElement.innerText,
      printStyle: PrintStyle.fromXml(xmlElement),
      kind: Kind.fromXml(xmlElement),
    );
  }
}

/// The degree type is used to add, alter, or subtract individual notes in the chord.
///
/// The print-object attribute can be used to keep the degree
/// from printing separately when it has already taken into account in the text attribute of the kind element.
///
/// The degree-value and degree-type text attributes specify how the value and type of the degree should be displayed.
///
/// A harmony of kind "other" can be spelled explicitly by using a series of degree elements together with a root.
class Degree {
  DegreeValue value;

  DegreeAlter alter;

  DegreeType type;

  bool printObject;

  Degree({
    required this.value,
    required this.alter,
    required this.type,
    required this.printObject,
  });
}

/// The content of the degree-value type is a number indicating the degree of
/// the chord (1 for the root, 3 for third, etc).
///
/// The text attribute specifies how the value of the degree should be displayed.
///
/// The symbol attribute indicates that a symbol should be used in specifying the degree.
///
/// If the symbol attribute is present, the value of the text attribute follows the symbol.
class DegreeValue {
  int value;

  /// Indicates that a symbol should be used in specifying the degree.
  DegreeSymbolValue symbol;

  /// Specifies how the value of the degree should be displayed.
  ///
  /// If the symbol attribute is present, the value of the text attribute follows the symbol.
  String text;

  PrintStyle printStyle;

  DegreeValue({
    required this.value,
    required this.symbol,
    required this.text,
    required this.printStyle,
  });
}

/// The degree-alter type represents the chromatic alteration for the current degree.
///
/// If the degree-type value is alter or subtract,
/// the degree-alter value is relative to the degree already in the chord based on its kind element.
///
/// If the degree-type value is add, the degree-alter is relative to a dominant chord
/// (major and perfect intervals except for a minor seventh).
///
/// The plus-minus attribute is used to indicate if plus and minus symbols should be used
/// instead of sharp and flat symbols to display the degree alteration. It is no if not specified.
class DegreeAlter {
  /// The semitones type is a number representing semitones, used for chromatic alteration.
  ///
  /// A value of -1 corresponds to a flat and a value of 1 to a sharp.
  ///
  /// Decimal values like 0.5 (quarter tone sharp) are used for microtones.
  double semitones;

  PrintStyle printStyle;

  bool plusMinus;

  DegreeAlter({
    required this.semitones,
    required this.printStyle,
    required this.plusMinus,
  });
}

/// The degree-type type indicates if this degree is an addition, alteration,
/// or subtraction relative to the kind of the current chord.
///
/// The value of the degree-type element affects the interpretation of the value of the degree-alter element.
///
/// The text attribute specifies how the type of the degree should be displayed.
class DegreeType {
  DegreeTypeValue value;

  String text;

  PrintStyle printStyle;

  DegreeType({
    required this.value,
    required this.text,
    required this.printStyle,
  });
}

/// The degree-type-value type indicates whether the current degree element is an addition,
/// alteration, or subtraction to the kind of the current chord in the harmony element.
enum DegreeTypeValue {
  add,
  alter,
  substract;
}

/// The degree-symbol-value type indicates which symbol should be used in specifying a degree.
enum DegreeSymbolValue {
  major,
  minor,
  augmented,
  diminished,
  halfDiminished;
}

/// Kind indicates the type of chord. Degree elements can then add, subtract,
/// or alter from these starting points.
///
/// The attributes are used to indicate the formatting of the symbol.
/// Since the kind element is the constant in all the harmony-chord groups
/// that can make up a polychord, many formatting attributes are here.
///
/// For the major-minor kind, only the minor symbol is used when use-symbols is yes.
/// The major symbol is set using the symbol attribute in the degree-value element.
/// The corresponding degree-alter value will usually be 0 in this case.
///
/// The text attribute describes how the kind should be spelled in a score.
/// If use-symbols is yes, the value of the text attribute follows the symbol.
/// The stack-degrees attribute is yes if the degree elements should be stacked above each other.
/// The parentheses-degrees attribute is yes if all the degrees should be in parentheses.
/// The bracket-degrees attribute is yes if all the degrees should be in a bracket.
/// If not specified, these values are implementation-specific.
/// The alignment attributes are for the entire harmony-chord group of which this kind element is a part.
///
/// The text attribute may use strings such as "13sus" that refer to both the kind
/// and one or more degree elements.
///
/// In this case, the corresponding degree elements should have the print-object attribute set to "no"
/// to keep redundant alterations from being displayed.
class Kind {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  KindValue value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The use-symbols attribute is yes if the kind should be represented
  /// when possible with harmony symbols rather than letters and numbers.
  ///
  /// These symbols include:
  /// - major: a triangle, like Unicode 25B3
  /// - minor: -, like Unicode 002D
  /// - augmented: +, like Unicode 002B
  /// - diminished: °, like Unicode 00B0
  /// - half-diminished: ø, like Unicode 00F8
  bool? useSymbols;

  /// Describes how the [Kind] should be spelled in a score.
  ///
  /// If the [useSymbols] attribute is true, this value follows the symbol.
  ///
  /// The default is implementation-dependent.
  String? text;

  /// If yes, the [Degree] elements should be stacked above each other.
  ///
  /// The default is implementation-dependent.
  bool? stackDegree;

  /// The parentheses-degrees attribute is yes if all the degrees should be in parentheses.
  ///
  /// The default is implementation-dependent.
  bool? parenthesesDegrees;

  /// The bracket-degrees attribute is yes if all the degrees should be in a bracket.
  ///
  /// The default is implementation-dependent.
  bool? bracketDegrees;

  PrintStyle printStyle;

  HorizontalAlignment? horizontalAlignment;

  VerticalAlignment? verticalAlignment;

  Kind({
    required this.value,
    this.useSymbols,
    this.text,
    this.stackDegree,
    this.parenthesesDegrees,
    required this.printStyle,
    this.horizontalAlignment,
    this.verticalAlignment,
  });

  factory Kind.fromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.value;

    if (rawValue == null) {
      throw XmlElementContentException(
        message: "The <kind> element must have content",
        xmlElement: xmlElement,
      );
    }

    KindValue? value = KindValue.fromString(rawValue);

    if (value == null) {
      throw XmlElementContentException(
        message: "The <kind> element must have correct content",
        xmlElement: xmlElement,
      );
    }

    return Kind(
      value: value,
      printStyle: PrintStyle.fromXml(xmlElement),
    );
  }
}

/// A kind-value indicates the type of chord.
/// Degree elements can then add, subtract, or alter from these starting points.
///
/// Values include:
/// - Triads:
///	  - major (major third, perfect fifth)
///	  - minor (minor third, perfect fifth)
///   - augmented (major third, augmented fifth)
///   - diminished (minor third, diminished fifth)
/// - Sevenths:
///	  - dominant (major triad, minor seventh)
///	  - major-seventh (major triad, major seventh)
///	  - minor-seventh (minor triad, minor seventh)
///	  - diminished-seventh (diminished triad, diminished seventh)
///   - augmented-seventh (augmented triad, minor seventh)
///   - half-diminished (diminished triad, minor seventh)
///   - major-minor (minor triad, major seventh)
/// - Sixths:
/// 	- major-sixth (major triad, added sixth)
/// 	- minor-sixth (minor triad, added sixth)
/// - Ninths:
/// 	- dominant-ninth (dominant-seventh, major ninth)
/// 	- major-ninth (major-seventh, major ninth)
/// 	- minor-ninth (minor-seventh, major ninth)
/// - 11ths (usually as the basis for alteration):
/// 	- dominant-11th (dominant-ninth, perfect 11th)
/// 	- major-11th (major-ninth, perfect 11th)
/// 	- minor-11th (minor-ninth, perfect 11th)
/// - 13ths (usually as the basis for alteration):
/// 	- dominant-13th (dominant-11th, major 13th)
/// 	- major-13th (major-11th, major 13th)
/// 	- minor-13th (minor-11th, major 13th)
/// - Suspended:
/// 	- suspended-second (major second, perfect fifth)
/// 	- suspended-fourth (perfect fourth, perfect fifth)
/// - Functional sixths:
/// 	- Neapolitan
/// 	- Italian
/// 	- French
/// 	- German
/// - Other:
/// 	- pedal (pedal-point bass)
/// 	- power (perfect fifth)
/// 	- Tristan
///
/// The "other" kind is used when the harmony is entirely composed of add elements.
///
/// The "none" kind is used to explicitly encode absence of chords or functional harmony.
///
/// In this case, the root, numeral, or function element has no meaning.
/// When using the root or numeral element, the root-step
/// or numeral-step text attribute should be set to the empty string to keep the root or numeral from being displayed.
enum KindValue {
  major,
  minor,
  augmented,
  diminished,
  dominant,
  majorSeventh,
  minorSeventh,
  diminishedSeventh,
  augmentedSeventh,
  halfDiminished,
  majorMinor,
  majorSixth,
  minorSixth,
  dominantNinth,
  majorNinth,
  minorNinth,
  dominant11th,
  major11th,
  minor11th,
  dominant13th,
  major13th,
  minor13th,
  suspendedSecond,
  suspendedFourth,
  neapolitan,
  italian,
  french,
  german,
  pedal,
  power,
  tristan,
  other,
  none;

  static KindValue? fromString(String value) {
    throw UnimplementedError();
  }
}

/// The inversion type represents harmony inversions.
///
/// The value is a number indicating which inversion is used:
/// 0 for root position, 1 for first inversion, etc.
///
/// The text attribute indicates how the inversion should be displayed in a score.
class Inversion {
  int value;

  String text;

  PrintStyle printStyle;

  Inversion({
    required this.value,
    required this.text,
    required this.printStyle,
  });
}

/// The bass type is used to indicate a bass note in popular music chord symbols, e.g. G/C.
///
/// It is generally not used in functional harmony,
/// as inversion is generally not used in pop chord symbols.
///
/// As with root, it is divided into step and alter elements, similar to pitches.
///
/// The arrangement attribute specifies where the bass is displayed relative to what precedes it.
class Bass {
  /// The optional bass-separator element indicates that text,
  /// rather than a line or slash, separates the bass from what precedes it.
  StyleText? separator;

  StyledStep step;

  /// The bass-alter element represents the chromatic alteration of
  /// the bass of the current chord within the harmony element.
  ///
  /// In some chord styles, the text for the bass-step element may include bass-alter information.
  ///
  /// In that case, the print-object attribute of the bass-alter element can be set to no.
  ///
  /// The location attribute indicates whether the alteration should appear
  /// to the left or the right of the bass-step; it is right if not specified.
  HarmonyAlter? alter;

  /// Specifies where the bass is displayed relative to what precedes it.
  HarmonyArrangement? arrangement;

  Bass({
    this.separator,
    required this.step,
    this.alter,
    this.arrangement,
  });
}

/// [StyledStep] type represents the pitch step of the bass/root of the current chord within the harmony element.
///
/// The text attribute indicates how the bass/root should appear in a score if not using the element contents.
///
/// In musicXML it does correspond to 'bass-step' and 'root-step'.
class StyledStep {
  Step value;

  /// Indicates how the root should appear in a score if not using the element contents.
  String? text;

  PrintStyle printStyle;

  StyledStep({
    required this.value,
    this.text,
    required this.printStyle,
  });

  factory StyledStep.fromXml(XmlElement xmlElement) {
    return StyledStep(
      value: Step.A,
      printStyle: PrintStyle.fromXml(xmlElement),
    );
  }
}
