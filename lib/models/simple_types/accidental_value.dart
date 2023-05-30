/// The accidental-value type represents notated accidentals supported by MusicXML.
/// In the MusicXML 2.0 DTD this was a string with values that could be included.
/// The XSD strengthens the data typing to an enumerated list. The quarter- and
/// three-quarters- accidentals are Tartini-style quarter-tone accidentals. The
/// -down and -up accidentals are quarter-tone accidentals that include arrows
/// pointing down or up. The slash- accidentals are used in Turkish classical music.
/// The numbered sharp and flat accidentals are superscripted versions of the
/// accidental signs, used in Turkish folk music. The sori and koron accidentals are
/// microtonal sharp and flat accidentals used in Iranian and Persian music. The
/// other accidental covers accidentals other than those listed here. It is usually
/// used in combination with the smufl attribute to specify a particular SMuFL
/// accidental. The smufl attribute may be used with any accidental value to help
/// specify the appearance of symbols that share the same MusicXML semantics.
class AccidentalValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  AccidentalValue(this._value);

}