/// Represents the engraving default settings for the font.
///
/// These settings define various thicknesses and spacings used in music notation.
///
/// More info at: [engravingDefaults • Standard Music Font Layout](https://www.w3.org/2021/03/smufl14/specification/engravingdefaults.html)
class EngravingDefaults {
  /// An array containing the text font family (or families, in descending order of preference)
  /// that are ideally paired with this music font; this list may also use the
  /// generic font family values defined in CSS, i.e. *serif*, *sans-serif*,
  /// *cursive*, *fantasy*, and *monospace*. Generic font family names should be
  /// listed after specific font families.
  final List<String> textFontFamily;

  /// The thickness of the line used for the shaft of an arrow.
  final double arrowShaftThickness;

  /// The default distance between multiple thin barlines when locked together,
  /// e.g. between two thin barlines making a double barline, measured from
  /// the right-hand edge of the left barline to the left-hand edge of the right barline.
  final double barlineSeparation;

  /// The default distance between a pair of thin and thick barlines when
  /// locked together, e.g. between the thin and thick barlines making a final
  /// barline, or between the thick and thin barlines making a start repeat barline.
  final double thinThickBarlineSeparation;

  /// The distance between the inner edge of the primary and outer edge of subsequent secondary beams.
  final double beamSpacing;

  /// The thickness of a beam
  final double beamThickness;

  /// The thickness of the vertical line of a bracket grouping staves together.
  final double bracketThickness;

  /// The length of the dashes to be used in a dashed barline.
  final double dashedBarlineDashLength;

  /// The length of the gap between dashes in a dashed barline.
  final double dashedBarlineGapLength;

  /// The thickness of a dashed barline.
  final double dashedBarlineThickness;

  /// The thickness of a crescendo/diminuendo hairpin.
  final double hairpinThickness;

  /// The amount by which a ledger line should extend either side of a notehead,
  /// scaled proportionally with the notehead's size, e.g. when scaled down as a grace note
  final double ledgerLineExtension;

  /// The thickness of a ledger line (normally somewhat thicker than a staff line)
  final double ledgerLineThickness;

  /// The thickness of the lyric extension line to indicate a melisma in vocal music.
  final double lyricLineThickness;

  /// The thickness of the dashed line used for an octave line.
  final double octaveLineThickness;

  /// The thickness of the line used for piano pedaling.
  final double pedalLineThickness;

  /// The default horizontal distance between the dots and the inner barline of
  /// a repeat barline, measured from the edge of the dots to the edge of the barline.
  final double repeatBarlineDotSeparation;

  /// The thickness of the brackets drawn to indicate repeat endings.
  final double repeatEndingLineThickness;

  /// The thickness of the end of a slur.
  final double slurEndpointThickness;

  /// The thickness of the mid-point of a slur (i.e. its thickest point).
  final double slurMidpointThickness;

  /// The thickness of each staff line
  final double staffLineThickness;

  /// The thickness of a stem
  final double stemThickness;

  /// The thickness of the vertical line of a sub-bracket grouping staves
  /// belonging to the same instrument together
  final double subBracketThickness;

  /// The thickness of a box drawn around text instructions (e.g. rehearsal marks).
  final double textEnclosureThickness;

  /// The thickness of a thick barline, e.g. in a final barline or a repeat barline.
  final double thickBarlineThickness;

  /// The thickness of a thin barline, e.g. a normal barline, or each of the
  /// lines of a double barline.
  final double thinBarlineThickness;

  /// The thickness of the end of a tie.
  final double tieEndpointThickness;

  /// The thickness of the mid-point of a tie.
  final double tieMidpointThickness;

  /// The thickness of the brackets drawn either side of tuplet numbers.
  final double tupletBracketThickness;

  /// The thickness of the horizontal line drawn between two vertical lines,
  /// known as the H-bar, in a multi-bar rest.
  final double hBarThickness;

