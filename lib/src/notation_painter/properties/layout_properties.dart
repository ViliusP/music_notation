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
  static double get standardStemLength => defaultStaveSpace * 3.5;

  /// Stems should be thinner than the stave-line, but not so thin as to
  /// reproduce too faintly.
  static const double defaultStemStrokeWidth = 1.5;

  /// Beam thickness is 1/2 stave-space.
  static const double defaultBeamThickness = defaultStaveSpace / 2;

  /// The distance between beams is 1/4 stave space.
  static const double defaultBeamSpacing = defaultStaveSpace / 2;

  /// The reference size value that determines sizing of musical elements.
  double get staveHeight => _effectiveStaveHeight;

  final double _effectiveStaveHeight;

  /// The height of a stave-space determines the size of all noteheads.
  double get staveSpace => _effectiveStaveHeight / (staveLines - 1);

  /// The distance between elements when positional difference is 1.
  double get offsetPerPosition => staveSpace / 2;

  const NotationLayoutProperties({
    required double staveHeight,
  }) : _effectiveStaveHeight = staveHeight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotationLayoutProperties &&
        _effectiveStaveHeight == other._effectiveStaveHeight;
  }

  @override
  int get hashCode => _effectiveStaveHeight.hashCode;

  @override
  String toString() => 'NotationLayoutProperties(staveHeight: $staveHeight)';
}
