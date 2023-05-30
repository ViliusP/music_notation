/// The smufl-glyph-name type is used for attributes that reference a specific
/// Standard Music Font Layout (SMuFL) character. The value is a SMuFL canonical
/// glyph name, not a code point. For instance, the value for a standard piano pedal
/// mark would be keyboardPedalPed, not U+E650.
class SmuflGlyphName {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  SmuflGlyphName(this._value);

}