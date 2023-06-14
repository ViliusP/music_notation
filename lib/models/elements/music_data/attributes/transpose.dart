import 'package:music_notation/models/elements/music_data/attributes/attributes.dart';

/// The transpose type represents what must be added to a written pitch to get a correct sounding pitch.
///
/// The optional number attribute refers to staff numbers,
/// from top to bottom on the system.
///
/// If absent, the transposition applies to all staves in the part.
///
/// Per-staff transposition is most often used in parts that represent multiple instruments.
class Transpose extends Transposition {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  TransposeContent content;

  Transpose({
    required this.content,
    super.number,
    super.id,
  });

  @override
  String get name => "transpose";
}

class TransposeContent {
  /// The diatonic element specifies the number of pitch steps needed to go from written to sounding pitch.
  ///
  /// This allows for correct spelling of enharmonic transpositions.
  ///
  /// This value does not include octave-change values;
  /// the values for both elements need to be added to the written pitch to get the correct sounding pitch.
  int? diatonic;

  /// The chromatic element represents the number of semitones needed to get from written to sounding pitch.
  ///
  /// This value does not include octave-change values;
  /// the values for both elements need to be added to the written pitch to get the correct sounding pitch.
  double? chromatic;

  /// The octave-change element indicates how many octaves to add to get from written pitch to sounding pitch.
  ///
  /// The octave-change element should be included when using transposition intervals of an octave or more,
  /// and should not be present for intervals of less than an octave.
  int? octaveChange;

  /// If the double element is present,
  /// it indicates that the music is doubled one octave from what is currently written.
  bool doubled;

  TransposeContent({
    this.diatonic,
    this.chromatic,
    this.octaveChange,
    required this.doubled,
  });
}
