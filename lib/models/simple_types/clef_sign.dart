/// The clef-sign type represents the different clef symbols. The jianpu sign
/// indicates that the music that follows should be in jianpu numbered notation,
/// just as the TAB sign indicates that the music that follows should be in
/// tablature notation. Unlike TAB, a jianpu sign does not correspond to a visual
/// clef notation.

The none sign is deprecated as of MusicXML 4.0. Use the clef
/// element's print-object attribute instead. When the none sign is used, notes
/// should be displayed as if in treble clef.
class ClefSign {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ClefSign(this._value);

}