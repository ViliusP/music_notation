/// The line-end type specifies if there is a jog up or down (or both), an arrow, or
/// nothing at the start or end of a bracket.
class LineEnd {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LineEnd(this._value);

}