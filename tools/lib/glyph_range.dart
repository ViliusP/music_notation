/// A named range of glyphs in the Standard Music Font Layout (SMuFL) metadata.
/// Each range is associated with a specific category of musical symbols.
class GlyphRange {
  /// The name of the glyph range.
  /// This corresponds to the category of musical symbols that the range represents.
  /// For example, 'accordion' or 'analytics'.
  final String name;

  /// A brief description of the glyph range.
  /// This description typically provides additional context about the category of musical symbols.
  final String description;

  /// Glyph names in the range.
  /// Each name uniquely identifies a glyph within the SMuFL specification.
  final List<String> glyphs;

  /// The Unicode range start of the glyph range.
  /// This is a Unicode code point that specifies the start of the range in the SMuFL specification.
  final String start;

  /// The Unicode range end of the glyph range.
  /// This is a Unicode code point that specifies the end of the range in the SMuFL specification.
  final String end;

  /// Default constructor for Range.
  GlyphRange({
    required this.name,
    required this.description,
    required this.glyphs,
    required this.start,
    required this.end,
  });

  /// Creates a new [GlyphRange] from a JSON object.
  ///
  /// This is a factory constructor that takes a [name] and a JSON object ([json]).
  /// The JSON object is expected to have the keys 'description', 'glyphs', 'range_start', and 'range_end'.
  ///
  /// Example:
  ///
  /// ```dart
  /// var json = {
  ///   "description": "Analytics",
  ///   "glyphs": ["analyticsHauptstimme", "analyticsNebenstimme"],
  ///   "range_start": "U+E860",
  ///   "range_end": "U+E86F",
  /// };
  /// var range = GlyphRange.fromJson("analytics", json);
  /// ```
  factory GlyphRange.fromJson(String name, Map<String, dynamic> json) {
    return GlyphRange(
      name: name,
      description: json['description'],
      glyphs: List<String>.from(json['glyphs']),
      start: json['range_start'],
      end: json['range_end'],
    );
  }

  /// Converts the [GlyphRange] instance into a JSON map.
  ///
  /// It includes all the data of the [GlyphRange] in a JSON compatible format.
  /// The keys in the resulting map match those used in the [GlyphRange.fromJson] factory constructor.
  ///
  /// Example:
  ///
  /// ```dart
  /// var range = GlyphRange(
  ///   name: "analytics",
  ///   description: "Analytics",
  ///   glyphs: ["analyticsHauptstimme", "analyticsNebenstimme"],
  ///   start: "U+E860",
  ///   end: "U+E86F",
  /// );
  /// var json = range.toJson();
  /// ```
  ///
  /// In this example, `json` would be:
  ///
  /// ```dart
  /// {
  ///   "name": "analytics",
  ///   "description": "Analytics",
  ///   "glyphs": ["analyticsHauptstimme", "analyticsNebenstimme"],
  ///   "range_start": "U+E860",
  ///   "range_end": "U+E86F",
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'glyphs': glyphs,
      'range_start': start,
      'range_end': end,
    };
  }
}
