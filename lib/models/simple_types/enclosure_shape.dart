/// The enclosure-shape type describes the shape and presence / absence of an
/// enclosure around text or symbols. A bracket enclosure is similar to a rectangle
/// with the bottom line missing, as is common in jazz notation. An inverted-bracket
/// enclosure is similar to a rectangle with the top line missing.
class EnclosureShape {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  EnclosureShape(this._value);

}