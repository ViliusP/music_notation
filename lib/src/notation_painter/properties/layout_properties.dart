class NotationLayoutProperties {
  // ----------------------
  // CONSTANTS
  // ----------------------

  /// The default stave height for fallbacking;
  static const double _defaultStaveHeight = 48;

  static const int staveLines = 5;

  static const double baseBeamThickness = 1 / 2;

  /// The distance between accidental's left side and note's right side.
  static const double noteAccidentalDistance = 1 / 4;

  /// Stems should be thinner than the stave-line, but not so thin as to
  /// reproduce too faintly.
  static const double baseStemStrokeWidth = 0.125;

  /// The distance between elements when positional difference is 1.
  static const double baseSpacePerPosition = 1 / 2;

  /// The standard length of a stem is one octave (3.5 stave-spaces) from the
  /// centre of the notehead.
  static const double baseStandardStemLength = 3.5;

  /// TODO comment
  static const double baseWidthPerQuarter = 4;

  /// TODO comment
  static const double baseMeasurePadding = 1;

  // ----------------------
  // GETTERS
  // ----------------------

  /// The reference size value that determines sizing of musical elements.
  double get staveHeight => _staveHeight;

  final double _staveHeight;

  /// The height of a stave-space determines the size of all noteheads.
  double get staveSpace => _staveHeight / (staveLines - 1);

  /// The distance between elements when positional difference is 1.
  double get spacePerPosition => staveSpace * baseSpacePerPosition;

  double get standardStemLength => baseStandardStemLength * staveSpace;

  /// Stems should be thinner than the stave-line, but not so thin as to
  /// reproduce too faintly.
  double get stemStrokeWidth => baseStemStrokeWidth * staveSpace;

  double get staveLineThickness => 12 * 1 / 100 * staveSpace;

  // TODO: adjust correctly, currently it is magic number
  double get barlineThickness => staveLineThickness * 1.6;

  /// Beam thickness is 1/2 stave-space.
  double get beamThickness => staveSpace * baseBeamThickness;

  /// The distance between beams is 1/4 stave space.
  double get beamSpacing => staveSpace * .25;

  const NotationLayoutProperties({
    required double staveHeight,
  }) : _staveHeight = staveHeight;

  const NotationLayoutProperties.standard()
      : _staveHeight = _defaultStaveHeight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotationLayoutProperties &&
        _staveHeight == other._staveHeight;
  }

  @override
  int get hashCode => _staveHeight.hashCode;

  @override
  String toString() => 'NotationLayoutProperties(staveHeight: $staveHeight)';
}
