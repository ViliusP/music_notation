/// Represents a glyph name in SMuFL (Standard Music Font Layout) metadata,
/// which defines a standardized set of musical symbols.
class GlyphName {
  /// The SMuFL glyph name.
  final String value;

  /// The Unicode codepoint value for the glyph.
  final String codepoint;

  /// An optional alternate Unicode codepoint value for the glyph.
  final String? alternateCodepoint;

  /// A description of the glyph.
  final String description;

  GlyphName({
    required this.value,
    required this.codepoint,
    required this.alternateCodepoint,
    required this.description,
  });

  /// Factory method to create a [GlyphName] object from [json]. Also it needs
  /// the SMuFL glyph [name].
  ///
  ///
  /// Example usage:
  /// ```dart
  /// final String name = 'accidentalSharp'; // Example SMuFL glyph name
  /// final Map<String, dynamic> jsonData = {
  ///   'codepoint': 'U+E262',
  ///   'alternateCodepoint': 'U+266F',
  ///   'description': 'Sharp'
  /// }; // Example JSON data
  ///
  /// final GlyphName glyphName = GlyphName.fromJson(name, jsonData);
  /// ```
  factory GlyphName.fromJson(String name, Map<String, dynamic> json) {
    return GlyphName(
      value: name,
      codepoint: json['codepoint'],
      alternateCodepoint: json['alternateCodepoint'],
      description: json['description'],
    );
  }

  /// Converts the [GlyphName] object to a JSON representation.
  ///
  /// Example usage:
  /// ```dart
  /// final GlyphName glyphName = GlyphName(
  ///   value: 'accidentalSharp',
  ///   codepoint: 'U+E262',
  ///   alternateCodepoint: 'U+266F',
  ///   description: 'Sharp',
  /// );
  ///
  /// final Map<String, dynamic> json = glyphName.toJson();
  /// print(json); // Outputs: {value: accidentalSharp, codepoint: U+E262, alternateCodepoint: U+266F, description: Sharp}
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'codepoint': codepoint,
      'alternateCodepoint': alternateCodepoint,
      'description': description,
    };
  }
}
