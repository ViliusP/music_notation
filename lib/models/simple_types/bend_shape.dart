/// The bend-shape type distinguishes between the angled bend symbols commonly used
/// in standard notation and the curved bend symbols commonly used in both tablature
/// and standard notation.
class BendShape {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  BendShape(this._value);

}