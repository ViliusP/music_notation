/// The line-type type distinguishes between solid, dashed, dotted, and wavy lines.
class LineType {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LineType(this._value);

}