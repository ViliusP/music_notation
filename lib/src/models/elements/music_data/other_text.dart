/// A text element with a smufl attribute group. This type is used by MusicXML
/// direction extension elements to allow specification of specific SMuFL glyphs
/// without needed to add every glyph as a MusicXML element.
class OtherText {
  String value;

  /// Indicates a particular Standard Music Font Layout (SMuFL) character using
  /// its canonical glyph name. Sometimes this is a formatting choice, and
  /// sometimes this is a refinement of the semantic meaning of an element.
  String? smufl;

  OtherText({
    required this.value,
    this.smufl,
  });
}
