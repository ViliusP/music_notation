import 'package:flutter/foundation.dart';
import 'package:music_notation/src/smufl/smufl_glyph.dart';
import 'package:music_notation/src/smufl/utilities.dart';

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
  final double? arrowShaftThickness;

  /// The default distance between multiple thin barlines when locked together,
  /// e.g. between two thin barlines making a double barline, measured from
  /// the right-hand edge of the left barline to the left-hand edge of the right barline.
  final double? barlineSeparation;

  /// The default distance between a pair of thin and thick barlines when
  /// locked together, e.g. between the thin and thick barlines making a final
  /// barline, or between the thick and thin barlines making a start repeat barline.
  final double? thinThickBarlineSeparation;

  /// The distance between the inner edge of the primary and outer edge of subsequent secondary beams.
  final double? beamSpacing;

  /// The thickness of a beam
  final double? beamThickness;

  /// The thickness of the vertical line of a bracket grouping staves together.
  final double? bracketThickness;

  /// The length of the dashes to be used in a dashed barline.
  final double? dashedBarlineDashLength;

  /// The length of the gap between dashes in a dashed barline.
  final double? dashedBarlineGapLength;

  /// The thickness of a dashed barline.
  final double? dashedBarlineThickness;

  /// The thickness of a crescendo/diminuendo hairpin.
  final double? hairpinThickness;

  /// The amount by which a ledger line should extend either side of a notehead,
  /// scaled proportionally with the notehead's size, e.g. when scaled down as a grace note
  final double? ledgerLineExtension;

  /// The thickness of a ledger line (normally somewhat thicker than a staff line)
  final double? ledgerLineThickness;

  /// The thickness of the lyric extension line to indicate a melisma in vocal music.
  final double? lyricLineThickness;

  /// The thickness of the dashed line used for an octave line.
  final double? octaveLineThickness;

  /// The thickness of the line used for piano pedaling.
  final double? pedalLineThickness;

  /// The default horizontal distance between the dots and the inner barline of
  /// a repeat barline, measured from the edge of the dots to the edge of the barline.
  final double? repeatBarlineDotSeparation;

  /// The thickness of the brackets drawn to indicate repeat endings.
  final double? repeatEndingLineThickness;

  /// The thickness of the end of a slur.
  final double? slurEndpointThickness;

  /// The thickness of the mid-point of a slur (i.e. its thickest point).
  final double? slurMidpointThickness;

  /// The thickness of each staff line
  final double? staffLineThickness;

  /// The thickness of a stem
  final double? stemThickness;

  /// The thickness of the vertical line of a sub-bracket grouping staves
  /// belonging to the same instrument together
  final double? subBracketThickness;

  /// The thickness of a box drawn around text instructions (e.g. rehearsal marks).
  final double? textEnclosureThickness;

  /// The thickness of a thick barline, e.g. in a final barline or a repeat barline.
  final double? thickBarlineThickness;

  /// The thickness of a thin barline, e.g. a normal barline, or each of the
  /// lines of a double barline.
  final double? thinBarlineThickness;

  /// The thickness of the end of a tie.
  final double? tieEndpointThickness;

  /// The thickness of the mid-point of a tie.
  final double? tieMidpointThickness;

  /// The thickness of the brackets drawn either side of tuplet numbers.
  final double? tupletBracketThickness;

  /// The thickness of the horizontal line drawn between two vertical lines,
  /// known as the H-bar, in a multi-bar rest.
  final double? hBarThickness;

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
  const EngravingDefaults({
    this.textFontFamily = const [],
    this.arrowShaftThickness,
    this.barlineSeparation,
    this.beamSpacing,
    this.beamThickness,
    this.bracketThickness,
    this.dashedBarlineDashLength,
    this.dashedBarlineGapLength,
    this.dashedBarlineThickness,
    this.hairpinThickness,
    this.ledgerLineExtension,
    this.ledgerLineThickness,
    this.lyricLineThickness,
    this.octaveLineThickness,
    this.pedalLineThickness,
    this.repeatBarlineDotSeparation,
    this.repeatEndingLineThickness,
    this.slurEndpointThickness,
    this.slurMidpointThickness,
    this.staffLineThickness,
    this.stemThickness,
    this.subBracketThickness,
    this.textEnclosureThickness,
    this.thickBarlineThickness,
    this.thinBarlineThickness,
    this.tieEndpointThickness,
    this.tieMidpointThickness,
    this.tupletBracketThickness,
    this.thinThickBarlineSeparation,
    this.hBarThickness,
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
      textFontFamily: List<String>.from(json['textFontFamily'] ?? []),
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
  /// North-east (top-right) corner coordinates of the bounding box.
  final Coordinates bBoxNE;

  /// South-west (bottom-left) corner coordinates of the bounding box.
  final Coordinates bBoxSW;

  /// Top-right (north-east) corner coordinates of the bounding box.
  Coordinates get topRight => bBoxNE;

  /// Bottom-left (south-west) corner coordinates of the bounding box.
  Coordinates get bottomLeft => bBoxSW;

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
      bBoxNE: Coordinates.fromList(List<double>.from(json['bBoxNE'])),
      bBoxSW: Coordinates.fromList(List<double>.from(json['bBoxSW'])),
    );
  }

  @override
  String toString() {
    return "NE: $bBoxNE, SW: $bBoxSW";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlyphBBox &&
        other.bBoxNE == bBoxNE &&
        other.bBoxSW == bBoxSW;
  }

  @override
  int get hashCode => bBoxNE.hashCode ^ bBoxSW.hashCode;
}