  /// Creates an instance of [EngravingDefaults] with all necessary fields.
  ///
  /// Example:
  /// ```dart
  /// var engravingDefaults = EngravingDefaults(
  ///   arrowShaftThickness: 0.16,
  ///   barlineSeparation: 0.6,
  ///   beamSpacing: 0.33,
  ///   // other parameters...
  /// );
  /// ```
  EngravingDefaults({
    required this.textFontFamily,
    required this.arrowShaftThickness,
    required this.barlineSeparation,
    required this.beamSpacing,
    required this.beamThickness,
    required this.bracketThickness,
    required this.dashedBarlineDashLength,
    required this.dashedBarlineGapLength,
    required this.dashedBarlineThickness,
    required this.hairpinThickness,
    required this.ledgerLineExtension,
    required this.ledgerLineThickness,
    required this.lyricLineThickness,
    required this.octaveLineThickness,
    required this.pedalLineThickness,
    required this.repeatBarlineDotSeparation,
    required this.repeatEndingLineThickness,
    required this.slurEndpointThickness,
    required this.slurMidpointThickness,
    required this.staffLineThickness,
    required this.stemThickness,
    required this.subBracketThickness,
    required this.textEnclosureThickness,
    required this.thickBarlineThickness,
    required this.thinBarlineThickness,
    required this.tieEndpointThickness,
    required this.tieMidpointThickness,
    required this.tupletBracketThickness,
    required this.thinThickBarlineSeparation,
    required this.hBarThickness,
  });

  /// Creates an [EngravingDefaults] object from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// var json = {
  ///   'arrowShaftThickness': 0.16,
  ///   'barlineSeparation': 0.6,
  ///   'beamSpacing': 0.33,
  ///   // other fields...
  /// };
  /// var engravingDefaults = EngravingDefaults.fromJson(json);
  /// ```
  factory EngravingDefaults.fromJson(Map<String, dynamic> json) {
    return EngravingDefaults(
      textFontFamily: List<String>.from(json['textFontFamily']),
      arrowShaftThickness: json['arrowShaftThickness'],
      barlineSeparation: json['barlineSeparation'],
      beamSpacing: json['beamSpacing'],
      beamThickness: json['beamThickness'],
      bracketThickness: json['bracketThickness'],
      dashedBarlineDashLength: json['dashedBarlineDashLength'],
      dashedBarlineGapLength: json['dashedBarlineGapLength'],
      dashedBarlineThickness: json['dashedBarlineThickness'],
      hairpinThickness: json['hairpinThickness'],
      ledgerLineExtension: json['legerLineExtension'],
      ledgerLineThickness: json['legerLineThickness'],
      lyricLineThickness: json['lyricLineThickness'],
      octaveLineThickness: json['octaveLineThickness'],
      pedalLineThickness: json['pedalLineThickness'],
      repeatBarlineDotSeparation: json['repeatBarlineDotSeparation'],
      repeatEndingLineThickness: json['repeatEndingLineThickness'],
      slurEndpointThickness: json['slurEndpointThickness'],
      slurMidpointThickness: json['slurMidpointThickness'],
      staffLineThickness: json['staffLineThickness'],
      stemThickness: json['stemThickness'],
      subBracketThickness: json['subBracketThickness'],
      textEnclosureThickness: json['textEnclosureThickness'],
      thickBarlineThickness: json['thickBarlineThickness'],
      thinBarlineThickness: json['thinBarlineThickness'],
      tieEndpointThickness: json['tieEndpointThickness'],
      tieMidpointThickness: json['tieMidpointThickness'],
      tupletBracketThickness: json['tupletBracketThickness'],
      thinThickBarlineSeparation: json['thinThickBarlineSeparation'],
      hBarThickness: json['hBarThickness'],
    );
  }
}

/// Represents a bounding box for a glyph, defined by its north-east and south-west corners.
class GlyphBBox {
  /// North-east corner coordinates of the bounding box.
  final List<double> bBoxNE;

  /// South-west corner coordinates of the bounding box.
  final List<double> bBoxSW;

