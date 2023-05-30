/// The line-length type distinguishes between different line lengths for doit,
/// falloff, plop, and scoop articulations.
class LineLength {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LineLength(this._value);

}