/// Represents an anchor point for a glyph with its name and coordinates.
class GlyphAnchor {
  /// The name of the anchor (e.g., "top", "bottom").
  final String name;

  /// Coordinates of the anchor point.
  final Coordinates coordinates;

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
      coordinates: Coordinates.fromList(List<double>.from(json['coordinates'])),
    );
  }
}

/// Represents the finite set of anchor fields
enum AnchorField {
  /// The exact position at which the bottom right-hand (south-east) corner of an
  /// angled upward-pointing stem connecting the right-hand side of a notehead to
  /// a vertical stem to its left should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  splitStemUpSE,

  /// The exact position at which the bottom left-hand (south-west) corner of an
  /// angled upward-pointing stem connecting the left-hand side of a notehead to
  /// a vertical stem to its right should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  splitStemUpSW,

  /// The exact position at which the top right-hand (north-east) corner of an
  /// angled downward-pointing stem connecting the right-hand side of a notehead
  /// to a vertical stem to its left should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  splitStemDownNE,

  /// The exact position at which the top left-hand (north-west) corner of an angled
  /// downward-pointing stem connecting the left-hand side of a notehead to a
  /// vertical stem to its right should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  splitStemDownNW,

  /// The exact position at which the bottom right-hand (south-east) corner of an
  /// upward-pointing stem rectangle should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  stemUpSE,

  /// The exact position at which the top left-hand (north-west) corner of a
  /// downward-pointing stem rectangle should start, relative to the glyph origin,
  /// expressed as Cartesian coordinates in staff spaces.
  stemDownNW,

  /// The amount by which an up-stem should be lengthened from its nominal unmodified
  /// length in order to ensure a good connection with a flag, in spaces.1
  stemUpNW,

  /// The amount by which a down-stem should be lengthened from its nominal unmodified
  /// length in order to ensure a good connection with a flag, in spaces.
  stemDownSW,

  /// The width in staff spaces of a given glyph that should be used for e.g.
  /// positioning leger lines correctly.*
  ///
  /// **Certain fonts, for example those that mimic music calligraphy, may include
  /// glyphs that are asymmetric by design, and where a simple calculation of the
  /// glyph’s bounding box will not provide the correct result for registering
  /// that glyph with other primitives. For example, a whole rest may be slightly
  /// oblique if mimicking a chisel nib pen, and for precise registration it may
  /// be necessary to specify its width independent of the glyph’s actual bounding box.*
  nominalWidth,

  /// The position in staff spaces that should be used to position numerals relative
  /// to clefs with ligated numbers where those numbers hang from the bottom of
  /// the clef, corresponding horizontally to the center of the numeral’s bounding box.
  numeralTop,

  /// The position in staff spaces that should be used to position numerals
  /// relative to clefs with ligatured numbers where those numbers sit on the
  /// baseline or at the north-east corner of the G clef, corresponding horizontally
  /// to the center of the numeral’s bounding box.
  numeralBottom,