  /// Creates an instance of [GlyphBBox].
  ///
  /// Example:
  /// ```dart
  /// var glyphBBox = GlyphBBox(
  ///   bBoxNE: [1.0, 1.5],
  ///   bBoxSW: [0.0, -1.0],
  /// );
  /// ```
  GlyphBBox({
    required this.bBoxNE,
    required this.bBoxSW,
  });

  /// Creates a [GlyphBBox] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// var json = {
  ///   'bBoxNE': [1.0, 1.5],
  ///   'bBoxSW': [0.0, -1.0]
  /// };
  /// var glyphBBox = GlyphBBox.fromJson(json);
  /// ```
  factory GlyphBBox.fromJson(Map<String, dynamic> json) {
    return GlyphBBox(
      bBoxNE: List<double>.from(json['bBoxNE']),
      bBoxSW: List<double>.from(json['bBoxSW']),
    );
  }
}

/// Represents an anchor point for a glyph with its name and coordinates.
class GlyphAnchor {
  /// The name of the anchor (e.g., "top", "bottom").
  final String name;

  /// Coordinates of the anchor point.
  final List<double> coordinates;

  /// Creates an instance of [GlyphAnchor].
  ///
  /// Example:
  /// ```dart
  /// var anchor = GlyphAnchor(
  ///   name: 'top',
  ///   coordinates: [0.0, 1.0],
  /// );
  /// ```
  GlyphAnchor({
    required this.name,
    required this.coordinates,
  });

