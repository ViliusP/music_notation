class NotationLayoutProperties {
  /// The default stave height for fallbacking;
  static const double defaultStaveHeight = 48;

  /// The default height of a stave-space determines the size of all noteheads.
  static const defaultStaveSpace = defaultStaveHeight / (staveLines - 1);

  static const int staveLines = 5;
  static const double defaultstaffLineStrokeWidth =
      12 * NotationLayoutProperties.defaultStaveSpace / 100;

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
  static double get standardStemLength => defaultStaveSpace * 3.5;

  // Stems should be thinner than the stave-line, but not so thin as to
  // reproduce too faintly.
  static const double defaultStemStrokeWidth = 1.5;

  /// Beam thicknes is 1/2 stave-space.
  static const double defaultBeamThickness = defaultStaveSpace / 2;

  /// The distance between beams is 1/4 stave space.
  static const double defaultBeamSpacing = defaultStaveSpace / 2;

  /// The reference size value that determines sizing of musical elements.
  double get staveHeight => _effectiveStaveHeight;

  final double _effectiveStaveHeight;

  /// The height of a stave-space determines the size of all noteheads.
  double get staveSpace => _effectiveStaveHeight / (staveLines - 1);

  /// The distance between between elements when positional difference is 1.
  double get offsetPerPosition => staveSpace / 2;

  const NotationLayoutProperties({
    required double staveHeight,
  }) : _effectiveStaveHeight = staveHeight;
}
