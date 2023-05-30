/// The line-width-type defines what type of line is being defined in a line-width
/// element. Values include beam, bracket, dashes, enclosure, ending, extend, heavy
/// barline, leger, light barline, octave shift, pedal, slur middle, slur tip,
/// staff, stem, tie middle, tie tip, tuplet bracket, and wedge. This is left as a
/// string so that other application-specific types can be defined, but it is made a
/// separate type so that it can be redefined more strictly.
class LineWidthType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LineWidthType(this._value);

}