  /// Creates a [GlyphAnchor] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// var json = {
  ///   'name': 'top',
  ///   'coordinates': [0.0, 1.0],
  /// };
  /// var anchor = GlyphAnchor.fromJson(json);
  /// ```
  factory GlyphAnchor.fromJson(Map<String, dynamic> json) {
    return GlyphAnchor(
      name: json['name'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}

/// Represents a glyph that contains a list of anchor points.
///
/// Each glyph is associated with a name and multiple anchors that define
/// its positioning or interaction within the font.
class GlyphWithAnchor {
  /// The name of the glyph (e.g., "accidentalSharp", "noteheadQuarter").
  final String glyphName;

  /// A list of anchor points associated with the glyph.
  ///
  /// Each anchor provides details about specific points on the glyph,
  /// such as where certain elements should attach.
  final List<GlyphAnchor> anchors;

  /// Creates an instance of [GlyphWithAnchor] with the specified glyph name and anchors.
  ///
  /// Example:
  /// ```dart
  /// var glyphWithAnchor = GlyphWithAnchor(
  ///   glyphName: 'noteheadQuarter',
  ///   anchors: [
  ///     GlyphAnchor(name: 'top', coordinates: [0.0, 1.0]),
  ///     GlyphAnchor(name: 'bottom', coordinates: [0.0, -1.0]),
  ///   ],
  /// );
  /// ```
  GlyphWithAnchor({
    required this.glyphName,
    required this.anchors,
  });

  /// Creates a [GlyphWithAnchor] from a JSON map.
  ///
  /// The [json] parameter must contain a `glyphName` and an `anchors` list.
  ///
  /// Example:
  /// ```dart
  /// var json = {
  ///   'glyphName': 'noteheadQuarter',
  ///   'anchors': [
  ///     {'name': 'top', 'coordinates': [0.0, 1.0]},
  ///     {'name': 'bottom', 'coordinates': [0.0, -1.0]}
  ///   ]
  /// };
  /// var glyphWithAnchor = GlyphWithAnchor.fromJson(json);
  /// ```
  factory GlyphWithAnchor.fromJson(Map<String, dynamic> json) {
    return GlyphWithAnchor(
      glyphName: json['glyphName'],
      anchors: (json['anchors'] as List)
          .map((anchor) => GlyphAnchor.fromJson(anchor))
          .toList(),
    );
  }
}

/// Represents the metadata of a font, including its name, version, engraving defaults, and glyph details.
class FontMetadata {
  /// The name of the font (e.g., "Sebastian").
  final String fontName;

  /// The version of the font (e.g., 1.07).
  final double fontVersion;

  /// Default engraving settings for the font, defining thicknesses and spacings.
  ///
  /// These settings affect how elements like beams, slurs, and barlines
  /// are rendered.
  final EngravingDefaults engravingDefaults;

  /// A map of bounding boxes for glyphs, where the key is the glyph's name and the value is its bounding box.
  ///
  /// Each [GlyphBBox] provides the north-east and south-west corners of
  /// the bounding box for the glyph.
  final Map<String, GlyphBBox> glyphBBoxes;

  /// A list of glyphs that contain anchor points.
  ///
  /// Each [GlyphWithAnchor] provides information about glyphs and their associated anchors
  /// that define specific points on the glyph for attachment or positioning.
  final List<GlyphWithAnchor> glyphsWithAnchors;

  /// Creates an instance of [FontMetadata] with the specified font details.
  ///
  /// Example:
  /// ```dart
  /// var fontMetadata = FontMetadata(
  ///   fontName: 'Sebastian',
  ///   fontVersion: 1.07,
  ///   engravingDefaults: EngravingDefaults(...),
  ///   glyphBBoxes: {
  ///     'noteheadQuarter': GlyphBBox(bBoxNE: [1.0, 1.5], bBoxSW: [0.0, -1.0]),
  ///     'accidentalSharp': GlyphBBox(bBoxNE: [1.0, 2.0], bBoxSW: [0.0, -1.5]),
  ///   },
  ///   glyphsWithAnchors: [
  ///     GlyphWithAnchor(glyphName: 'noteheadQuarter', anchors: [...])
  ///   ],
  /// );
  /// ```
  FontMetadata({
    required this.fontName,
    required this.fontVersion,
    required this.engravingDefaults,
    required this.glyphBBoxes,
    required this.glyphsWithAnchors,
  });

  /// Creates a [FontMetadata] object from a JSON map.
  ///
  /// This method extracts the font metadata, engraving defaults, glyph bounding boxes,
  /// and glyphs with anchors from the provided [json].
  ///
  /// Example:
  /// ```dart
  /// var json = {
  ///   'fontName': 'Sebastian',
  ///   'fontVersion': 1.07,
  ///   'engravingDefaults': { ... },
  ///   'glyphBBoxes': {
  ///     'noteheadQuarter': { 'bBoxNE': [1.0, 1.5], 'bBoxSW': [0.0, -1.0] }
  ///   },
  ///   'glyphsWithAnchors': [
  ///     {
  ///       'glyphName': 'noteheadQuarter',
  ///       'anchors': [
  ///         { 'name': 'top', 'coordinates': [0.0, 1.0] },
  ///         { 'name': 'bottom', 'coordinates': [0.0, -1.0] }
  ///       ]
  ///     }
  ///   ]
  /// };
  /// var fontMetadata = FontMetadata.fromJson(json);
  /// ```
  factory FontMetadata.fromJson(Map<String, dynamic> json) {
    // Parse glyph bounding boxes
    Map<String, GlyphBBox> bBoxes = {};
    if (json['glyphBBoxes'] != null) {
      json['glyphBBoxes'].forEach((key, value) {
        bBoxes[key] = GlyphBBox.fromJson(value);
      });
    }

    // Parse glyphs with anchors
    List<GlyphWithAnchor> glyphsWithAnchors = [];
    if (json['glyphsWithAnchors'] != null) {
      glyphsWithAnchors = (json['glyphsWithAnchors'] as List)
          .map((glyph) => GlyphWithAnchor.fromJson(glyph))
          .toList();
    }

    return FontMetadata(
      fontName: json['fontName'],
      fontVersion: json['fontVersion'],
      engravingDefaults: EngravingDefaults.fromJson(json['engravingDefaults']),
      glyphBBoxes: bBoxes,
      glyphsWithAnchors: glyphsWithAnchors,
    );
  }
}