  /// The Cartesian coordinates in staff spaces of the bottom left corner of a
  /// nominal rectangle that intersects the top right corner of the glyph’s
  /// bounding box. This rectangle, together with those in the other four corners
  /// of the glyph’s bounding box, can be cut out to produce a more detailed
  /// bounding box (of abutting rectangles), useful for kerning or interlocking
  /// symbols such as accidentals.
  cutOutNE,

  /// The Cartesian coordinates in staff spaces of the top left corner of a nominal
  /// rectangle that intersects the bottom right corner of the glyph’s bounding box.
  cutOutSE,

  /// The Cartesian coordinates in staff spaces of the top right corner of a
  /// nominal rectangle that intersects the bottom left corner of the glyph’s bounding box.
  cutOutSW,

  /// The Cartesian coordinates in staff spaces of the bottom right corner of a
  /// nominal rectangle that intersects the top left corner of the glyph’s bounding box.
  cutOutNW,

  /// The Cartesian coordinates in staff spaces of the position at which the
  /// glyph graceNoteSlashStemUp should be positioned relative to the stem-up
  /// flag of an unbeamed grace note; alternatively, the bottom left corner of
  /// a diagonal line drawn instead of using the above glyph.
  graceNoteSlashSW,

  /// The Cartesian coordinates in staff spaces of the top right corner of a
  /// diagonal line drawn instead of using the glyph graceNoteSlashStemUp for
  /// a stem-up flag of an unbeamed grace note.
  graceNoteSlashNE,

  /// The Cartesian coordinates in staff spaces of the position at which the glyph
  /// graceNoteSlashStemDown should be positioned relative to the stem-down flag
  /// of an unbeamed grace note; alternatively, the top left corner of a
  /// diagonal line drawn instead of using the above glyph.
  graceNoteSlashNW,

  /// The Cartesian coordinates in staff spaces of the bottom right corner of a
  /// diagonal line drawn instead of using the glyph graceNoteSlashStemDown
  /// for a stem-down flag of an unbeamed grace note.
  graceNoteSlashSE,

  /// The Cartesian coordinates in staff spaces of the horizontal position at
  /// which a glyph repeats, i.e. the position at which the same glyph or another
  /// of the same group should be positioned to ensure correct tessellation.
  /// This is used for e.g. multi-segment lines and the component glyphs that make up trills and mordents.
  repeatOffset,

  /// The Cartesian coordinates in staff spaces of the left-hand edge of a notehead
  /// with a non-zero left-hand side bearing (e.g. a double whole, or breve,
  /// notehead with two vertical lines at each side), to assist in the correct
  /// horizontal alignment of these noteheads with other noteheads with zero-width left-side bearings.
  noteheadOrigin,

  /// The Cartesian coordinates in staff spaces of the optical center of the glyph,
  /// to assist in the correct horizontal alignment of the glyph relative to a
  /// notehead or stem. Currently recommended for use with glyphs in the Dynamics range.
  opticalCenter;

  // A mapping of string keys to enum values
  static const Map<String, AnchorField> map = {
    'splitStemUpSE': AnchorField.splitStemUpSE,
    'splitStemUpSW': AnchorField.splitStemUpSW,
    'splitStemDownNE': AnchorField.splitStemDownNE,
    'splitStemDownNW': AnchorField.splitStemDownNW,
    'stemUpSE': AnchorField.stemUpSE,
    'stemDownNW': AnchorField.stemDownNW,
    'stemUpNW': AnchorField.stemUpNW,
    'stemDownSW': AnchorField.stemDownSW,
    'nominalWidth': AnchorField.nominalWidth,
    'numeralTop': AnchorField.numeralTop,
    'numeralBottom': AnchorField.numeralBottom,
    'cutOutNE': AnchorField.cutOutNE,
    'cutOutSE': AnchorField.cutOutSE,
    'cutOutSW': AnchorField.cutOutSW,
    'cutOutNW': AnchorField.cutOutNW,
    'graceNoteSlashSW': AnchorField.graceNoteSlashSW,
    'graceNoteSlashNE': AnchorField.graceNoteSlashNE,
    'graceNoteSlashNW': AnchorField.graceNoteSlashNW,
    'graceNoteSlashSE': AnchorField.graceNoteSlashSE,
    'repeatOffset': AnchorField.repeatOffset,
    'noteheadOrigin': AnchorField.noteheadOrigin,
    'opticalCenter': AnchorField.opticalCenter,
  };
}

