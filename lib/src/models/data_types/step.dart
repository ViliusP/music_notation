import 'package:collection/collection.dart';

/// The step type represents a step of the diatonic scale,
/// represented using the English letters A through G.
///
/// [step data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/step/).
enum Step {
  A,
  B,
  C,
  D,
  E,
  F,
  G;

  static Step? fromString(String value) {
    return values.firstWhereOrNull(
      (element) => element.name == value,
    );
  }

  @override
  String toString() => name;
}
