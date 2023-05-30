/// 
The notehead-value type indicates shapes other than the open and closed ovals
/// associated with note durations. 

The values do, re, mi, fa, fa up, so, la,
/// and ti correspond to Aikin's 7-shape system.  The fa up shape is typically used
/// with upstems; the fa shape is typically used with downstems or no stems.

The
/// arrow shapes differ from triangle and inverted triangle by being centered on the
/// stem. Slashed and back slashed notes include both the normal notehead and a
/// slash. The triangle shape has the tip of the triangle pointing up; the inverted
/// triangle shape has the tip of the triangle pointing down. The left triangle
/// shape is a right triangle with the hypotenuse facing up and to the left.

The
/// other notehead covers noteheads other than those listed here. It is usually used
/// in combination with the smufl attribute to specify a particular SMuFL notehead.
/// The smufl attribute may be used with any notehead value to help specify the
/// appearance of symbols that share the same MusicXML semantics. Noteheads in the
/// SMuFL Note name noteheads and Note name noteheads supplement ranges
/// (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the smufl attribute or the
/// "other" value, but instead use the notehead-text element.
class NoteheadValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  NoteheadValue(this._value);

}