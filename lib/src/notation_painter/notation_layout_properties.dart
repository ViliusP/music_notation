class NotationLayoutProperties {
  static const double staveHeight = 48;

  /// The height of a stave-space determines the size of all noteheads.
  static const staveSpace = staveHeight / (staffLines - 1);

  /// Noteheads height is sum of stave space and staff line stroke width.
  static const noteHeadHeight = NotationLayoutProperties.staveSpace +
      NotationLayoutProperties.staffLineStrokeWidth;

  static const int staffLines = 5;
  static const double staffLineStrokeWidth = 2;
  static const double ledgerLineWidth = 26;

  /// The standard length of a stem is one octave (3.5 stave-spaces) from the
  /// centre of the notehead.
  ///
  /// Stems for notes on more than one ledger line extend to the middle
  /// stave-line.
  ///
  /// In a double-stemmed writing context, as stems fall further outside the stave,
  /// the are progressively shortened. The shortest stem length is a sixth
  /// (2.5 stave- spaces), no stem should ever be shorten than this.
  ///
  /// In a chord context, stem length is measured from the note closest to the
  /// open end of the stem. This stem is the length it would be as a single note.
  /// Stems within the stave are one octave long (3.5 stave-spaces); stems for the
  /// notes on ledger lines reach to the middle line. Stems outside the stave are
  /// progressively shortened (as in double-stemmed writing, opposite).
  static const double standardStemHeight = staveSpace * 3.5;

  // Stems should be thinner than the stave-line, but not so thin as to
  // reproduce too faintly.
  static const double stemStrokeWidth = 1.5;

  /// Beam thicknes is 1/2 stave-space.
  static const double beamThickness = staveSpace / 2;

  /// The distance between beams is 1/4 stave space.
  static const double beamSpacing = staveSpace / 2;
}

/// Manages the spacing of symbols in a system of musical notation. The spacing
/// of symbols may vary according to how numerous they are on a system. When
/// space is limited, the distance between characters should not be less than
/// one stave-space, ensuring that no characters collide.
///
/// Rules:
///
/// 1. Notes can be placed slightly closer to a time signature than to a clef
///    or key signature.
/// 2. An accidental must be sufficiently far from a clef or a key signature
///    to avoid being mistaken for one.
/// 3. The first note or chord with an accidental may move closer to the preceding
///    symbol(s).
/// 4. When further accidentals are added these move closer to the clef.
///    However, an accidental should never be closer to a preceding symbol than
///    one stave-space.
class SymbolSpacings {
  /// Space after a clef, ranging from 1 to 1.25 stave spaces.
  static const double afterClef = 1 * NotationLayoutProperties.staveSpace;

  /// Space after a key, ranging from 1 to 1.5 stave spaces.
  static const double afterKey = 1 * NotationLayoutProperties.staveSpace;

  /// 3D matrix defining the distance before the first note based on whether a
  /// clef is present, a key signature is present, a time signature is present,
  /// and the number of preceding accidentals.
  static const List<List<List<double>>> _distancesBeforeFirstNote = [
    // For hasClef = false
    [
      // For hasKeySignature = false, hasTimeSignature = false
      [10.0, 12.0, 14.0], // For preceding accidentals: none, one, more than one
      // For hasKeySignature = false, hasTimeSignature = true
      [15.0, 17.0, 19.0],
      // For hasKeySignature = true, hasTimeSignature = false
      [20.0, 22.0, 24.0],
      // For hasKeySignature = true, hasTimeSignature = true
      [25.0, 27.0, 29.0],
    ],
    // For hasClef = true
    [
      // For hasKeySignature = false, hasTimeSignature = false
      [30.0, 32.0, 34.0],
      // For hasKeySignature = false, hasTimeSignature = true
      [35.0, 37.0, 39.0],
      // For hasKeySignature = true, hasTimeSignature = false
      [40.0, 42.0, 44.0],
      // For hasKeySignature = true, hasTimeSignature = true
      [45.0, 47.0, 49.0],
    ],
  ];

  /// Returns the spacing before the first note, determined by the presence of
  /// a clef, key signature, time signature, and the number of preceding accidentals.
  double getSpacingBeforeFirstNote({
    required bool hasClef,
    required bool hasKeySignature,
    required bool hasTimeSignature,
    required int precedingAccidentals,
  }) {
    int clefIndex = hasClef ? 1 : 0;
    int keySignatureIndex = hasKeySignature ? 1 : 0;
    int timeSignatureIndex = hasTimeSignature ? 1 : 0;

    return _distancesBeforeFirstNote[clefIndex]
        [keySignatureIndex + timeSignatureIndex * 2][precedingAccidentals];
  }
}