// Class to represent glyphs with anchors using enum for anchor fields
class GlyphWithAnchor {
  final SmuflGlyph value;
  final Map<AnchorField, List<double>> anchors;

  /// Creates an instance of [GlyphWithAnchor] with a glyph name and anchors.
  GlyphWithAnchor({
    required this.value,
    required this.anchors,
  });

  /// Creates a [GlyphWithAnchor] from a JSON map.
  ///
  /// The JSON map should have keys that match the anchor field names and values that are coordinate arrays.
  factory GlyphWithAnchor.fromJson(
    String glyphName,
    Map<String, dynamic> json,
  ) {
    final Map<AnchorField, List<double>> anchors = {};

    // Iterate over the JSON map and populate the anchors map with enum keys
    json.forEach((key, value) {
      if (AnchorField.map.containsKey(key)) {
        anchors[AnchorField.map[key]!] = List<double>.from(value);
      }
    });
    SmuflGlyph smuflGlyph = GlyphUtilties.fromRawName(glyphName);

    return GlyphWithAnchor(
      value: smuflGlyph,
      anchors: anchors,
    );
  }

  /// Helper method to retrieve anchor data by [AnchorField].
  List<double>? getAnchor(AnchorField field) {
    return anchors[field];
  }
}

/// Represents the metadata of a font, including its name, version, engraving defaults, and glyph details.
class FontMetadata {
  /// The name of the font (e.g., "Sebastian").
  final String fontName;

  /// The version of the font (e.g., 1.07).
  final String fontVersion;

  /// Default engraving settings for the font, defining thicknesses and spacings.
  ///
  /// These settings affect how elements like beams, slurs, and barlines
  /// are rendered.
  final EngravingDefaults engravingDefaults;

  /// A map of bounding boxes for glyphs, where the key is the glyph's name and the value is its bounding box.
  ///
  /// Each [GlyphBBox] provides the north-east and south-west corners of
  /// the bounding box for the glyph.
  final Map<SmuflGlyph, GlyphBBox> glyphBBoxes;

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
  const FontMetadata({
    required this.fontName,
    required this.fontVersion,
    required this.engravingDefaults,
    required this.glyphBBoxes,
    required this.glyphsWithAnchors,
  });

  const FontMetadata.empty({
    this.fontName = "",
    this.fontVersion = "",
    this.engravingDefaults = const EngravingDefaults(),
    this.glyphBBoxes = const {},
    this.glyphsWithAnchors = const [],
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
    Map<SmuflGlyph, GlyphBBox> bBoxes = {};
    if (json['glyphBBoxes'] != null) {
      json['glyphBBoxes'].forEach((key, value) {
        try {
          SmuflGlyph smuflGlyph = GlyphUtilties.fromRawName(key);
          bBoxes[smuflGlyph] = GlyphBBox.fromJson(value);
        } catch (e) {
          if (kDebugMode) {
            print(
              "Error parsing bounding box for glyph: $key. Possible metadata inconsistency between SMuFL specification and font metadata.",
            );
          }
        }
      });
    }

    // Parse glyphs with anchors
    List<GlyphWithAnchor> glyphsWithAnchors = [];
    if (json['glyphsWithAnchors'] != null) {
      json['glyphsWithAnchors'].forEach((key, value) {
        try {
          glyphsWithAnchors.add(GlyphWithAnchor.fromJson(key, value));
        } catch (e) {
          if (kDebugMode) {
            print(
              "Error parsing anchors for glyph: $key. Possible metadata inconsistency between SMuFL specification and font metadata.",
            );
          }
        }
      });
    }

    return FontMetadata(
      fontName: json['fontName'],
      fontVersion: json['fontVersion'].toString(),
      engravingDefaults: EngravingDefaults.fromJson(json['engravingDefaults']),
      glyphBBoxes: bBoxes,
      glyphsWithAnchors: glyphsWithAnchors,
    );
  }
}

class Coordinates {
  final double x;
  final double y;

  const Coordinates({required this.x, required this.y});

  factory Coordinates.fromList(List<double> coordinates) {
    return Coordinates(x: coordinates[0], y: coordinates[1]);
  }

  @override
  String toString() {
    return "($x, $y)";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinates &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
