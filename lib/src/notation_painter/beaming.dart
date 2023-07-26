/// Different beat strengths typically used in music notation.
enum BeatStrength {
  strong,
  weak,
  medium,
}

/// A utility class that generates beat patterns for given time signatures.
///
/// The class contains predefined patterns for simple and compound time signatures, and
/// can be used to derive the pattern of strong, weak, and medium beats in a measure of
/// music according to the time signature.
class BeatPatternGenerator {
  /// A map of common beat patterns for simple time signatures.
  ///
  /// Each key is the beat type (the number of divisions in each beat), and the corresponding
  /// value is a list of `BeatStrength` enumerations that define the strength of each beat.
  static const Map<int, List<BeatStrength>> _simplePatterns = {
    2: [BeatStrength.strong, BeatStrength.weak],
    3: [BeatStrength.strong, BeatStrength.weak, BeatStrength.weak],
    4: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak
    ],
  };

  /// A map of common beat patterns for compound time signatures.
  static const Map<int, List<BeatStrength>> _compoundPatterns = {
    6: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
    9: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
    12: [
      BeatStrength.strong,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.medium,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak,
      BeatStrength.weak
    ],
  };

  /// Generates the beat pattern for a given [beats] and [beatType].
  ///
  /// This method returns a list of [BeatStrength] enumerations that define the
  /// strength of each beat in a measure.
  static List<BeatStrength> generateBeatPattern(int beats, int beatType) {
    List<BeatStrength>? beatPattern;
    if (beats == 4) {
      beatPattern = _simplePatterns[beatType];
    } else if (beatType == 8) {
      beatPattern = _compoundPatterns[beatType];
    }
    if (beatPattern != null) return beatPattern;
    throw UnimplementedError(
      "$beats/$beatType is not supported yet",
    );
  }
}


   // int? beats = int.tryParse(timeSignature.beats);

    // if (beats == null) {
    //   throw ArgumentError.value(
    //     timeSignature.beats,
    //     "timeSignature.beats",
    //     "TimeSignature argument must have 'beats' that can be parsed to integer",
    //   );
    // }

    // int? beatType = int.tryParse(timeSignature.beatType);

    // if (beatType == null) {
    //   throw ArgumentError.value(
    //     timeSignature.beatType,
    //     "timeSignature.beatType",
    //     "TimeSignature argument must have 'beatType' that can be parsed to integer",
    //   );
    // }